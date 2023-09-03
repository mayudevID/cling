// ignore_for_file: must_be_immutable

part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  UserModel userModel;

  ProfileState({
    UserModel? userModel,
  }) : userModel = userModel ?? UserModel.empty();

  @override
  List<Object> get props => [userModel];

  ProfileState copyWith({UserModel? userModel}) {
    return ProfileState(
      userModel: userModel ?? this.userModel,
    );
  }
}
