// ignore_for_file: use_build_context_synchronously

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../main.dart';
import '../../../../model/goal_model.dart';
import '../../../../model/goal_saving_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_export.dart';
import '../../goal_list/bloc/goal_list_bloc.dart';
import '../../goal_list/page/goal_list_page.dart';
import '../../home/bloc/home_bloc.dart';
import '../widgets/edit_goal/text_field_name_edit_goal.dart';

part 'goal_detail_event.dart';
part 'goal_detail_state.dart';

class GoalDetailBloc extends Bloc<GoalDetailEvent, GoalDetailState> {
  GoalDetailBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(GoalDetailState()) {
    on<InitGoal>(_initGoal);
    on<InitTempNameEdit>(_initTempNameEdit);
    on<InitTempAmountEdit>(_initTempAmountEdit);
    on<ChangeIcon>(_changeIcon);
    on<SetDateGoalInput>(_setDateInput);
    on<SetTempAmountInput>(_setTempAmountInput);
    on<SetAmountInput>(_setAmountInput);
    on<AddSaving>(_addSaving);
    on<SaveEdit>(_saveEdit);
    on<DeleteSaving>(_deleteSaving);
    on<DeleteGoal>(_deleteGoal);
  }

  final DatabaseRepository _dbRepo;

  var mainContext = MainApp.navKeyGlobal.currentContext!;
  var goalListContext = GoalListPage.keyState.currentContext;

  void _initGoal(InitGoal event, emit) async {
    final result = await Future.wait([
      _dbRepo.getGoalDetailSave(event.goalModelId),
      _dbRepo.getSingleGoalModel(event.goalModelId),
    ]);

    emit(
      state.copyWith(
        goalModel: result[1] as GoalModel,
        tempLogoGoal: (result[1] as GoalModel).image,
        dataSavingsList: result[0] as List<GoalSavingModel>,
      ),
    );
  }

  void _initTempNameEdit(event, emit) {
    TextFieldNameEditGoal.textEditingController.text = state.goalModel.name;
    emit(state.copyWith(tempLogoGoal: state.goalModel.image));
  }

  void _initTempAmountEdit(event, emit) {
    emit(state.copyWith(tempAmount: state.goalModel.target));
  }

  void _changeIcon(ChangeIcon event, emit) async {
    emit(state.copyWith(tempLogoGoal: event.icon));
  }

  void _setDateInput(SetDateGoalInput event, emit) {
    emit(state.copyWith(selectedDate: event.time));
  }

  void _setTempAmountInput(SetTempAmountInput event, emit) {
    emit(state.copyWith(tempAmount: event.tempAmount));
  }

  void _setAmountInput(SetAmountInput event, emit) {
    emit(state.copyWith(amount: event.amount));
  }

  void _addSaving(event, emit) async {
    if (state.amount == 0) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      final amount = state.amount;
      if (amount > state.goalModel.target - state.goalModel.collected) {
        errorToast(
          AppLocalizations.of(mainContext)!.amountExceedsRemainingSaving,
        );
        return;
      }
      final newGoalModel = state.goalModel.copyWith(
        collected: state.goalModel.collected + amount,
      );

      await Future.wait([
        _dbRepo.saveGoalSaving(
          state.goalModel.id!,
          DateTime(
            state.selectedDate.year,
            state.selectedDate.month,
            state.selectedDate.day,
          ),
          amount,
        ),
        _dbRepo.updateCollectedGoal(newGoalModel),
      ]);

      mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
      goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(newGoalModel));

      final result = await _dbRepo.getGoalDetailSave(state.goalModel.id!);
      emit(
        state.copyWith(
          dataSavingsList: result,
          goalModel: newGoalModel,
        ),
      );
    } on FormatException {
      errorToast(
        AppLocalizations.of(mainContext)!.invalidAmount,
      );
    }
  }

  void _saveEdit(event, emit) async {
    final newName = TextFieldNameEditGoal.textEditingController.text.trim();
    final newTarget = state.tempAmount;
    if (newName.isEmpty || newName == "") {
      errorSnackbar(mainContext, AppLocalizations.of(mainContext)!.nameEmpty);
      return;
    }

    if (newTarget == 0) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.pleaseFillAmount,
      );
      return;
    }

    if (state.goalModel.collected > newTarget) {
      errorSnackbar(
        mainContext,
        AppLocalizations.of(mainContext)!.collectedHigher,
      );
      return;
    }

    final stateGoalModel = state.goalModel;
    final newGoalModel = stateGoalModel.copyWith(
      target: newTarget,
      name: newName,
      image: state.tempLogoGoal,
    );

    await _dbRepo.updateGoal(newGoalModel);
    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(newGoalModel));

    emit(
      state.copyWith(goalModel: newGoalModel, tempLogoGoal: state.tempLogoGoal),
    );
  }

  void _deleteSaving(DeleteSaving event, emit) async {
    //* Update Goal Model
    final newGoalModel = state.goalModel.copyWith(
      collected: state.goalModel.collected - event.goalSaving.amount,
    );
    //* Update List Savings
    var listSavings = state.dataSavingsList.toList(growable: true);
    listSavings.removeWhere((e) => e.id == event.goalSaving.id);

    await Future.wait([
      _dbRepo.deleteSingleSaving(event.goalSaving.id!),
      _dbRepo.updateGoal(newGoalModel),
    ]);

    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(newGoalModel));
    emit(state.copyWith(goalModel: newGoalModel, dataSavingsList: listSavings));
  }

  void _deleteGoal(event, emit) async {
    await _dbRepo.deleteGoalWithSaving(state.goalModel.id!);
    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext
        ?.read<GoalListBloc>()
        .add(DeleteGoalFromGL(state.goalModel.id!));

    Navigator.pop(mainContext);
  }
}
