import 'dart:async';

import 'package:cling/core/logger.dart';
import 'package:cling/main.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route.dart';
import '../../repository/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(
          authRepo.currentUserModel != null
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

  final AuthRepository _authRepo;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    emit(
      event.user != null
          ? AppState.authenticated(event.user!)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_authRepo.logOut());
  }

  void _onRedirect(Redirect event, Emitter<AppState> _) {
    Logger.Green.log(
      "is Authenticated? ${(state.status == AppStatus.authenticated)}",
    );
    Logger.Green.log("loginProcess? ${_authRepo.loginProcess}");
    Logger.Green.log("registerProcess? ${_authRepo.registerProcess}");

    final redirect = ((state.status == AppStatus.authenticated) &&
        (_authRepo.loginProcess == false &&
            _authRepo.registerProcess == false));

    Navigator.pushNamedAndRemoveUntil(
      MainApp.navKeyGlobal.currentContext!,
      redirect ? RouteName.main : RouteName.onboard,
      (route) => false,
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
