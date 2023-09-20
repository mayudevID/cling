part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ToggleEyePass extends RegisterEvent {}

class ToggleEyeConfirmPass extends RegisterEvent {}

class ChangeEmail extends RegisterEvent {
  const ChangeEmail(this.email);

  final String email;
}

class ChangePassword extends RegisterEvent {
  const ChangePassword(this.password);

  final String password;
}

class ChangeConfPassword extends RegisterEvent {
  const ChangeConfPassword(this.confPassword);

  final String confPassword;
}

class ChangeName extends RegisterEvent {
  const ChangeName(this.name);

  final String name;
}

class ChangeCurrency extends RegisterEvent {
  const ChangeCurrency(this.currency);

  final Currency currency;
}

class SendRegister extends RegisterEvent {
  const SendRegister();
}
