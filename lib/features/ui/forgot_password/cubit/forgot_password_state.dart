// ignore_for_file: must_be_immutable

part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  ForgotPasswordState({this.emailTarget = ""});
  String emailTarget;

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
