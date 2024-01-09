// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously
import 'package:cling/core/exception.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/main/edit_profile/widget/text_field_email_edit_profile.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../main.dart';
import '../../../language_currency/lang_export.dart';
import '../widget/dialog_change_email_or_pass.dart';
import '../widget/text_field_name_edit_profile.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required SettingsRepository settingsRepo,
    required AuthRepository authRepo,
  })  : _settingsRepo = settingsRepo,
        _authRepo = authRepo,
        super(EditProfileState()) {
    on<ToggleEyeEditProfile>(_toggleEye);
    on<InitialValueEdit>(_initVal);
    on<SaveNewName>(_saveNewName);
    on<SaveNewEmail>(_saveNewEmail);
    on<CheckEmail>(_checkEmail);
    on<CheckName>(_checkName);
    on<ChangePassword>(_changePassword);
  }

  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  var mainContext = MainApp.navKeyGlobal.currentContext!;

  void _initVal(InitialValueEdit event, emit) {
    final userOld = _authRepo.currentUserFirebase;

    switch (event.type) {
      case "name":
        emit(state.copyWith(initName: userOld!.displayName));
        TextFieldNameEditProfile.textEditingController.text =
            userOld.displayName!;
        break;
      case "email":
        emit(state.copyWith(initEmail: userOld!.email));
        TextFieldEmailEditProfile.textEditingController.text = userOld.email!;
        break;
    }
  }

  void _toggleEye(event, emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  void _checkName(CheckName event, emit) {
    final isSame = TextFieldNameEditProfile.textEditingController.text.trim() ==
        state.initName.trim();
    emit(state.copyWith(isNameSame: isSame));
  }

  void _checkEmail(CheckEmail event, emit) {
    final isSame =
        TextFieldEmailEditProfile.textEditingController.text.trim() ==
            state.initEmail.trim();
    emit(state.copyWith(isEmailSame: isSame));
  }

  void _saveNewName(event, emit) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
      return;
    }

    String? newName =
        TextFieldNameEditProfile.textEditingController.text.trim();

    if (newName.isEmpty || newName.length <= 4) {
      errorToast(AppLocalizations.of(mainContext)!.nameEmpty);
      return;
    }

    loadingAuth(mainContext);

    try {
      await _settingsRepo.editProfileName(newName: newName);

      mainContext.read<ProfileBloc>().add(GetProfile());

      emit(state.copyWith(initName: newName, isNameSame: true));

      Navigator.pop(mainContext);
    } catch (e) {
      Logger.Red.log(e.toString());
    }
  }

  void _saveNewEmail(event, emit) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
      return;
    }

    String? newEmail =
        TextFieldEmailEditProfile.textEditingController.text.trim();

    if (newEmail.isEmpty) {
      errorToast(AppLocalizations.of(mainContext)!.emailEmpty);
      return;
    }

    if (!EmailValidator.validate(newEmail)) {
      errorToast(AppLocalizations.of(mainContext)!.invalidEmailFailure);
      return;
    }

    if (newEmail != state.initEmail) {
      final result = await dialogChangeEmailOrPassword(mainContext, "email");
      Logger.Green.log("ChangeE? $result");
      if (!result) return;
    }

    loadingAuth(mainContext);

    try {
      await _settingsRepo.editProfileEmail(newEmail: newEmail);

      mainContext.read<ProfileBloc>()
        ..add(GetProfile())
        ..add(GetVerifiedStatus());

      emit(state.copyWith(initEmail: newEmail, isEmailSame: true));

      Navigator.pop(mainContext);
    } on FirebaseAuthException catch (e) {
      errorSnackbar(
        mainContext,
        EditProfileFailure.fromCode(e.code).message,
      );
    }
  }

  void _changePassword(ChangePassword event, _) async {
    final result = await dialogChangeEmailOrPassword(mainContext, "pass");
    Logger.Green.log("ChangeP? $result");
    if (!result) return;

    await _authRepo.sendResetPassword(state.initEmail);
  }
}
