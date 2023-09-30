// ignore_for_file: must_be_immutable

part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  String emailTarget;
  ForgotPasswordState({this.emailTarget = ""});

  @override
  List<Object> get props => [emailTarget];

  ForgotPasswordState copyWith({
    String? emailTarget,
  }) {
    return ForgotPasswordState(
      emailTarget: emailTarget ?? this.emailTarget,
    );
  }
}
