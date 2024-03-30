// ignore_for_file: use_build_context_synchronously

import 'package:cling/core/common_widget.dart';
import 'package:cling/core/exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../main.dart';
import '../../../../model/currency.dart';
import '../../../../model/user_model.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/database_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../app_bloc/app_bloc.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/bloc/home_bloc.dart';
import '../../settings/widget/dialog_go_backup.dart';
import '../../statistics/bloc/statistics_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthRepository authRepo,
    required DatabaseRepository dbRepo,
    required SettingsRepository settingsRepo,
  })  : _authRepo = authRepo,
        _dbRepo = dbRepo,
        _settingsRepo = settingsRepo,
        super(ProfileState()) {
    on<SendLogout>(_sendLogout);
    on<GetProfile>(_getProfile);
    on<GetVerifiedStatus>(_getVerifiedStatus);
    on<GoBackup>(_goBackup);
  }

  final AuthRepository _authRepo;
  final DatabaseRepository _dbRepo;
  final SettingsRepository _settingsRepo;
  var mainContext = MainApp.navKeyGlobal.currentContext!;

  void _sendLogout(event, emit) async {
    try {
      Navigator.pop(mainContext);
      loadingAuth(mainContext);
      _freeResources();
      Future.wait([
        _authRepo.logOut(),
        _dbRepo.deleteAllTable(),
      ]).then((_) async {
        mainContext.read<AppBloc>().add(const Redirect());
        await Future.delayed(const Duration(milliseconds: 100));
        // ignore: use_buildmainContext_synchronously
        mainContext.read<LangCurrencyBloc>().add(
              const ChangeCurrency(
                selectedCurrency: Currency.idr,
              ),
            );
      });
    } on LogOutFailure catch (_) {
      errorSnackbar(
        mainContext,
        "Error Logout",
      );
    }
  }

  void _getProfile(
    GetProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    emit(
      state.copyWith(
        userModel: _authRepo.currentUserModel,
        version: "v${packageInfo.version} + ${packageInfo.buildNumber}",
      ),
    );
  }

  void _getVerifiedStatus(event, emit) {
    final isVerified =
        (_authRepo.currentUserFirebase!.emailVerified == false) ? false : true;
    emit(state.copyWith(isVerified: isVerified));
  }

  void _goBackup(event, emit) async {
    final resultDialog = await dialogGoBackup(mainContext);
    if (!resultDialog) {
      return;
    }
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult[0] == ConnectivityResult.mobile ||
        connectivityResult[0] == ConnectivityResult.wifi)) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.noConnection,
      );
      return;
    }
    loadingAuth(mainContext);
    await _settingsRepo.backupData();
    await _settingsRepo.editBackupTime(userModel: state.userModel);
    add(GetProfile());
    Navigator.pop(mainContext);
  }

  void _freeResources() async {
    mainContext.read<HomeBloc>().add(FreeResourcesHome());
    mainContext.read<StatisticsBloc>().add(FreeResourcesStats());
  }
}
