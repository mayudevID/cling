import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cling/features/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/route.dart';
import '../../../repository/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser != null
              ? AppState.authenticated(authenticationRepository.currentUser!)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<Redirect>(_onRedirect);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  final AuthRepository _authenticationRepository;
  late final StreamSubscription<UserModel?> _userSubscription;

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
    unawaited(_authenticationRepository.logOut());
  }

  void _onRedirect(Redirect event, Emitter<AppState> _) {
    Navigator.pushNamedAndRemoveUntil(
      event.context,
      ((state.status == AppStatus.authenticated) &&
              (_authenticationRepository.loginStatus ||
                  _authenticationRepository.registerStatus))
          ? RouteName.main
          : RouteName.onboard,
      (route) => false,
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
