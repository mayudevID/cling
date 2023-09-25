// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/main/edit_profile/widget/text_field_email_edit_profile.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../language_currency/lang_export.dart';
import '../widget/dialog_change_email.dart';
import '../widget/text_field_name_edit_profile.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required SettingsRepository settingsRepo,
    required AuthRepository authRepo,
    required BuildContext context,
  })  : _context = context,
        _settingsRepo = settingsRepo,
        _authRepo = authRepo,
        super(EditProfileState()) {
    on<ToggleEyeEditProfile>(_toggleEye);
    on<InitialValueEdit>(_initVal);
    on<SaveNewProfile>(_saveNewData);
  }

  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  final BuildContext _context;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _initVal(InitialValueEdit event, emit) {
    final userOld = _authRepo.currentUserModel;

    switch (event.type) {
      case "name":
        emit(state.copyWith(initName: userOld!.name));
        TextFieldNameEditProfile.textEditingController.text = userOld.name;
        break;
      case "email":
        emit(state.copyWith(initEmail: userOld!.email));
        TextFieldEmailEditProfile.textEditingController.text = userOld.email;
        break;
    }
  }

  void _toggleEye(event, emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  void _saveNewData(event, emit) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.noConnection,
      );
      return;
    }

    String? newName =
        TextFieldNameEditProfile.textEditingController.text.trim();
    String? newEmail =
        TextFieldEmailEditProfile.textEditingController.text.trim();

    if (newName.isEmpty || newName.length <= 4) {
      errorToast(AppLocalizations.of(_context)!.nameEmpty);
      return;
    }

    if (newEmail.isEmpty) {
      errorToast(AppLocalizations.of(_context)!.emailEmpty);
      return;
    }

    if (!EmailValidator.validate(newEmail)) {
      errorToast(AppLocalizations.of(_context)!.invalidEmailFailure);
      return;
    }

    if (newEmail != state.initEmail) {
      await dialogChangeEmail(_context);
    }

    loadingAuth(_context);

    try {
      await _settingsRepo.editProfileSave(
        userOld: _authRepo.currentUserModel!,
        newEmail: newEmail,
        newName: newName,
      );

      mainContext.read<ProfileBloc>()
        ..add(GetProfile())
        ..add(GetVerifiedStatus());

      Navigator.of(_context)
        ..pop()
        ..pop();
    } catch (e) {}
  }
}
