import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cling/features/model/user_model.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route.dart';
import '../../../repository/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(
          authRepo.currentUser != null
              ? AppState.authenticated(authRepo.currentUser!)
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
    unawaited(_authRepo.logOut());
  }

  void _onRedirect(Redirect event, Emitter<AppState> _) {
    final redirect = ((state.status == AppStatus.authenticated) &&
        (_authRepo.loginStatus || _authRepo.registerStatus));

    if (redirect) {
      event.context.read<HomeBloc>()
        ..add(GetTotalIncome())
        ..add(GetTotalExpense());
    }

    Navigator.pushNamedAndRemoveUntil(
      event.context,
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
