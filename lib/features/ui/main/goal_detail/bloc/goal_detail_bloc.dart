// ignore_for_file: use_build_context_synchronously
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/money_amount.dart';
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
    on<InitTempEdit>(_initTempEdit);
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

  BuildContext get mainContext => MainApp.navKeyGlobal.currentContext!;
  BuildContext? get goalListContext => GoalListPage.keyState.currentContext;

  Future<void> _initGoal(InitGoal event, Emitter<GoalDetailState> emit) async {
    final result = await Future.wait([
      _dbRepo.getGoalDetailSave(event.goalModelId),
      _dbRepo.getSingleGoalModel(event.goalModelId),
    ]);

    emit(
      state.copyWith(
        goalModel: result[1] as GoalModel,
        tempLogoGoal: (result[1] as GoalModel).image,
        tempAmount: (result[1] as GoalModel).target,
        dataSavingsList: result[0] as List<GoalSavingModel>,
      ),
    );
  }

  void _initTempEdit(InitTempEdit event, Emitter<GoalDetailState> emit) {
    TextFieldNameEditGoal.textEditingController.text = state.goalModel.name;
  }

  void _changeIcon(ChangeIcon event, Emitter<GoalDetailState> emit) {
    emit(state.copyWith(tempLogoGoal: event.icon));
  }

  void _setDateInput(SetDateGoalInput event, Emitter<GoalDetailState> emit) {
    emit(state.copyWith(selectedDate: event.time));
  }

  void _setTempAmountInput(
    SetTempAmountInput event,
    Emitter<GoalDetailState> emit,
  ) {
    emit(state.copyWith(tempAmount: event.tempAmount));
  }

  void _setAmountInput(SetAmountInput event, Emitter<GoalDetailState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _addSaving(
    AddSaving event,
    Emitter<GoalDetailState> emit,
  ) async {
    if (!state.amount.isFinite || state.amount <= 0) {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      final amount = state.amount;
      MoneyAmount.toMinorUnits(amount);
      if (amount > state.goalModel.target - state.goalModel.collected) {
        errorToast(
          AppLocalizations.of(mainContext)!.amountExceedsRemainingSaving,
        );
        return;
      }
      await _dbRepo.addSavingAtomic(
        state.goalModel.id!,
        DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
        ),
        amount,
      );

      final newGoalModel =
          await _dbRepo.getSingleGoalModel(state.goalModel.id!);
      mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
      goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(newGoalModel));

      final result = await _dbRepo.getGoalDetailSave(state.goalModel.id!);
      emit(
        state.copyWith(
          dataSavingsList: result,
          goalModel: newGoalModel,
          amount: 0.0,
          selectedDate: DateTime.now(),
        ),
      );
    } on FormatException {
      errorToast(
        AppLocalizations.of(mainContext)!.invalidAmount,
      );
    } on StateError {
      errorToast(
        AppLocalizations.of(mainContext)!.amountExceedsRemainingSaving,
      );
    }
  }

  Future<void> _saveEdit(SaveEdit event, Emitter<GoalDetailState> emit) async {
    final newName = TextFieldNameEditGoal.textEditingController.text.trim();
    final newTarget = state.tempAmount;
    if (newName.isEmpty || newName == "") {
      errorSnackbar(mainContext, AppLocalizations.of(mainContext)!.nameEmpty);
      return;
    }

    if (!newTarget.isFinite || newTarget <= 0) {
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

    MoneyAmount.toMinorUnits(newTarget);
    await _dbRepo.updateGoal(newGoalModel);
    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(newGoalModel));

    emit(
      state.copyWith(goalModel: newGoalModel, tempLogoGoal: state.tempLogoGoal),
    );
  }

  Future<void> _deleteSaving(
    DeleteSaving event,
    Emitter<GoalDetailState> emit,
  ) async {
    //* Update List Savings
    final List<GoalSavingModel> listSavings =
        state.dataSavingsList.toList(growable: true);
    listSavings.removeWhere((e) => e.id == event.goalSaving.id);

    await _dbRepo.deleteSavingAtomic(
      state.goalModel.id!,
      event.goalSaving.id!,
    );
    final updatedGoal = await _dbRepo.getSingleGoalModel(state.goalModel.id!);

    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext?.read<GoalListBloc>().add(UpdateGoalFromGL(updatedGoal));
    emit(state.copyWith(goalModel: updatedGoal, dataSavingsList: listSavings));
  }

  Future<void> _deleteGoal(
    DeleteGoal event,
    Emitter<GoalDetailState> emit,
  ) async {
    await _dbRepo.deleteGoalWithSaving(state.goalModel.id!);
    mainContext.read<HomeBloc>().add(GetGoalsHomeWithCount());
    goalListContext
        ?.read<GoalListBloc>()
        .add(DeleteGoalFromGL(state.goalModel.id!));

    Navigator.pop(mainContext);
  }
}
