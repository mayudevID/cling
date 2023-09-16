// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_field_monthly_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/logger.dart';
import '../../main_page.dart';

part 'monthly_data_event.dart';
part 'monthly_data_state.dart';

class MonthlyDataBloc extends Bloc<MonthlyDataEvent, MonthlyDataState> {
  MonthlyDataBloc({
    required BuildContext context,
    required SettingsRepository settingsRepo,
  })  : _settingsRepo = settingsRepo,
        _context = context,
        super(MonthlyDataState()) {
    on<SetIncome>(_setIncome);
    on<SetBudget>(_setBudget);
    on<SetState>(_setState);
    on<SetFinish>(_setFinish);
  }

  final SettingsRepository _settingsRepo;
  final BuildContext _context;
  var mainContext = MainPage.navKeyMain.currentContext!;

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
      final monIncome = int.parse(state.monIncome.removeDot);
      final monBudget = int.parse(state.monBudget.removeDot);

      await _settingsRepo.saveMonthlyBudgetAndIncome(
        monthlyIncome: monIncome,
        monthlyBudget: monBudget,
      );

      mainContext.read<ProfileBloc>().add(GetProfile());

      Navigator.of(_context)
        ..pop()
        ..pop()
        ..pop();
    } on SocketException catch (e) {
      Logger.Red.log(e.message);

      Navigator.pop(_context);
      errorSnackbar(
        _context,
        AppLocalizations.of(_context)!.noConnection,
      );
    } on PostgrestException catch (e) {
      Logger.Red.log(e.message);

      Navigator.pop(_context);
      errorSnackbar(
        _context,
        e.message,
      );
    }
  }
}
