import 'package:bloc/bloc.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:equatable/equatable.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../../core/logger.dart';
import '../../../../repository/database_repository.dart';

part 'goal_list_event.dart';
part 'goal_list_state.dart';

class GoalListBloc extends Bloc<GoalListEvent, GoalListState> {
  GoalListBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(GoalListState()) {
    on<GetGoalsList>(_getGoalsList);
    on<UpdateGoalFromGL>(_updateGoalFromGL);
    on<DeleteGoalFromGL>(_deleteGoalFromGL);
  }

  final DatabaseRepository _dbRepo;
  int? _idOffset;
  bool _firstAttempt = true;
  bool _loadAgain = true;

  void _getGoalsList(event, emit) async {
    if (_loadAgain == false) {
      Logger.Yellow.log("Loader: No DATA");
      state.refreshController.loadNoData();
      return;
    }

    GoalModel? lastRowData;
    if (_firstAttempt) {
      Logger.Green.log("FIRST ATTEMPT");
      lastRowData = await _dbRepo.checkLastRowGoals();
      if (lastRowData == null) {
        state.refreshController.loadNoData();
        return;
      } else {
        _idOffset = lastRowData.id;
      }
    }

    if (_idOffset == null) {
      Logger.Yellow.log("Loader: FAIL");
      state.refreshController.loadFailed();
      return;
    }

    final dataList = await _dbRepo.getGoalsList(_idOffset!);

    if (dataList.isNotEmpty) {
      var dataListNew = state.listGoalModel.toList(growable: true);
      if (_firstAttempt) {
        _firstAttempt = false;
        dataListNew.add(lastRowData!);
      }
      dataListNew.addAll(dataList);
      emit(state.copyWith(listGoalModel: dataListNew));
    }

    if (dataList.length < 12) {
      _loadAgain = false;
      Logger.Yellow.log("Loader: No DATA");
      state.refreshController.loadNoData();
    } else {
      Logger.Yellow.log("Loader: Load Complete/Possible Next");
      state.refreshController.loadComplete();
      _idOffset = dataList.last.id;
    }
  }

  void _updateGoalFromGL(UpdateGoalFromGL event, emit) {
    var dataList = state.listGoalModel.toList(growable: true);
    final idxLoc = dataList.indexWhere((e) => e.id == event.newGoalModel.id);
    if (idxLoc == -1) return;
    dataList[idxLoc] = event.newGoalModel;
    emit(state.copyWith(listGoalModel: dataList));
  }

  void _deleteGoalFromGL(DeleteGoalFromGL event, emit) {
    var dataList = state.listGoalModel.toList(growable: true);
    dataList.removeWhere((e) => e.id == event.id);
    emit(state.copyWith(listGoalModel: dataList));
  }
}
