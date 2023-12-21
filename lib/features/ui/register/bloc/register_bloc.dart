// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cling/core/exception.dart';
import 'package:cling/core/logger.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/model/currency.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget.dart';
import '../../../repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required BuildContext context,
    required AuthRepository authRepo,
  })  : _authRepository = authRepo,
        _context = context,
        super(RegisterState()) {
    on<ToggleEyePass>(_toggleEyePass);
    on<ToggleEyeConfirmPass>(_toggleEyeConfirmPass);
    on<SendRegister>(_onSendRegister);
    on<ChangeName>(_onChangeName);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
    on<ChangeConfPassword>(_onChangeConfPassword);
    on<ChangeCurrency>(_onChangeCurrency);
  }

  final AuthRepository _authRepository;
  final BuildContext _context;

  void _toggleEyePass(
    ToggleEyePass event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isEnableObscurePass: !state.isEnableObscurePass,
      ),
    );
  }

  void _toggleEyeConfirmPass(
    ToggleEyeConfirmPass event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        isEnableObscureConfirmPass: !state.isEnableObscureConfirmPass,
      ),
    );
  }

  void _onChangeName(
    ChangeName event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onChangeEmail(
    ChangeEmail event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onChangePassword(
    ChangePassword event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onChangeConfPassword(
    ChangeConfPassword event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confPassword));
  }

  void _onChangeCurrency(
    ChangeCurrency event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(selectedCurrency: event.currency));
  }

  void _onSendRegister(SendRegister event, _) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.noConnection,
      );
      return;
    }

    if (state.email.trim().isEmpty ||
        state.password.trim().isEmpty ||
        state.name.trim().isEmpty ||
        state.confirmPassword.trim().isEmpty) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.formEmpty,
      );
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.invalidEmailFailure,
      );
      return;
    }

    if (state.password.trim().length < 8) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.passwordLengthFailure,
      );
      return;
    }

    if (state.password.trim() != state.confirmPassword.trim()) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.passConfPassFailure,
      );
      return;
    }

    loadingAuth(_context);
    await _authRepository.logOut();

    try {
      await _authRepository.signUp(
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password.trim(),
        currency: state.selectedCurrency.value.countryCode!,
      );

      Navigator.of(_context)
        ..pop()
        ..pushReplacementNamed(RouteName.registerSuccess);
    } on FirebaseAuthException catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      Navigator.pop(_context);
      errorSnackbar(
          _context, SignUpWithEmailAndPasswordFailure.fromCode(e.code).message);
    } on SocketException catch (e) {
      Logger.Red.log("SocketException: $e");
      Navigator.pop(_context);
      errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
    } catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      Navigator.pop(_context);
      errorSnackbar(
        _context,
        const SignUpWithEmailAndPasswordFailure().message,
      );
    }

    await _authRepository.logOut();
  }
}
