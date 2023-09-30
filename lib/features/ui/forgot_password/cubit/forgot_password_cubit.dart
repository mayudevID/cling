// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required BuildContext context,
    required AuthRepository authRepo,
  })  : _authRepo = authRepo,
        _context = context,
        super(ForgotPasswordState());

  final BuildContext _context;
  final AuthRepository _authRepo;

  void changeEmail(String email) {
    emit(state.copyWith(emailTarget: email));
  }

  void sendResetPassword() async {
    loadingAuth(_context);

    if (!EmailValidator.validate(state.emailTarget)) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.invalidEmailFailure,
      );
      return;
    }

    try {
      await _authRepo.sendResetPassword(state.emailTarget);
      Navigator.of(_context)
        ..pop()
        ..pushReplacementNamed(RouteName.checkEmail);
    } on Exception catch (e) {
      Logger.Red.log(e);
      Navigator.pop(_context);
    }
  }
}
