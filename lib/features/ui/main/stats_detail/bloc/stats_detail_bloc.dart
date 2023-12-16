import 'package:cling/features/model/detail_category_model.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../core/logger.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/expense_model.dart';
import '../../../language_currency/lang_currency_bloc.dart';
import '../../main_widget/convert_enum_to_detail_date.dart';
import '../../main_widget/enum_range_date.dart';

part 'stats_detail_event.dart';
part 'stats_detail_state.dart';

class StatsDetailBloc extends Bloc<StatsDetailEvent, StatsDetailState> {
  StatsDetailBloc({
    required BuildContext context,
    required DatabaseRepository dbRepo,
    required DetailCategoryModel detailCategoryModel,
  })  : _context = context,
        _type = detailCategoryModel.type,
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
  }

  final BuildContext _context;
  final DatabaseRepository _dbRepo;
  final String _type;
  final String _categoryOrSource;

  bool get isIncome => _type == 'income';

  DateTime get timeNow {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  int _getDaysInMonth(int year, int month) {
    DateTime lastDayOfMonth = DateTime(year, month + 1, 1).subtract(
      const Duration(days: 1),
    );
    return lastDayOfMonth.day;
  }

  void _getMostIncomeByCategory(GetMostIncomeByCategory event, emit) async {
    final result =
        await _dbRepo.getMostIncomeByCategory(source: _categoryOrSource);
    emit(
      state.copyWith(
        listIncomeModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  void _getMostExpenseByCategory(event, emit) async {
    final result =
        await _dbRepo.getMostExpenseByCategory(source: _categoryOrSource);
    emit(
      state.copyWith(
        listExpenseModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
  }

  void _getIncomeBreakdownByCategory(event, emit) async {
    final result = await _dbRepo.getMostIncomeByCategory(
      source: _categoryOrSource,
      startDate: state.startDate.toIso8601String(),
      endDate: state.endDate.toIso8601String(),
    );
    emit(
      state.copyWith(
        listIncomeModel: (result.isNotEmpty) ? result : List.empty(),
      ),
    );
    Logger.Green.log("GetIncomeBreakdownByCategory");
  }

  void _getExpenseBreakdownByCategory(event, emit) async {
    final result = await _dbRepo.getMostExpenseByCategory(
      source: _categoryOrSource,
      startDate: state.startDate.toIso8601String(),
      endDate: state.endDate.toIso8601String(),
    );
    emit(
      state.copyWith(
        listExpenseModel: (result.isNotEmpty) ? result : List.empty(),
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
          1,
        );
        endDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeRangeDateCategory Monthly");
        break;
      case RangeDate.yearly:
        startDate = DateTime(state.endDate.year, 1, 1);
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
        DateTime? pickedDate = await showDatePicker(
          context: _context,
          initialDate: state.endDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(1970, 1, 1),
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
      int monthModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(
        state.startDate.year,
        state.startDate.month + monthModifier,
        1,
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
        locale: _context.read<LangCurrencyBloc>().state.selectedLanguage.value,
        context: _context,
        initialDate: state.endDate,
        firstDate: timeNow.subtract(const Duration(days: 10000000)),
        lastDate: timeNow.add(const Duration(days: 10000000)),
      );
      if (pickedDate != null) {
        final newStartDate = DateTime(pickedDate.year, pickedDate.month, 1);
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
      int yearModifier = (event.leftOrRightOrPick == 0) ? -1 : 1;

      final newStartDate = DateTime(state.endDate.year + yearModifier, 1, 1);
      final newEndDate = DateTime(state.endDate.year + yearModifier, 12, 31);

      emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
    } else {
      DateTime? pickedDate = await showDialog(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Select Year",
              style: TextStyle(fontFamily: FontFamily.cabinetGrotesk),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(timeNow.year - 100, 1),
                lastDate: DateTime(timeNow.year + 100, 1),
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
        final newStartDate = DateTime(pickedDate.year, 1, 1);
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
        newStartDate = DateTime(state.startDate.year, state.startDate.month, 1);
        newEndDate = DateTime(
          state.endDate.year,
          state.endDate.month,
          _getDaysInMonth(state.endDate.year, state.endDate.month),
        );
        Logger.Green.log("ChangeDateRangePickerView (By Month)");
        break;
      case DateRangePickerView.decade:
        newStartDate = DateTime(state.startDate.year, 1, 1);
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
      "ChangeDateForPeriodCategory (${convertEnumToDetailDate(_context, state.dateRangePickerView)})",
    );
    Logger.White.log(DateFormat.yMMMd().format(state.startDate));
    Logger.White.log(DateFormat.yMMMd().format(state.endDate));
    add(
      (isIncome)
          ? GetIncomeBreakdownByCategory()
          : GetExpenseBreakdownByCategory(),
    );
  }
}
