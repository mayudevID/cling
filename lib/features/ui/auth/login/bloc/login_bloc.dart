import 'package:cling/core/exception.dart';

import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:cling/features/ui/auth/login/page/login_page.dart';
import 'package:cling/features/ui/language/lang_export.dart';
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
      errorToast("Form empty");
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorToast(
        AppLocalizations.of(LoginPage.navKeyLogin.currentContext!)!
            .invalidEmailFailure,
      );
      return;
    }

    if (state.password.trim().length < 8) {
      errorToast("Password must be 8 character or more");
      return;
    }

    loadingAuth(LoginPage.navKeyLogin.currentContext!);
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
            await dialogEmailNotVerified(LoginPage.navKeyLogin.currentContext!);
          },
        );
      }

      AnimationOnboard.animC1.dispose();
      AnimationOnboard.animC2.dispose();
      AnimationOnboard.animC3.dispose();
      AnimationOnboard.animC4.dispose();
      await Future.delayed(const Duration(milliseconds: 250));

      Future.microtask(() {
        LoginPage.navKeyLogin.currentContext!
            .read<AppBloc>()
            .add(const Redirect());
      });
    } on LogInWithEmailAndPasswordFailure catch (e) {
      _authRepository.logOut();
      Future.microtask(() {
        Navigator.pop(LoginPage.navKeyLogin.currentContext!);
        errorToast(e.message);
      });
    }
  }
}
