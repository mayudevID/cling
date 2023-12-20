part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class SendLogout extends ProfileEvent {}

class GoBackup extends ProfileEvent {}

class GetProfile extends ProfileEvent {}

class GetVerifiedStatus extends ProfileEvent {}
