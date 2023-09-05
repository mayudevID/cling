import 'dart:io';

import 'package:cling/core/exception.dart';

import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:cling/features/ui/auth/login/page/login_page.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(LoginState()) {
    on<ToggleEye>(_toggleEye);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendLogin>(_sendLogin);
    on<LoginAnonymous>(_loginAnony);
  }

  final AuthRepository _authRepo;
  var context = LoginPage.navKeyLogin.currentContext;

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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(context!, AppLocalizations.of(context!)!.noConnection);
      return;
    }

    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
      errorToast(
        AppLocalizations.of(context!)!.formEmpty,
      );
      return;
    }

    if (!EmailValidator.validate(state.email)) {
      errorToast(
        AppLocalizations.of(context!)!.invalidEmailFailure,
      );
      return;
    }

    if (state.password.trim().length < 8) {
      errorToast(
        AppLocalizations.of(context!)!.passwordLengthFailure,
      );
      return;
    }

    loadingAuth(context!);
    await _authRepo.logOut();
    //await _authRepo.saveLoginProcess(true);

    try {
      await _authRepo.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      Future.microtask(() {
        context!.read<AppBloc>().add(const Redirect());
      });
    } on LogInWithEmailAndPasswordFailure catch (e) {
      _authRepo.logOut();

      Navigator.pop(context!);
      errorToast(e.message);
    } on SocketException catch (_) {
      _authRepo.logOut();

      Navigator.pop(context!);
      errorSnackbar(context!, AppLocalizations.of(context!)!.noConnection);
    } on Exception catch (e) {
      _authRepo.logOut();

      Navigator.pop(context!);
      errorToast(e.toString());
    }
  }

  void _loginAnony(LoginAnonymous event, emit) {}
}
