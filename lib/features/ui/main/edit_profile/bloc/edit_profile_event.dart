part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class ToggleEyeEditProfile extends EditProfileEvent {}

class InitialValueEdit extends EditProfileEvent {
  final String type;

  const InitialValueEdit(this.type);
}

class SaveNewProfile extends EditProfileEvent {}
