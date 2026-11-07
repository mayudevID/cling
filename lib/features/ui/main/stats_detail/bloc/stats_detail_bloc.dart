import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../core/logger.dart';
import '../../../../../main.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/detail_category_model.dart';
import '../../../../model/transaction_model.dart';
import '../../../../repository/database_repository.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../../language_currency/lang_export.dart';
import '../../main_widget/convert_enum_to_detail_date.dart';
import '../../main_widget/enum_range_date.dart';

part 'stats_detail_event.dart';
part 'stats_detail_state.dart';

class StatsDetailBloc extends Bloc<StatsDetailEvent, StatsDetailState> {
  StatsDetailBloc({
    required DatabaseRepository dbRepo,
    required DetailCategoryModel detailCategoryModel,
  })  : _type = detailCategoryModel.type,
        _categoryOrSource = detailCategoryModel.categoryStr,
        _dbRepo = dbRepo,
        super(
          StatsDetailState(
            rangeDate: detailCategoryModel.rangeDate,
            dateRangePickerView: detailCategoryModel.dateRangePickerView,
            startDate: detailCategoryModel.startDate,
            endDate: detailCategoryModel.endDate,
          ),
        ) {
    on<GetMostIncomeByCategory>(_getMostIncomeByCategory);
    on<GetMostExpenseByCategory>(_getMostExpenseByCategory);
    on<GetIncomeBreakdownByCategory>(_getIncomeBreakdownByCategory);
    on<GetExpenseBreakdownByCategory>(_getExpenseBreakdownByCategory);
    on<ChangeDateRangePickerView>(_changeDateRangePickerView);
    on<ChangeRangeDate>(_changeRangeDate);
    on<ChangeDaily>(_changeDaily);
    on<ChangeMonthly>(_changeMonthly);
    on<ChangeYearly>(_changeYearly);
    on<ChangeDateForPeriod>(_changeDateForPeriod);
    on<RefreshCurrentCategory>(_refreshCurrentCategory);
    on<UpdateFromEdit>(_updateFromEdit);
    on<DeleteFromEdit>(_deleteFromEdit);
  }

  final DatabaseRepository _dbRepo;
  final String _type;
  final String _categoryOrSource;
  bool _mostMode = false;
  int _querySequence = 0;
  final BuildContext mainContext = MainApp.navKeyGlobal.currentContext!;

  bool get isIncome => _type == 'income';

