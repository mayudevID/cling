// ignore_for_file: must_be_immutable

part of 'login_bloc.dart';

class LoginState extends Equatable {
  LoginState({
    this.isObscure = true,
  });

  bool isObscure;

  @override
  List<Object> get props => [isObscure];

  LoginState copyWith({
    bool? isObscure,
  }) {
    return LoginState(
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
