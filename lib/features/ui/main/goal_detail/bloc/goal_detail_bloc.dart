import 'package:bloc/bloc.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

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

  void _initGoal(InitGoal event, emit) async {
    final result = await _dbRepo.getGoalDetailSave(event.goalModel.id!);

    emit(state.copyWith(
      goalModel: event.goalModel,
      dataSavingsList: result,
    ));
  }

  void _changeIcon(event, emit) {}
}
