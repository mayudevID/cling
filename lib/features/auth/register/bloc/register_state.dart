// ignore_for_file: must_be_immutable

part of 'register_bloc.dart';

@immutable
class RegisterState extends Equatable {
  RegisterState({
    this.isEnableObscurePass = true,
    this.isEnableObscureConfirmPass = true,
  });

  bool isEnableObscurePass;
  bool isEnableObscureConfirmPass;

  @override
  List<Object> get props => [
        isEnableObscurePass,
        isEnableObscureConfirmPass,
      ];

  RegisterState copyWith({
    bool? isEnableObscurePass,
    bool? isEnableObscureConfirmPass,
  }) {
    return RegisterState(
      isEnableObscurePass: isEnableObscurePass ?? this.isEnableObscurePass,
      isEnableObscureConfirmPass:
          isEnableObscureConfirmPass ?? this.isEnableObscureConfirmPass,
    );
  }
}
