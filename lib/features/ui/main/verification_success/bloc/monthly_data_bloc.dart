import 'dart:io';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_field_mothly_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/logger.dart';
import '../page/monthly_data_page.dart';

part 'monthly_data_event.dart';
part 'monthly_data_state.dart';

class MonthlyDataBloc extends Bloc<MonthlyDataEvent, MonthlyDataState> {
  MonthlyDataBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(MonthlyDataState()) {
    on<SetIncome>(_setIncome);
    on<SetBudget>(_setBudget);
    on<SetState>(_setState);
    on<SetFinish>(_setFinish);
  }

  final SettingsRepository _settingsRepo;
  var context = MonthlyDataPage.verifOnboardNavKey.currentContext;

  void _setIncome(SetIncome event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        context!,
        AppLocalizations.of(context!)!.incomeMustAbove0,
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
          context!,
          AppLocalizations.of(context!)!.invalidAmount,
        );
      }
    }
  }

  void _setBudget(SetBudget event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        context!,
        AppLocalizations.of(context!)!.budgetMustAbove0,
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
          context!,
          AppLocalizations.of(context!)!.invalidAmount,
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
        context!,
        AppLocalizations.of(context!)!.noConnection,
      );
      return;
    }

    loadingAuth(context!);
    try {
      final monIncome = int.parse(state.monIncome.removeDot);
      final monBudget = int.parse(state.monBudget.removeDot);

      await _settingsRepo.saveMonthlyBudgetAndIncome(
        monthlyIncome: monIncome,
        monthlyBudget: monBudget,
      );

      Future.microtask(() {
        MainPage.navigatorKeyMain.currentContext!
            .read<ProfileBloc>()
            .add(GetProfile());
      });

      Navigator.of(context!)
        ..pop()
        ..pop()
        ..pop();
    } on SocketException catch (e) {
      Logger.Red.log(e.message);

      Navigator.pop(context!);
      errorSnackbar(
        context!,
        AppLocalizations.of(context!)!.noConnection,
      );
    } on PostgrestException catch (e) {
      Logger.Red.log(e.message);

      Navigator.pop(context!);
      errorSnackbar(
        context!,
        e.message,
      );
    }
  }
}
