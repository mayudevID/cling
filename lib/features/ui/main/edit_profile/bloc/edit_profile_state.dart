part of 'edit_profile_bloc.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();
  
  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}
