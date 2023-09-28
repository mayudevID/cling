// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required BuildContext context,
    required AuthRepository authRepo,
  })  : _authRepo = authRepo,
        _context = context,
        super(ForgotPasswordInitial());

  final BuildContext _context;
  final AuthRepository _authRepo;

  void sendResetPassword() async {
    try {
      loadingAuth(_context);
      await _authRepo.sendResetPassword();
      Navigator.of(_context)
        ..pop()
        ..pushReplacementNamed(RouteName.checkEmail);
    } on Exception catch (e) {
      Logger.Red.log(e);
      Navigator.pop(_context);
    }
  }
}