  DateTime get timeNow {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  int _getDaysInMonth(int year, int month) {
    final DateTime lastDayOfMonth = DateTime(year, month + 1).subtract(
      const Duration(days: 1),
    );
    return lastDayOfMonth.day;
  }

  Future<void> _getMostIncomeByCategory(
    GetMostIncomeByCategory event,
    Emitter<StatsDetailState> emit,
  ) async {
    _mostMode = true;
    final query = ++_querySequence;
    final revision = _dbRepo.revision;
    final result =
        await _dbRepo.getMostIncomeByCategory(source: _categoryOrSource);
    if (isClosed || query != _querySequence || revision != _dbRepo.revision)
      return;
    emit(
      state.copyWith(
        listTransactionModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  Future<void> _getMostExpenseByCategory(
    GetMostExpenseByCategory event,
    Emitter<StatsDetailState> emit,
  ) async {
    _mostMode = true;
    final query = ++_querySequence;
    final revision = _dbRepo.revision;
    final result =
        await _dbRepo.getMostExpenseByCategory(source: _categoryOrSource);
    if (isClosed || query != _querySequence || revision != _dbRepo.revision)
      return;
    emit(
      state.copyWith(
        listTransactionModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  Future<void> _getIncomeBreakdownByCategory(
    GetIncomeBreakdownByCategory event,
    Emitter<StatsDetailState> emit,
  ) async {
    _mostMode = false;
    final query = ++_querySequence;
    final revision = _dbRepo.revision;
    final start = state.startDate;
    final end = state.endDate;
    final result = await _dbRepo.getMostIncomeByCategory(
      source: _categoryOrSource,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
    );
    if (isClosed ||
        query != _querySequence ||
        revision != _dbRepo.revision ||
        state.startDate != start ||
        state.endDate != end) {
      return;
    }
    emit(
      state.copyWith(
        listTransactionModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
    Logger.Green.log("GetIncomeBreakdownByCategory");
  }

  Future<void> _getExpenseBreakdownByCategory(
    GetExpenseBreakdownByCategory event,
    Emitter<StatsDetailState> emit,
  ) async {
    _mostMode = false;
    final query = ++_querySequence;
    final revision = _dbRepo.revision;
    final start = state.startDate;
    final end = state.endDate;
    final result = await _dbRepo.getMostExpenseByCategory(
      source: _categoryOrSource,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
    );
    if (isClosed ||
        query != _querySequence ||
        revision != _dbRepo.revision ||
        state.startDate != start ||
        state.endDate != end) {
      return;
    }
    emit(
      state.copyWith(
        listTransactionModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
    Logger.Green.log("GetExpenseBreakdownByCategory");
  }

  void _changeRangeDate(ChangeRangeDate event, emit) {
    DateTime startDate;
    DateTime endDate;
    switch (event.rangeDate) {
      case RangeDate.daily:
        startDate = timeNow;
        endDate = timeNow;
        Logger.Green.log("ChangeRangeDateCategory Daily");
        break;
      case RangeDate.monthy:
        startDate = DateTime(
          state.endDate.year,
          state.endDate.month,
        );
        endDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeRangeDateCategory Monthly");
        break;
      case RangeDate.yearly:
        startDate = DateTime(state.endDate.year);
        endDate = DateTime(state.endDate.year, 12, 31);
        Logger.Green.log("ChangeRangeDateCategory Yearly");
        break;
      case RangeDate.period:
        startDate = timeNow.subtract(const Duration(days: 4));
        endDate = timeNow;
        Logger.Green.log("ChangeRangeDateCategory Period");
        break;
    }
    emit(
      state.copyWith(
        rangeDate: event.rangeDate,
        startDate: startDate,
        endDate: endDate,
        dateRangePickerView: (event.rangeDate == RangeDate.period)
            ? DateRangePickerView.month
            : null,
      ),
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  void _changeDaily(ChangeDaily event, emit) async {
    Logger.Green.log("ChangeDailyCategory");
    switch (event.leftOrRightOrPick) {
      case 0:
        final newDate = state.endDate.subtract(const Duration(days: 1));
        emit(state.copyWith(startDate: newDate, endDate: newDate));
        break;
      case 1:
        final newDate = state.endDate.add(const Duration(days: 1));
        emit(state.copyWith(startDate: newDate, endDate: newDate));
        break;
      default:
        final DateTime? pickedDate = await showDatePicker(
          context: mainContext,
          initialDate: state.endDate,
          firstDate: DateTime(1970),
          lastDate: state.endDate.add(const Duration(days: 1000)),
        );
        if (pickedDate != null) {
          emit(state.copyWith(startDate: pickedDate, endDate: pickedDate));
        }
        break;
    }
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  void _changeMonthly(ChangeMonthly event, emit) async {
    Logger.Green.log("ChangeMonthlyCategory");
    if (event.leftOrRightOrPick == 0 || event.leftOrRightOrPick == 1) {
      final int monthModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(
        state.startDate.year,
        state.startDate.month + monthModifier,
      );
      final newEndDate = DateTime(
        state.endDate.year,
        state.endDate.month + monthModifier,
        _getDaysInMonth(
          state.endDate.year,
          state.endDate.month + monthModifier,
        ),
      );
      emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
    } else {
      final pickedDate = await showMonthYearPicker(
        locale:
            mainContext.read<LangCurrencyBloc>().state.selectedLanguage.value,
        context: mainContext,
        initialDate: state.endDate,
        firstDate: timeNow.subtract(const Duration(days: 10000000)),
        lastDate: timeNow.add(const Duration(days: 10000000)),
      );
      if (pickedDate != null) {
        final newStartDate = DateTime(pickedDate.year, pickedDate.month);
        final newEndDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          _getDaysInMonth(pickedDate.year, pickedDate.month),
        );
        emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
      }
    }
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  void _changeYearly(ChangeYearly event, emit) async {
    Logger.Green.log("ChangeYearlyCategory");
    if (event.leftOrRightOrPick == 0 || event.leftOrRightOrPick == 1) {
      final int yearModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(state.endDate.year + yearModifier);
      final newEndDate = DateTime(state.endDate.year + yearModifier, 12, 31);

      emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
    } else {
      final DateTime? pickedDate = await showDialog(
        context: mainContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.selectYear,
              style: const TextStyle(fontFamily: FontFamily.cabinetGrotesk),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(timeNow.year - 100),
                lastDate: DateTime(timeNow.year + 100),
                currentDate: timeNow,
                selectedDate: state.endDate,
                onChanged: (DateTime dateTime) {
                  Navigator.pop(context, dateTime);
                },
              ),
            ),
          );
        },
      );

      if (pickedDate != null) {
        final newStartDate = DateTime(pickedDate.year);
        final newEndDate = DateTime(
          pickedDate.year,
          12,
          _getDaysInMonth(pickedDate.year, pickedDate.month),
        );
        emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
      }
    }
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  void _changeDateRangePickerView(ChangeDateRangePickerView event, emit) {
    DateTime? newStartDate;
    DateTime? newEndDate;

    switch (event.dateRangePickerView) {
      case DateRangePickerView.month:
        newStartDate = timeNow.subtract(const Duration(days: 4));
        newEndDate = timeNow;
        Logger.Green.log("ChangeDateRangePickerView (By Day)");
        break;
      case DateRangePickerView.year:
        newStartDate = DateTime(state.startDate.year, state.startDate.month);
        newEndDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeDateRangePickerView (By Month)");
        break;
      case DateRangePickerView.decade:
        newStartDate = DateTime(state.startDate.year);
        newEndDate = DateTime(state.endDate.year, 12, 31);
        Logger.Green.log("ChangeDateRangePickerView (By Year)");
        break;
      case DateRangePickerView.century:
        break;
    }
    emit(
      state.copyWith(
        dateRangePickerView: event.dateRangePickerView,
        startDate: newStartDate,
        endDate: newEndDate,
      ),
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  void _changeDateForPeriod(ChangeDateForPeriod event, emit) {
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
    Logger.Green.log(
      "ChangeDateForPeriodCategory (${convertEnumToDetailDate(mainContext, state.dateRangePickerView)})",
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }

  Future<void> _refreshCurrentCategory(
    RefreshCurrentCategory event,
    Emitter<StatsDetailState> emit,
  ) async {
    final query = ++_querySequence;
    final revision = _dbRepo.revision;
    final start = state.startDate;
    final end = state.endDate;
    final startDate = _mostMode ? null : start.toIso8601String();
    final endDate = _mostMode ? null : end.toIso8601String();
    final List<TransactionModel> result = isIncome
        ? await _dbRepo.getMostIncomeByCategory(
            source: _categoryOrSource,
            startDate: startDate,
            endDate: endDate,
          )
        : await _dbRepo.getMostExpenseByCategory(
            source: _categoryOrSource,
            startDate: startDate,
            endDate: endDate,
          );
    if (isClosed ||
        query != _querySequence ||
        revision != _dbRepo.revision ||
        state.startDate != start ||
        state.endDate != end) {
      return;
    }
    emit(state.copyWith(listTransactionModel: result));
  }

  // Legacy edit/delete events now reload the filtered source of truth.
  void _updateFromEdit(UpdateFromEdit event, Emitter<StatsDetailState> emit) {
    add(RefreshCurrentCategory());
  }

  void _deleteFromEdit(DeleteFromEdit event, Emitter<StatsDetailState> emit) {
    add(RefreshCurrentCategory());
  }
}
