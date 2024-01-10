// ignore_for_file: use_buildmainContext_synchronously, use_build_context_synchronously
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common_widget.dart';
import '../../../../core/exception.dart';
import '../../../../core/logger.dart';
import '../../../../core/route.dart';
import '../../../../main.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/database_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../app_bloc/app_bloc.dart';
import '../../language_currency/lang_currency_bloc.dart';
import '../../language_currency/lang_export.dart';
import '../widgets/dialog_email_not_verified.dart';
import '../widgets/dialog_get_backup.dart';
import '../widgets/dialog_no_internet_get_backup.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required DatabaseRepository dbRepo,
    required SettingsRepository settingsRepo,
    required AuthRepository authRepo,
  })  : _dbRepo = dbRepo,
        _settingsRepo = settingsRepo,
        _authRepo = authRepo,
        super(LoginState()) {
    on<ToggleEye>(_toggleEye);
    on<ChangeEmail>(_changeEmail);
    on<ChangePassword>(_changePassword);
    on<SendLogin>(_sendLogin);
    on<LoginAnonymous>(_loginAnony);
  }

  final DatabaseRepository _dbRepo;
  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  var mainContext = MainApp.navKeyGlobal.currentContext!;

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
      errorSnackbar(
          mainContext, AppLocalizations.of(mainContext)!.noConnection);
      return;
    }

    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
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

    loadingAuth(mainContext);
    await _authRepo.logOut();

    try {
      final isVerifiedNotPassed = await _authRepo.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      mainContext.read<LangCurrencyBloc>().add(
            ChangeCurrency(
              selectedCurrency: _authRepo.currentUserModel!.currency,
            ),
          );

      //* ~~~~ CHECK BACKUP ~~~~
      if (_authRepo.currentUserModel!.lastBackupTime != null) {
        Navigator.pop(mainContext);
        final result = await dialogGetBackup(
          mainContext,
          _authRepo.currentUserModel!.lastBackupTime!,
        );
        loadingAuth(mainContext);
        if (result) await _getBackup();
      }

      await Future.delayed(const Duration(milliseconds: 100));

      mainContext.read<AppBloc>().add(const Redirect());

      if (isVerifiedNotPassed) {
        Future.delayed(
          const Duration(milliseconds: 1250),
          () {
            Navigator.pushNamed(
              MainApp.navKeyGlobal.currentContext!,
              RouteName.verifOnboard,
            );
            // Navigator.pushNamedAndRemoveUntil(
            //   MainApp.navKeyGlobal.currentContext!,
            //   RouteName.verifOnboard,
            //   (route) =>
            //       (route.settings.name != RouteName.verifOnboard) ||
            //       route.isFirst,
            // );
          },
        );
      }
    } on EmailNotVerifiedException catch (_) {
      Logger.Red.log("EmailNotVerified");
      await _authRepo.logOut();
      Navigator.pop(mainContext);
      dialogEmailNotVerified(mainContext);
    } on FirebaseAuthException catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      await _authRepo.logOut();
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        LogInWithEmailAndPasswordFailure.fromCode(e.code).message,
      );
    } on SocketException catch (e) {
      Logger.Red.log("SocketException: $e");
      await _authRepo.logOut();
      Navigator.pop(mainContext);
      errorSnackbar(
          mainContext, AppLocalizations.of(mainContext)!.noConnection);
    } on Exception catch (e) {
      Logger.Red.log("Exception: $e");
      await _authRepo.logOut();
      Navigator.pop(mainContext);
      errorSnackbar(
          mainContext, const LogInWithEmailAndPasswordFailure().message);
    }
  }

  void _loginAnony(LoginAnonymous event, emit) {}

  Future<void> _getBackup() async {
    late bool result;
    do {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi)) {
        //* No Connection
        result = await dialogNoInternetGetBackup(mainContext);
      } else {
        try {
          await _dbRepo.close();
          await _settingsRepo.getBackup();
          await _dbRepo.open();
        } on Exception catch (_) {
          errorSnackbar(
              mainContext, AppLocalizations.of(mainContext)!.noConnection);
        }
        result = false;
      }
    } while (result);
  }
}
