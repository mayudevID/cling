// ignore_for_file: must_be_immutable

part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  UserModel userModel;
  String version;
  bool isVerified;
  bool isObscure;

  ProfileState({
    UserModel? userModel,
    this.version = "",
    this.isObscure = true,
    this.isVerified = true,
  }) : userModel = userModel ?? UserModel.empty();

  @override
  List<Object> get props => [
        userModel,
        isVerified,
        isObscure,
        version,
      ];

  ProfileState copyWith({
    UserModel? userModel,
    bool? isVerified,
    bool? isObscure,
    String? version,
  }) {
    return ProfileState(
      version: version ?? this.version,
      userModel: userModel ?? this.userModel,
      isVerified: isVerified ?? this.isVerified,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
