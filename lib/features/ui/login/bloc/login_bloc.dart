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
import '../../../../main.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/backup_integrity.dart';
import '../../../repository/database_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../app_bloc/app_bloc.dart';
import '../../main/home/bloc/home_bloc.dart';
import '../../main/transaction/bloc/transaction_bloc.dart';
import '../../main/statistics/bloc/statistics_bloc.dart';
import '../../main/profile/bloc/profile_bloc.dart';
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
    on<ResumeSavedSession>(_resumeSavedSession);
    on<LoginAnonymous>(_loginAnony);
  }

  final DatabaseRepository _dbRepo;
  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  BuildContext get mainContext => MainApp.navKeyGlobal.currentContext!;

  void _toggleEye(ToggleEye event, Emitter<LoginState> emit) {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  void _changeEmail(ChangeEmail event, emit) {
    emit(state.copyWith(email: event.email));
  }

  void _changePassword(ChangePassword event, emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _sendLogin(SendLogin event, Emitter<LoginState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final online = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
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

    if (!online) {
      // Passwords cannot be verified offline. A saved Firebase session has
      // its own explicit action and never uses the password field.
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
      return;
    }

    loadingAuth(mainContext);

    try {
      await _authRepo.logInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      // Activate the authenticated account's isolated database before any
      // read, recurring generation or cloud restore.
      await _dbRepo.switchAccount(_authRepo.currentUserFirebase!.uid);
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

      // Reconcile local recurring rules with account settings, including
      // the case where a previously active rule was disabled in Firestore.
      // Fetch the authoritative server settings and then reconcile local
      // recurring income; this also clears any interrupted settings write.
      try {
        await _settingsRepo.reconcileCurrentAccountSettingsFromServer();
      } on FirebaseException catch (error) {
        if (!AuthRepository.isTemporaryServiceFailure(error) ||
            _authRepo
                    .cachedProfileForUser(_authRepo.currentUserFirebase!.uid) ==
                null) {
          rethrow;
        }
        // Logged-in users may read their isolated local transactions while
        // Firestore is unavailable. Recurring generation remains suspended.
        Logger.Yellow.log('Account settings reconciliation deferred: $error');
      } on SocketException catch (error) {
        if (_authRepo
                .cachedProfileForUser(_authRepo.currentUserFirebase!.uid) ==
            null) {
          rethrow;
        }
        Logger.Yellow.log(
          'Offline account settings; recurring deferred: $error',
        );
      }

      await _finishLoginNavigation();
    } on EmailNotVerifiedException catch (_) {
      Logger.Red.log("EmailNotVerified");
      await _authRepo.logOut();
      await _dbRepo.switchAccount(null);
      Navigator.pop(mainContext);
      dialogEmailNotVerified(mainContext);
    } on FirebaseAuthException catch (e) {
      Logger.Red.log("FirebaseAuthException: $e");
      if (AuthRepository.isTemporaryServiceFailure(e)) {
        // Keep any previously authenticated session for the separate
        // 'Continue saved session' action, but never silently resume it.
        Navigator.pop(mainContext);
        errorSnackbar(
          mainContext,
          AppLocalizations.of(mainContext)!.noConnection,
        );
        return;
      }
      await _authRepo.logOut();
      await _dbRepo.switchAccount(null);
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        LogInWithEmailAndPasswordFailure.fromCode(e.code).message,
      );
    } on SocketException catch (e) {
      Logger.Red.log("SocketException: $e");
      // A connection failure is not evidence that the entered password
      // was valid. Preserve the existing session without logging in.
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
    } on Exception catch (e) {
      Logger.Red.log("Exception: $e");
      await _authRepo.logOut();
      await _dbRepo.switchAccount(null);
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        const LogInWithEmailAndPasswordFailure().message,
      );
    }
  }

  Future<void> _resumeSavedSession(
    ResumeSavedSession event,
    Emitter<LoginState> emit,
  ) async {
    final user = _authRepo.currentUserFirebase;
    final profile =
        user == null ? null : _authRepo.cachedProfileForUser(user.uid);
    if (!_authRepo.canResumeSavedSession || user == null || profile == null) {
      errorSnackbar(
        mainContext,
        'Tidak ada sesi tersimpan yang dapat dilanjutkan.',
      );
      return;
    }

    loadingAuth(mainContext);
    try {
      await _dbRepo.switchAccount(user.uid);
      if (_authRepo.currentUserFirebase?.uid != user.uid ||
          _dbRepo.activeUserId != user.uid) {
        throw StateError('Sesi akun berubah saat dipulihkan.');
      }
      await _authRepo.saveLoginProcess(false);
      await _authRepo.saveRegisterProcess(false);
      mainContext.read<LangCurrencyBloc>().add(
            ChangeCurrency(selectedCurrency: profile.currency),
          );
      // Reuse an existing authenticated session. This does not authenticate
      // the password typed into the sign-in form and never claims to.
      // Recurring entries are not generated from stale offline settings.
      await _finishLoginNavigation();
    } catch (error) {
      Logger.Red.log('Unable to resume saved session: $error');
      Navigator.pop(mainContext);
      errorSnackbar(
        mainContext,
        'Sesi tersimpan tidak dapat dilanjutkan. Coba lagi.',
      );
    }
  }

  Future<void> _finishLoginNavigation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    mainContext.read<ProfileBloc>()
      ..add(GetProfile())
      ..add(GetVerifiedStatus());
    mainContext.read<HomeBloc>()
      ..add(GetIncomeExpenseAmountTotalCurrMonth())
      ..add(GetGoalsHomeWithCount())
      ..add(GetTodayExpenses())
      ..add(GetNotificationCount());
    mainContext.read<TransactionBloc>().add(GetData());
    mainContext.read<StatisticsBloc>()
      ..add(GetIncomeExpenseTotalAllMonth())
      ..add(GetMost())
      ..add(GetYearlyIncome())
      ..add(GetIncomeBreakdown())
      ..add(GetExpenseBreakdownAndPieData());
    // AppBloc chooses dashboard vs onboarding from the *persisted* profile,
    // for both fresh logins and restored sessions.
    mainContext.read<AppBloc>().add(const Redirect());
  }

  void _loginAnony(LoginAnonymous event, emit) {}

  Future<void> _getBackup() async {
    var retry = false;
    do {
      final connectivity = await Connectivity().checkConnectivity();
      if (!(connectivity.contains(ConnectivityResult.mobile) ||
          connectivity.contains(ConnectivityResult.wifi))) {
        retry = await dialogNoInternetGetBackup(mainContext);
        continue;
      }
      try {
        await _settingsRepo.getBackup();
        retry = false;
      } on RestoreConflictException {
        final confirmed = await showDialog<bool>(
              context: mainContext,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi restore data lokal'),
                content: const Text(
                  'Data keuangan lokal kemungkinan lebih baru daripada '
                  'backup cloud. Melanjutkan restore akan mengganti data aktif. '
                  'Salinan database lokal akan tetap disimpan di perangkat. '
                  'Yakin ingin melanjutkan?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Lanjutkan restore'),
                  ),
                ],
              ),
            ) ??
            false;
        if (confirmed) {
          try {
            await _settingsRepo.getBackup(allowOverwriteNewerLocal: true);
          } on Exception catch (error) {
            errorSnackbar(mainContext, 'Restore gagal: $error');
          }
        }
        retry = false;
      } on Exception catch (error) {
        errorSnackbar(mainContext, 'Restore gagal: $error');
        retry = false;
      }
    } while (retry);
  }
}
