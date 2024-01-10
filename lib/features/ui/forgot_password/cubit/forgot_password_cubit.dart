// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/common_widget.dart';
import '../../../../core/logger.dart';
import '../../../../core/route.dart';
import '../../../../main.dart';
import '../../../repository/auth_repository.dart';
import '../../language_currency/lang_export.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required AuthRepository authRepo,
  })  : _authRepo = authRepo,
        super(ForgotPasswordState());

  final AuthRepository _authRepo;
  var mainContext = MainApp.navKeyGlobal.currentContext!;

  void changeEmail(String email) {
    emit(state.copyWith(emailTarget: email));
  }

  void sendResetPassword() async {
    loadingAuth(mainContext);

    if (!EmailValidator.validate(state.emailTarget)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.invalidEmailFailure,
      );
      return;
    }

    try {
      await _authRepo.sendResetPassword(state.emailTarget);
      Navigator.of(mainContext)
        ..pop()
        ..pushReplacementNamed(RouteName.checkEmail);
    } on Exception catch (e) {
      Logger.Red.log(e);
      Navigator.pop(mainContext);
    }
  }
}
