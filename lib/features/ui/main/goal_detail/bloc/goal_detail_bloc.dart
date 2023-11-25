// ignore_for_file: use_build_context_synchronously

import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/main_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/bloc/home_bloc.dart';

part 'goal_detail_event.dart';
part 'goal_detail_state.dart';

class GoalDetailBloc extends Bloc<GoalDetailEvent, GoalDetailState> {
  GoalDetailBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(GoalDetailState()) {
    on<InitGoal>(_initGoal);
    on<ChangeIcon>(_changeIcon);
  }

  final DatabaseRepository _dbRepo;
  var mainContext = MainPage.navKeyMain.currentContext!;

  void _initGoal(InitGoal event, emit) async {
    final result = await _dbRepo.getGoalDetailSave(event.goalModel.id!);
    print("ISINYA: ${event.goalModel.id}");
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
}
