// ignore_for_file: must_be_immutable

part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  UserModel userModel;
  bool isVerified;
  bool isObscure;

  ProfileState({
    UserModel? userModel,
    this.isObscure = true,
    this.isVerified = true,
  }) : userModel = userModel ?? UserModel.empty();

  @override
  List<Object> get props => [
        userModel,
        isVerified,
        isObscure,
      ];

  ProfileState copyWith({
    UserModel? userModel,
    bool? isVerified,
    bool? isObscure,
  }) {
    return ProfileState(
      userModel: userModel ?? this.userModel,
      isVerified: isVerified ?? this.isVerified,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
