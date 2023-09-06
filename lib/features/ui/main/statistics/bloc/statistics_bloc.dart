import 'package:bloc/bloc.dart';
import 'package:cling/features/model/pie_data_expense_savings.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../model/chart_data.dart';

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
    final expense = data['expense'] ?? 0;
    final income = data['income'] ?? 0;
    final saving = income - expense;
    emit(state.copyWith(
      pieDataExSavList: [
        PieDataExSav(
          nameData: "Expense",
          amount: expense,
          text: "Ex",
        ),
        PieDataExSav(
          nameData: "Savings",
          amount: (saving < 0) ? 0 : saving,
          text: "Save",
        ),
      ],
    ));
  }

  void _getIncomeExpenseTotalSixMonth(
    GetIncomeExpenseTotalSixMonth event,
    Emitter<StatisticsState> emit,
  ) async {
    List<ChartData> incomeData = List.empty(growable: true);
    List<ChartData> expenseData = List.empty(growable: true);
    List<ChartData> savingsData = List.empty(growable: true);

    final result = await _dbRepo.getTotalIncomeExpenseSixMonth();

    if (result != null) {
      result.forEach((key, value) {
        final income = value['TotalIncome'];
        final expense = value['TotalExpense'];
        final savings = income - expense;

        incomeData.add(ChartData(x: key, y: income));
        expenseData.add(ChartData(x: key, y: expense));
        savingsData.add(ChartData(x: key, y: (savings < 0) ? 0 : savings));
      });

      emit(state.copyWith(
        chartDataIncomeList: incomeData,
        chartDataExpenseList: expenseData,
        chartDataSavingsList: savingsData,
      ));
    }
  }
}
