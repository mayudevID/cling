// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cling/core/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../model/currency.dart';
import '../../../../repository/auth_repository.dart';
import '../../../../repository/settings_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_page.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../page/edit_budget_or_income.dart';
import '../widget/text_field_edit_monthly.dart';

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
    //on<SetAmountInput>(_setAmountInput);
    on<SaveNewMonthly>(_saveNewMonthly);
    on<InitialValue>(_initVal);
    on<ChangeTempRecDay>(_chnageTempRecDay);
  }

  final EditMonthlyMode _monthlyMode;
  final SettingsRepository _settingsRepo;
  final AuthRepository _authRepo;
  final BuildContext _context;
  var mainContext = MainPage.navKeyMain.currentContext!;
  late String initMonthly;

  void _initVal(event, emit) {
    final currentCurr = _settingsRepo.getCurrentCurrency();
    final currency = currentCurr != null
        ? Currency.values
            .where((item) => item.value.countryCode == currentCurr)
            .first
        : Currency.idr;

    final numFormat = NumberFormat.currency(
      locale: currency.value.toLanguageTag(),
      decimalDigits: 2,
      customPattern: '\u00a4###,###.00',
      name: "",
    );

    initMonthly = numFormat.format((_monthlyMode == EditMonthlyMode.income)
        ? _authRepo.currentUserModel!.monthlyIncome / 100.0
        : _authRepo.currentUserModel!.monthlyBudget / 100.0);

    TextFieldEditMonthly.textEditingController.text = initMonthly;

    emit(
      state.copyWith(
        initDateRec: _authRepo.currentUserModel!.recurringDay,
        changeDateRec: _authRepo.currentUserModel!.recurringDay,
      ),
    );
  }

  void _chnageTempRecDay(ChangeTempRecDay event, emit) {
    emit(state.copyWith(changeDateRec: event.value));
  }

  void _saveNewMonthly(SaveNewMonthly event, _) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      errorSnackbar(_context, AppLocalizations.of(_context)!.noConnection);
      return;
    }

    if (initMonthly == TextFieldEditMonthly.textEditingController.text) {
      return;
    }

    loadingAuth(_context);
    try {
      final monValue =
          int.parse(TextFieldEditMonthly.textEditingController.text.removeDot);

      await _settingsRepo.saveMonthlyBudgetAndIncome(
        userModel: _authRepo.currentUserModel!,
        monthlyIncome:
            (_monthlyMode == EditMonthlyMode.income) ? monValue : null,
        monthlyBudget:
            (_monthlyMode == EditMonthlyMode.budget) ? monValue : null,
        recurringDay: (_monthlyMode == EditMonthlyMode.income) ? 0 : null,
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
