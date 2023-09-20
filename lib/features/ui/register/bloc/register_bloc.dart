// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cling/core/exception.dart';
import 'package:cling/core/route.dart';
import 'package:cling/features/model/currency.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
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
      errorToast(
        AppLocalizations.of(_context)!.formEmpty,
      );
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorToast(
        AppLocalizations.of(_context)!.invalidEmailFailure,
      );
      return;
    }

    if (state.password.trim().length < 8) {
      errorToast(
        AppLocalizations.of(_context)!.passwordLengthFailure,
      );
      return;
    }

    if (state.password.trim() != state.confirmPassword.trim()) {
      errorToast(
        AppLocalizations.of(_context)!.passConfPassFailure,
      );
      return;
    }

    loadingAuth(_context);
    await _authRepository.logOut();
    //await _authRepository.saveRegisterProcess(true);

    try {
      await _authRepository.signUp(
        name: state.name.trim(),
        email: state.email.trim(),
        password: state.password.trim(),
        currency: state.selectedCurrency.value.countryCode!,
      );

      // await Future.wait([
      //   _authRepository.sendEmailVerification(),
      //   _authRepository.updateDisplayName(state.name.trim()),
      // ]);

      await _authRepository.logOut();
      //await _authRepository.saveRegisterProcess(false);

      Future.microtask(() {
        Navigator.pop(_context);
        Navigator.pushReplacementNamed(
          MainApp.navKeyGlobal.currentContext!,
          RouteName.registerSuccess,
        );
      });
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      Future.microtask(() {
        Navigator.pop(_context);
        errorToast(e.message);
      });
    } on SocketException catch (_) {
      Future.microtask(() {
        Navigator.pop(_context);
        errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
      });
    } on Exception catch (e) {
      _authRepository.logOut();
      Future.microtask(() {
        Navigator.pop(_context);
        errorToast(e.toString());
      });
    }
  }
}
