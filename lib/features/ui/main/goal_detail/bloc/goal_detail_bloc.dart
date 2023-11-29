// ignore_for_file: use_build_context_synchronously

import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common_widget.dart';
import '../../../language_currency/lang_export.dart';
import '../../home/bloc/home_bloc.dart';

part 'goal_detail_event.dart';
part 'goal_detail_state.dart';

class GoalDetailBloc extends Bloc<GoalDetailEvent, GoalDetailState> {
  GoalDetailBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(GoalDetailState()) {
    on<InitGoal>(_initGoal);
    on<ChangeIcon>(_changeIcon);
    on<SetDateGoalInput>(_setDateInput);
    on<SetAmountInput>(_setAmountInput);
    on<AddSaving>(_addSaving);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _initGoal(InitGoal event, emit) async {
    final result = await _dbRepo.getGoalDetailSave(event.goalModel.id!);
    emit(
      state.copyWith(
        goalModel: event.goalModel,
        dataSavingsList: result,
      ),
    );
  }

  void _changeIcon(ChangeIcon event, emit) async {
    final newGoalModel = GoalModel(
      id: state.goalModel.id,
      name: state.goalModel.name,
      image: event.icon,
      target: state.goalModel.target,
      collected: state.goalModel.collected,
    );
    await _dbRepo.updateImageGoal(newGoalModel);

    mainContext.read<HomeBloc>().add(GetGoals());

    emit(state.copyWith(goalModel: newGoalModel));
  }

  void _setDateInput(SetDateGoalInput event, emit) {
    emit(state.copyWith(selectedDate: event.time));
  }

  void _setAmountInput(SetAmountInput event, emit) {
    final replaceDot = event.amount.removeDot;
    emit(state.copyWith(amount: replaceDot));
  }

  void _addSaving(event, emit) async {
    if (state.amount.trim().isEmpty || state.amount.trim() == "0") {
      errorToast(AppLocalizations.of(mainContext)!.pleaseFillAmount);
      return;
    }

    try {
      final newAmount = double.parse(state.amount);
      final newGoalModel = GoalModel(
        id: state.goalModel.id,
        name: state.goalModel.name,
        image: state.goalModel.image,
        target: state.goalModel.target,
        collected: state.goalModel.collected + newAmount,
      );
      await Future.wait([
        _dbRepo.saveGoalSaving(
          state.goalModel.id!,
          DateTime(
            state.selectedDate.year,
            state.selectedDate.month,
            state.selectedDate.day,
          ),
          newAmount,
        ),
        _dbRepo.updateCollectedGoal(newGoalModel),
      ]);

      mainContext.read<HomeBloc>().add(GetGoals());

      final result = await _dbRepo.getGoalDetailSave(state.goalModel.id!);
      emit(state.copyWith(
        dataSavingsList: result,
        goalModel: newGoalModel,
      ));
    } on FormatException {
      errorToast(
        AppLocalizations.of(mainContext)!.invalidAmount,
      );
    }
  }
}
