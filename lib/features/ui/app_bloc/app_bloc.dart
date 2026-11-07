import 'dart:async';

import '../../../core/logger.dart';
import '../../../main.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route.dart';
import '../../repository/auth_repository.dart';
import '../../repository/database_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthRepository authRepo,
    required DatabaseRepository dbRepo,
  })  : _authRepo = authRepo,
        _dbRepo = dbRepo,
        super(
          _prepared(authRepo, dbRepo, authRepo.currentUserFirebase)
              ? AppState.authenticated(authRepo.currentUserFirebase!)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<Redirect>(_onRedirect);
    _userSubscription = _authRepo.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  static bool _prepared(
    AuthRepository authRepo,
    DatabaseRepository dbRepo,
    User? user,
  ) {
    final cached = authRepo.currentUserModel;
    return user != null &&
        cached?.uid == user.uid &&
        dbRepo.activeUserId == user.uid &&
        dbRepo.isReady;
  }

  /// Single routing policy for cold starts, password sign-in and resuming
  /// a persisted session. Email verification and monthly onboarding are
  /// independent conditions.
  static String routeForAccount({
    required bool isReady,
    required bool emailVerified,
    required bool loginInProgress,
    required bool registrationInProgress,
    required bool onboardingCompleted,
  }) {
    if (!isReady || !emailVerified ||
        loginInProgress || registrationInProgress) {
      return RouteName.onboard;
    }
    return onboardingCompleted ? RouteName.main : RouteName.verifOnboard;
  }

  final AuthRepository _authRepo;
  final DatabaseRepository _dbRepo;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    if (event.user == null) {
      emit(const AppState.unauthenticated());
    } else if (_prepared(_authRepo, _dbRepo, event.user)) {
      emit(AppState.authenticated(event.user!));
    } else {
      // Firebase has emitted a user, but the matching local data is not
      // ready yet. Never navigate to the finance dashboard in this state.
      emit(const AppState.initializing());
    }
  }

  Future<void> _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) async {
    await _dbRepo.switchAccount(null);
    await _authRepo.logOut();
    emit(const AppState.unauthenticated());
  }

  void _onRedirect(Redirect event, Emitter<AppState> emit) {
    // Evaluate readiness now, not a possibly stale queued auth event.
    final user = _authRepo.currentUserFirebase;
    final ready = _prepared(_authRepo, _dbRepo, user);
    emit(
      ready ? AppState.authenticated(user!) : const AppState.unauthenticated(),
    );
    Logger.Green.log('Auth and account database ready? $ready');

    final route = routeForAccount(
      isReady: ready,
      emailVerified: user?.emailVerified == true,
      loginInProgress: _authRepo.loginProcess,
      registrationInProgress: _authRepo.registerProcess,
      onboardingCompleted: _authRepo.currentUserModel?.verifiedProcess == true,
    );
    Navigator.pushNamedAndRemoveUntil(
      MainApp.navKeyGlobal.currentContext!,
      route,
      (route) => false,
    );
  }

  bool get isRedirect {
    return (_prepared(_authRepo, _dbRepo, _authRepo.currentUserFirebase) &&
        (_authRepo.loginProcess == false &&
            _authRepo.registerProcess == false));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
