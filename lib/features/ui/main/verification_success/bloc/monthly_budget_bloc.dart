import 'package:bloc/bloc.dart';
import 'package:cling/core/common_widget.dart';
import 'package:cling/features/ui/main/verification_success/widget/text_field_mothly_budget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../page/monthly_budget_page.dart';

part 'monthly_budget_event.dart';
part 'monthly_budget_state.dart';

class MonthlyBudgetBloc extends Bloc<MonthlyBudgetEvent, MonthlyBudgetState> {
  MonthlyBudgetBloc() : super(MonthlyBudgetState()) {
    on<SetIncome>(_setIncome);
    on<SetSpent>(_setSpent);
    on<SetState>(_setState);
  }

  var context = MonthlyBudgetPage.verifOnboardNavKey.currentContext;

  void _setIncome(SetIncome event, emit) {
    final data = TextFieldMonthlyBudget.textEditingController.text;
    final amount = data.replaceAll(".", "");
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        context!,
        "Monthly budget must above 0",
      );
    } else {
      try {
        double.parse(amount);
        emit(
          state.copyWith(
            monBudgetIncome: data,
          ),
        );
        add(SetState(VerifOnboardPos.spent));
      } on FormatException {
        errorSnackbar(context!, "Invalid amount");
      }
    }
  }

  void _setSpent(SetSpent event, emit) {
    final data = TextFieldMonthlyBudget.textEditingController.text;
    final amount = data.replaceAll(".", "");
    if (amount == "0" || amount.trim().isEmpty) {
      errorSnackbar(
        context!,
        "Spent must above 0",
      );
    } else {
      try {
        double.parse(amount);
        emit(
          state.copyWith(
            monBudgetSpent: data,
          ),
        );

        // * Set Monthly Budget and Spent
      } on FormatException {
        errorSnackbar(context!, "Invalid amount");
      }
    }
  }

  void _setState(SetState event, emit) {
    emit(state.copyWith(state: event.state));

    switch (event.state) {
      case VerifOnboardPos.income:
        //* (Back Condition)
        //* Save Month Budget Spent
        state.monBudgetSpent =
            TextFieldMonthlyBudget.textEditingController.text;
        //* Get Month Budget Income
        TextFieldMonthlyBudget.textEditingController.text =
            state.monBudgetIncome;
        break;
      case VerifOnboardPos.spent:
        //* Get Month Budget Spent
        TextFieldMonthlyBudget.textEditingController.text =
            state.monBudgetSpent;
        break;
    }

    TextFieldMonthlyBudget.textEditingController.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset: TextFieldMonthlyBudget.textEditingController.text.length,
      ),
    );
  }
}
