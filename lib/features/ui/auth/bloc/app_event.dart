part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final UserModel? user;
}

class CheckStatus extends AppEvent {
  const CheckStatus(this.context);

  final BuildContext context;
}
