// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cling/core/exception.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/auth/bloc/app_bloc.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../widgets/dialog_email_not_verified.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authRepo,
    required BuildContext context,
  })  : _authRepo = authRepo,
        _context = context,
        super(LoginState()) {
    on<ToggleEye>(_toggleEye);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendLogin>(_sendLogin);
    on<LoginAnonymous>(_loginAnony);
  }

  final AuthRepository _authRepo;
  final BuildContext _context;

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
      errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
      return;
    }

    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
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

    loadingAuth(_context);
    await _authRepo.logOut();
    //await _authRepo.saveLoginProcess(true);

    try {
      await _authRepo.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      _context.read<LangCurrencyBloc>().add(
            ChangeCurrency(
              selectedCurrency: _authRepo.currentUserModel!.currency,
            ),
          );
      await Future.delayed(const Duration(milliseconds: 100));

      _context.read<AppBloc>().add(const Redirect());
    } on AuthException catch (e) {
      _authRepo.logOut();
      Logger.Red.log("Status: ${e.statusCode} Message: ${e.message}");
      if (e.statusCode == '400' && e.message == "Email not confirmed") {
        await dialogEmailNotVerified(_context);
      }
      Navigator.pop(_context);
      errorToast(e.message);
    } on LogInWithEmailAndPasswordFailure catch (e) {
      _authRepo.logOut();

      Navigator.pop(_context);
      errorToast(e.message);
    } on SocketException catch (_) {
      _authRepo.logOut();

      Navigator.pop(_context);
      errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
    } on Exception catch (e) {
      _authRepo.logOut();

      Navigator.pop(_context);
      errorToast(e.toString());
    }
  }

  void _loginAnony(LoginAnonymous event, emit) {}
}
