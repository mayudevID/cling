import 'package:bloc/bloc.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../model/expense_model.dart';
import '../../main_widget/enum_range_date.dart';

part 'stats_detail_event.dart';
part 'stats_detail_state.dart';

class StatsDetailBloc extends Bloc<StatsDetailEvent, StatsDetailState> {
  StatsDetailBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(StatsDetailState()) {
    on<GetMostIncomeByCategories>(_getMostIncomeByCategories);
    on<GetMostExpenseByCategories>(_getMostExpenseByCategories);
    on<ChangeDateIncomeBreakdown>(_changeDateIncomeBreakdown);
  }

  final DatabaseRepository _dbRepo;

  void _getMostIncomeByCategories(GetMostIncomeByCategories event, emit) async {
    final result = await _dbRepo.getMostIncomeByCategories(event.source);
    emit(
      state.copyWith(
        listIncomeModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  void _getMostExpenseByCategories(event, emit) async {
    final result = await _dbRepo.getMostExpenseByCategories();
    emit(
      state.copyWith(
        listExpenseModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  void _changeDateIncomeBreakdown(event, emit) async {}
}
