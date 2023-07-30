import 'package:bloc/bloc.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

final dateNow = DateTime.now();

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeSource>(_getIncomeSource);
    on<GetExpenseCategories>(_getExpenseCategories);
    on<ClearDataForm>(_clearDataForm);
    on<GetTotalIncome>(_getTotalIncome);
    on<GetTotalExpense>(_getTotalExpense);
    on<GetGoals>(_getGoals);
    on<GetTodayExpenses>(_getTodayExpenses);
    on<SetDate>(_setDate);
    on<SetCategories>(_setCategories);
  }

  final DatabaseRepository _dbRepo;

  void _getTotalIncome(event, emit) async {
    final amount = await _dbRepo.getTotalIncome();
    emit(state.copyWith(amountIncome: amount));
  }

  void _getTotalExpense(event, emit) async {
    final amount = await _dbRepo.getTotalExpense();
    emit(state.copyWith(amountExpense: amount));
  }

  void _getGoals(event, emit) async {}

  void _getTodayExpenses(event, emit) async {
    final listData = await _dbRepo.getTodayExpenses();
    emit(state.copyWith(listTodayExpenses: listData));
  }

  //* ADD INCOME AND EXPENSE

  void _setDate(SetDate event, emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _setCategories(SetCategories event, emit) {
    emit(state.copyWith(selectedCategories: event.categories));
  }

  void _getIncomeSource(GetIncomeSource event, emit) async {
    final dataIncomeSource = await _dbRepo.getIncomeSource();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(
      state.copyWith(
        listInSource: dataIncomeSource,
      ),
    );
  }

  void _getExpenseCategories(GetExpenseCategories event, emit) async {
    final dataExCategories = await _dbRepo.getExpenseCategories();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(
      state.copyWith(
        listExCategories: dataExCategories,
      ),
    );
  }

  void _clearDataForm(ClearDataForm event, emit) {
    emit(
      state.copyWith(
        listInSource: List.empty(),
        listExCategories: List.empty(),
        selectedCategories: {},
        selectedDate: DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
        ),
      ),
    );
  }
}
