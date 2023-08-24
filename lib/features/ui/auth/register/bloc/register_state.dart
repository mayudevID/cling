// ignore_for_file: must_be_immutable

part of 'register_bloc.dart';

@immutable
class RegisterState extends Equatable {
  RegisterState({
    this.isEnableObscurePass = true,
    this.isEnableObscureConfirmPass = true,
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
    this.name = "",
    this.selectedCurrency = Currency.idr,
  });

  bool isEnableObscurePass;
  bool isEnableObscureConfirmPass;
  String name;
  String email;
  String password;
  String confirmPassword;
  Currency selectedCurrency;

  @override
  List<Object> get props => [
        isEnableObscurePass,
        isEnableObscureConfirmPass,
        email,
        password,
        confirmPassword,
        selectedCurrency,
        name,
      ];

  RegisterState copyWith({
    bool? isEnableObscurePass,
    bool? isEnableObscureConfirmPass,
    String? email,
    String? password,
    String? name,
    String? confirmPassword,
    Currency? selectedCurrency,
  }) {
    return RegisterState(
      isEnableObscurePass: isEnableObscurePass ?? this.isEnableObscurePass,
      isEnableObscureConfirmPass:
          isEnableObscureConfirmPass ?? this.isEnableObscureConfirmPass,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
    );
  }
}
