// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_page.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../page/edit_budget_or_income.dart';

part 'edit_monthly_event.dart';
part 'edit_monthly_state.dart';

class EditMonthlyBloc extends Bloc<EditMonthlyEvent, EditMonthlyState> {
  EditMonthlyBloc({
    required BuildContext context,
    required EditMonthlyMode monthlyMode,
    required SettingsRepository settingsRepo,
    required AuthRepository authRepo,
  })  : _monthlyMode = monthlyMode,
        _context = context,
        _settingsRepo = settingsRepo,
        _authRepo = authRepo,
        super(EditMonthlyState()) {
    on<SetAmountInput>(_setAmountInput);
    on<SaveNewMonthly>(_saveNewMonthly);
    on<InitialValue>(_initVal);
    on<ChangeTempRecDay>(_chnageTempRecDay);
  }

  final EditMonthlyMode _monthlyMode;
  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  final BuildContext _context;
  var mainContext = MainPage.navKeyMain.currentContext!;
  late double initMonthly;
  late int initDateRec;

  void _initVal(event, emit) {
    initMonthly = (_monthlyMode == EditMonthlyMode.income)
        ? _authRepo.currentUserModel!.monthlyIncome
        : _authRepo.currentUserModel!.monthlyBudget;
    initDateRec = _authRepo.currentUserModel!.recurringDay;
    emit(
      state.copyWith(
        amount: initMonthly * 1.0,
        dateRec: initDateRec,
      ),
    );
  }

  void _setAmountInput(SetAmountInput event, emit) {
    emit(state.copyWith(amount: event.newValue * 1.0));
  }

  void _chnageTempRecDay(ChangeTempRecDay event, emit) {
    emit(state.copyWith(dateRec: event.value));
  }

  void _saveNewMonthly(SaveNewMonthly event, _) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
      return;
    }

    if (initMonthly == state.amount || initDateRec == state.dateRec) {
      return;
    }

    loadingAuth(_context);
    try {
      final monValue = state.amount;
      final newRecDay = state.dateRec;

      await _settingsRepo.saveMonthlyBudgetAndIncome(
        userModel: _authRepo.currentUserModel!,
        monthlyIncome:
            (_monthlyMode == EditMonthlyMode.income) ? monValue : null,
        monthlyBudget:
            (_monthlyMode == EditMonthlyMode.budget) ? monValue : null,
        recurringDay:
            (_monthlyMode == EditMonthlyMode.income) ? newRecDay : null,
      );

      mainContext.read<ProfileBloc>().add(GetProfile());

      Navigator.of(_context)
        ..pop()
        ..pop();
    } on SocketException catch (e) {
      Logger.Red.log(e.message);

      Navigator.pop(_context);
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.noConnection,
      );
    }
  }
}
