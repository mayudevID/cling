// ignore_for_file: must_be_immutable

part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {

  EditProfileState({
    this.isObscure = true,
    this.initName = "",
    this.initEmail = "",
    this.initPass = "",
    this.isNameSame = true,
    this.isEmailSame = true,
  });
  bool isObscure;
  String initName;
  String initEmail;
  String initPass;
  bool isNameSame;
  bool isEmailSame;

  @override
  List<Object> get props => [
        isObscure,
        initName,
        initEmail,
        initPass,
        isEmailSame,
        isNameSame,
      ];

  EditProfileState copyWith({
    bool? isObscure,
    String? initName,
    String? initEmail,
    String? initPass,
    bool? isEmailSame,
    bool? isNameSame,
  }) {
    return EditProfileState(
      isObscure: isObscure ?? this.isObscure,
      initName: initName ?? this.initName,
      initEmail: initEmail ?? this.initEmail,
      initPass: initPass ?? this.initPass,
      isEmailSame: isEmailSame ?? this.isEmailSame,
      isNameSame: isNameSame ?? this.isNameSame,
    );
  }
}
