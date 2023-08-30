import 'package:bloc/bloc.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(
          StatisticsState(),
        ) {
    on<TypeCategoriesEvent>(_typeCategories);
    on<GetIncomeExpenseTotalCurrMonth>(_getIncomeExpenseTotalCurrMonth);
    on<GetIncomeExpenseTotalSixMonth>(_getIncomeExpenseTotalSixMonth);
  }

  final DatabaseRepository _dbRepo;

  void _typeCategories(
    TypeCategoriesEvent event,
    Emitter<StatisticsState> emit,
  ) {
    emit(state.copyWith(
      typeCategories: event.type,
    ));
  }

  void _getIncomeExpenseTotalCurrMonth(
    GetIncomeExpenseTotalCurrMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    final data = await _dbRepo.getTotalIncomeExpenseCurrMonth();
    emit(state.copyWith(
      expenseTotal: data['expense'],
      incomeTotal: data['income'],
    ));
  }

  void _getIncomeExpenseTotalSixMonth(
    GetIncomeExpenseTotalSixMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    await _dbRepo.getTotalIncomeExpenseSixMonth();
  }
}
