import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cling/core/exception.dart';
import 'package:cling/core/route.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget.dart';
import '../../../../repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authRepository) : super(RegisterState()) {
    on<ToggleEyePass>(_toggleEyePass);
    on<ToggleEyeConfirmPass>(_toggleEyeConfirmPass);
    on<SendRegister>(_onSendRegister);
    on<ChangeName>(_onChangeName);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
    on<ChangeConfPassword>(_onChangeConfPassword);
  }

  final AuthRepository _authRepository;

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

  void _onSendRegister(SendRegister event, _) async {
    if (state.email.trim().isEmpty ||
        state.password.trim().isEmpty ||
        state.name.trim().isEmpty ||
        state.confirmPassword.trim().isEmpty) {
      errorSnackbar(event.context, "Form empty");
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorSnackbar(event.context, "Email not valid");
      return;
    }

    if (state.password.trim().length < 8) {
      errorSnackbar(event.context, "Password must be 8 character or more");
      return;
    }

    if (state.password.trim() != state.confirmPassword.trim()) {
      errorSnackbar(
        event.context,
        "Password and Confirm Password do not match",
      );
      return;
    }

    loadingAuth(event.context);
    await _authRepository.logOut();
    await _authRepository.saveRegisterStatus(false);

    try {
      await _authRepository.signUp(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      await Future.wait([
        _authRepository.sendEmailVerification(),
        _authRepository.updateDisplayName(state.name.trim()),
      ]);

      await _authRepository.logOut();
      await _authRepository.saveRegisterStatus(true);

      Future.microtask(() {
        Navigator.pop(event.context);
        Navigator.pushReplacementNamed(
          event.context,
          RouteName.registerSuccess,
        );
      });
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      Future.microtask(() {
        Navigator.pop(event.context);
        errorSnackbar(event.context, e.message);
      });
    } on Exception catch (e) {
      _authRepository.logOut();
      Future.microtask(() {
        Navigator.pop(event.context);
        errorSnackbar(event.context, e.toString());
      });
    }
  }
}
