part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class ToggleEyeEditProfile extends EditProfileEvent {}

class InitialValueEdit extends EditProfileEvent {

  const InitialValueEdit(this.type);
  final String type;
}

class CheckName extends EditProfileEvent {}

class CheckEmail extends EditProfileEvent {}

class SaveNewName extends EditProfileEvent {}

class SaveNewEmail extends EditProfileEvent {}

class ChangePassword extends EditProfileEvent {}
