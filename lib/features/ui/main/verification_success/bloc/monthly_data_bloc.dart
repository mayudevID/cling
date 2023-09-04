import 'package:bloc/bloc.dart';
import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/settings_repository.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_field_mothly_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  void _setIncome(SetIncome event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        MonthlyDataPage.verifOnboardNavKey.currentContext!,
        "Monthly budget must above 0",
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
          MonthlyDataPage.verifOnboardNavKey.currentContext!,
          "Invalid amount",
        );
      }
    }
  }

  void _setBudget(SetBudget event, emit) {
    final data = TextFieldMonthlyData.textEditingController.text;
    final amount = data.removeDot;
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        MonthlyDataPage.verifOnboardNavKey.currentContext!,
        "Budget must above 0",
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
      } on FormatException {
        errorSnackbar(
          MonthlyDataPage.verifOnboardNavKey.currentContext!,
          "Invalid amount",
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

  void _setFinish(event, emit) {
    try {
      final monIncome = double.parse(state.monIncome.removeDot);
      final monBudget = double.parse(state.monBudget.removeDot);
    } catch (e) {}
  }
}
