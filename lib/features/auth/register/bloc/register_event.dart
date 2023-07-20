part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ToggleEyePass extends RegisterEvent {}

class ToggleEyeConfirmPass extends RegisterEvent {}
