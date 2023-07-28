import 'package:cling/core/exception.dart';

import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../onboard/widgets/animation_onboard.dart';
import '../widgets/dialog_email_not_verified.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(LoginState()) {
    on<ToggleEye>(_toggleEye);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendLogin>(_sendLogin);
  }

  final AuthRepository _authRepository;

  void _toggleEye(ToggleEye event, Emitter<LoginState> emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  void _changeEmail(ChangeEmail event, emit) {
    emit(state.copyWith(email: event.email));
  }

  void _changePassword(ChangePassword event, emit) {
    emit(state.copyWith(password: event.password));
  }

  void _sendLogin(SendLogin event, _) async {
    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
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

    loadingAuth(event.context);
    await _authRepository.logOut();
    await _authRepository.saveLoginStatus(false);

    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      await _authRepository.saveLoginStatus(true);

      if (!_authRepository.currentUser!.emailVerified) {
        await Future.microtask(
          () async {
            await dialogEmailNotVerified(event.context);
          },
        );
      }

      AnimationOnboard.animC1.dispose();
      AnimationOnboard.animC2.dispose();
      AnimationOnboard.animC3.dispose();
      AnimationOnboard.animC4.dispose();
      await Future.delayed(const Duration(milliseconds: 250));

      Future.microtask(() {
        event.context.read<AppBloc>().add(Redirect(event.context));
      });
    } on LogInWithEmailAndPasswordFailure catch (e) {
      _authRepository.logOut();
      Future.microtask(() {
        Navigator.pop(event.context);
        errorSnackbar(event.context, e.message);
      });
    }
  }
}
