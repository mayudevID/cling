// ignore_for_file: must_be_immutable

part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  bool isObscure;
  String initName;
  String initEmail;
  String initPass;

  EditProfileState({
    this.isObscure = true,
    this.initName = "",
    this.initEmail = "",
    this.initPass = "",
  });

  @override
  List<Object> get props => [
        isObscure,
        initName,
        initEmail,
        initPass,
      ];

  EditProfileState copyWith({
    bool? isObscure,
    String? initName,
    String? initEmail,
    String? initPass,
  }) {
    return EditProfileState(
      isObscure: isObscure ?? this.isObscure,
      initName: initName ?? this.initName,
      initEmail: initEmail ?? this.initEmail,
      initPass: initPass ?? this.initPass,
    );
  }
}
