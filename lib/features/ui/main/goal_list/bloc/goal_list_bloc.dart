import 'package:bloc/bloc.dart';
import '../../../../model/goal_model.dart';
import 'package:equatable/equatable.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
  int? _cursor;
  bool _loading = false;
  bool _hasMore = true;
  static const int _pageSize = 12;

  Future<void> _getGoalsList(
    GetGoalsList event,
    Emitter<GoalListState> emit,
  ) async {
    if (_loading) return;
    if (!_hasMore) {
      state.refreshController.loadNoData();
      return;
    }
    _loading = true;
    final revision = _dbRepo.revision;
    try {
      final page = await _dbRepo.getGoalsPage(
        beforeId: _cursor,
      );
      if (isClosed || revision != _dbRepo.revision) return;
      if (page.isNotEmpty) {
        _cursor = page.last.id;
        emit(
          state.copyWith(
            listGoalModel: [
              ...state.listGoalModel,
              ...page,
            ],
          ),
        );
      }
      _hasMore = page.length == _pageSize;
      if (_hasMore) {
        state.refreshController.loadComplete();
      } else {
        state.refreshController.loadNoData();
      }
    } catch (_) {
      if (!isClosed) state.refreshController.loadFailed();
    } finally {
      _loading = false;
    }
  }

  void _updateGoalFromGL(
    UpdateGoalFromGL event,
    Emitter<GoalListState> emit,
  ) {
    final List<GoalModel> dataList = state.listGoalModel.toList(growable: true);
    final idxLoc = dataList.indexWhere((e) => e.id == event.newGoalModel.id);
    if (idxLoc == -1) return;
    dataList[idxLoc] = event.newGoalModel;
    emit(state.copyWith(listGoalModel: dataList));
  }

  void _deleteGoalFromGL(
    DeleteGoalFromGL event,
    Emitter<GoalListState> emit,
  ) {
    final List<GoalModel> dataList = state.listGoalModel.toList(growable: true);
    dataList.removeWhere((e) => e.id == event.id);
    emit(state.copyWith(listGoalModel: dataList));
  }

  @override
  Future<void> close() async {
    state.refreshController.dispose();
    await super.close();
  }
}
