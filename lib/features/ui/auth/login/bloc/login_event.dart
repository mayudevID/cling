part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class ToggleEye extends LoginEvent {}

class ChangeEmail extends LoginEvent {
  const ChangeEmail(this.email);

  final String email;
}

class ChangePassword extends LoginEvent {
  const ChangePassword(this.password);

  final String password;
}

class SendLogin extends LoginEvent {
  const SendLogin();
}
