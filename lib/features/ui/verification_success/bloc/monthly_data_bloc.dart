// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cling/core/utils.dart';
import 'package:cling/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/logger.dart';
import '../../../../core/common_widget.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../language_currency/lang_export.dart';
import '../../main/main_page.dart';
import '../../main/profile/bloc/profile_bloc.dart';
import '../widget/text_field_monthly_data.dart';

part 'monthly_data_event.dart';
part 'monthly_data_state.dart';

class MonthlyDataBloc extends Bloc<MonthlyDataEvent, MonthlyDataState> {
  MonthlyDataBloc({
    required BuildContext context,
    required SettingsRepository settingsRepo,
    required AuthRepository authRepo,
  })  : _settingsRepo = settingsRepo,
        _context = context,
        _authRepo = authRepo,
        super(MonthlyDataState()) {
    on<SetIncome>(_setIncome);
    on<SetBudget>(_setBudget);
    on<SetState>(_setState);
    on<SetFinish>(_setFinish);
    on<RecDay>(_recDay);
  }

  final SettingsRepository _settingsRepo;
  final BuildContext _context;
  final AuthRepository _authRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _recDay(RecDay event, emit) {
    emit(state.copyWith(dateRec: event.dateRec));
  }

  void _setIncome(SetIncome event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.incomeMustAbove0,
      );
    } else {
      try {
        double.parse(amount);
        emit(
          state.copyWith(
            monIncome: data,
          ),
        );
        add(SetState(VerifOnboardPos.budget));
      } on FormatException {
        errorSnackbar(
          _context,
          AppLocalizations.of(_context)!.invalidAmount,
        );
      }
    }
  }

  void _setBudget(SetBudget event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.budgetMustAbove0,
      );
    } else {
      try {
        double.parse(amount);
        emit(
          state.copyWith(
            monBudget: data,
          ),
        );

        // * Set Monthly Budget and Spent
        add(SetFinish());
      } on FormatException {
        errorSnackbar(
          _context,
          AppLocalizations.of(_context)!.invalidAmount,
        );
      }
    }
  }

  void _setState(SetState event, emit) {
    emit(state.copyWith(state: event.state));

    switch (event.state) {
      case VerifOnboardPos.income:
        //* (Back Condition)
        //* Save Month Budget
        state.monBudget = TextFieldMonthlyData.textEditingController.text;
        //* Get Month Income
        TextFieldMonthlyData.textEditingController.text = state.monIncome;
        break;
      case VerifOnboardPos.budget:
        //* Get Month Budget
        TextFieldMonthlyData.textEditingController.text = state.monBudget;
        break;
    }

    TextFieldMonthlyData.textEditingController.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset: TextFieldMonthlyData.textEditingController.text.length,
      ),
    );
  }

  void _setFinish(event, emit) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.noConnection,
      );
      return;
    }

    loadingAuth(_context);
    try {
      final monIncome = double.parse(state.monIncome.removeDot);
      final monBudget = double.parse(state.monBudget.removeDot);

      await _settingsRepo.saveMonthlyBudgetAndIncome(
        userModel: _authRepo.currentUserModel!,
        monthlyIncome: monIncome.toDouble(),
        monthlyBudget: monBudget.toDouble(),
        recurringDay: state.dateRec,
      );

      mainContext.read<ProfileBloc>().add(GetProfile());

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(
          MainApp.navKeyGlobal.currentContext!,
          (route) => route.isFirst,
        );
      });
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
