import 'package:bloc/bloc.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:equatable/equatable.dart';

part 'goal_detail_event.dart';
part 'goal_detail_state.dart';

class GoalDetailBloc extends Bloc<GoalDetailEvent, GoalDetailState> {
  GoalDetailBloc() : super(GoalDetailState()) {
    on<InitGoal>(_initGoal);
  }

  void _initGoal(event, emit) {}
}
