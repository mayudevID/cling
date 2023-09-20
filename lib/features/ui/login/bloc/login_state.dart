// ignore_for_file: must_be_immutable

part of 'login_bloc.dart';

class LoginState extends Equatable {
  LoginState({
    this.isObscure = true,
    this.email = "",
    this.password = "",
  });

  bool isObscure;
  String email;
  String password;

  @override
  List<Object?> get props => [
        isObscure,
        email,
        password,
      ];

  LoginState copyWith({
    bool? isObscure,
    String? email,
    String? password,
  }) {
    return LoginState(
      isObscure: isObscure ?? this.isObscure,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
