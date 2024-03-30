// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget.dart';
import '../../../../core/exception.dart';
import '../../../../core/logger.dart';
import '../../../../core/route.dart';
import '../../../../main.dart';
import '../../../model/currency.dart';
import '../../../repository/auth_repository.dart';
import '../../language_currency/lang_export.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthRepository authRepo,
  })  : _authRepository = authRepo,
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
  var mainContext = MainApp.navKeyGlobal.currentContext!;

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
    if (!(connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
      return;
    }

    if (state.email.trim().isEmpty ||
        state.password.trim().isEmpty ||
        state.name.trim().isEmpty ||
        state.confirmPassword.trim().isEmpty) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.formEmpty,
      );
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.invalidEmailFailure,
      );
      return;
    }

    if (state.password.trim().length < 8) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.passwordLengthFailure,
      );
      return;
    }

    if (state.password.trim() != state.confirmPassword.trim()) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.passConfPassFailure,
      );
      return;
    }

    loadingAuth(mainContext);
    await _authRepository.logOut();

    try {
      await _authRepository.signUp(
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password.trim(),
        currency: state.selectedCurrency.value.countryCode!,
      );

      Navigator.of(mainContext)
        ..pop()
        ..pushReplacementNamed(RouteName.registerSuccess);
    } on FirebaseAuthException catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      Navigator.pop(mainContext);
      errorSnackbar(mainContext,
          SignUpWithEmailAndPasswordFailure.fromCode(e.code).message);
    } on SocketException catch (e) {
      Logger.Red.log("SocketException: $e");
      Navigator.pop(mainContext);
      errorSnackbar(
          mainContext, AppLocalizations.of(mainContext)!.noConnection);
    } catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        const SignUpWithEmailAndPasswordFailure().message,
      );
    }

    await _authRepository.logOut();
  }
}
