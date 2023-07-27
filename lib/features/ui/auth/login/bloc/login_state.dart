// ignore_for_file: must_be_immutable

part of 'login_bloc.dart';

enum LoginStatus { init, load, success }

class LoginState extends Equatable {
  LoginState(
      {this.isObscure = true,
      this.email = "",
      this.password = "",
      this.status = LoginStatus.init});

  bool isObscure;
  String email;
  String password;
  LoginStatus status;

  @override
  List<Object?> get props => [
        isObscure,
        email,
        password,
        status,
      ];

  LoginState copyWith({
    bool? isObscure,
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      isObscure: isObscure ?? this.isObscure,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
