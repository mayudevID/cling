// ignore_for_file: use_build_context_synchronously

import 'package:cling/core/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/logger.dart';
import '../../../../model/goal_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../add_in_ex/widgets/dialog_add_success.dart';
import '../../home/bloc/home_bloc.dart';
import '../../main_page.dart';

part 'add_goal_event.dart';
part 'add_goal_state.dart';

class AddGoalBloc extends Bloc<AddGoalEvent, AddGoalState> {
  AddGoalBloc({
    required BuildContext context,
    required DatabaseRepository dbRepo,
  })  : _context = context,
        _dbRepo = dbRepo,
        super(AddGoalState()) {
    on<SetNameGoal>(_setNameGoal);
    on<SetLogoGoal>(_setLogoGoal);
    on<SaveDataGoal>(_saveDataGoal);
    on<SetAmountInput>(_setAmountInput);
  }

  final BuildContext _context;
  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _setNameGoal(SetNameGoal event, Emitter<AddGoalState> emit) {
    emit(state.copyWith(nameGoal: event.nameGoal));
  }

  void _setLogoGoal(SetLogoGoal event, Emitter<AddGoalState> emit) {
    emit(state.copyWith(logoGoal: event.logoGoal));
  }

  void _setAmountInput(SetAmountInput event, Emitter<AddGoalState> emit) {
    final replaceDot = event.amountInput.removeDot;
    emit(state.copyWith(amountInput: replaceDot));
  }

  void _saveDataGoal(SaveDataGoal event, Emitter<AddGoalState> emit) async {
    if (state.logoGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(_context)!.pleaseSelectLogo);
      return;
    }

    if (state.nameGoal.trim().isEmpty) {
      errorToast(AppLocalizations.of(_context)!.pleaseFillName);
      return;
    }

    if (state.amountInput.trim().isEmpty || state.amountInput.trim() == "0") {
      errorToast(AppLocalizations.of(_context)!.pleaseFillAmount);
      return;
    }

    try {
      final goalData = GoalModel(
        name: state.nameGoal.trim(),
        image: state.logoGoal,
        target: double.parse(state.amountInput),
        collected: 0,
      );
      await _dbRepo.insertGoal(goalData);
      mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());

      dialogAddSuccess(_context, null);
    } on FormatException {
      errorToast(AppLocalizations.of(_context)!.invalidAmount);
    } on DatabaseException catch (e) {
      errorToast(e.toString());
      Logger.Red.log(e.toString());
    }
  }
}
