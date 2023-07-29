import 'package:bloc/bloc.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(HomeState()) {
    on<GetIncomeSource>(_getIncomeSource);
    on<GetExpenseCategories>(_getExpenseCategories);
    on<ClearListDropdown>(_clearListDropdown);
  }

  final DatabaseRepository _dbRepo;

  void _getIncomeSource(GetIncomeSource event, emit) async {
    emit(state.copyWith(isLoadDataDropdown: true));
    final dataIncomeSource = await _dbRepo.getIncomeSource();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(state.copyWith(
      listInSource: dataIncomeSource,
      isLoadDataDropdown: false,
    ));
  }

  void _getExpenseCategories(GetExpenseCategories event, emit) async {
    emit(state.copyWith(isLoadDataDropdown: true));
    final dataExCategories = await _dbRepo.getExpenseCategories();
    await Future.delayed(const Duration(milliseconds: 250));
    emit(state.copyWith(
      listExCategories: dataExCategories,
      isLoadDataDropdown: false,
    ));
  }

  void _clearListDropdown(ClearListDropdown event, emit) {
    emit(state.copyWith(
      listInSource: List.empty(),
      listExCategories: List.empty(),
    ));
  }
}
