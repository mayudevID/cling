// ignore_for_file: must_be_immutable

part of 'stats_detail_bloc.dart';

class StatsDetailState extends Equatable {
  List<ExpenseModel> listExpenseModel;
  List<IncomeModel> listIncomeModel;
  DateTime startDate;
  DateTime endDate;
  RangeDate rangeDate;
  DateRangePickerView dateRangePickerView;

  StatsDetailState({
    List<ExpenseModel>? listExpenseModel,
    List<IncomeModel>? listIncomeModel,
    DateTime? startDate,
    DateTime? endDate,
    this.rangeDate = RangeDate.daily,
    this.dateRangePickerView = DateRangePickerView.month,
  })  : listExpenseModel = listExpenseModel ?? List.empty(),
        listIncomeModel = listIncomeModel ?? List.empty(),
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  @override
  List<Object> get props => [
        listExpenseModel,
        listIncomeModel,
        startDate,
        endDate,
        rangeDate,
        dateRangePickerView,
      ];

  StatsDetailState copyWith({
    List<ExpenseModel>? listExpenseModel,
    List<IncomeModel>? listIncomeModel,
    DateTime? startDate,
    DateTime? endDate,
    RangeDate? rangeDate,
    DateRangePickerView? dateRangePickerView,
  }) {
    return StatsDetailState(
      listExpenseModel: listExpenseModel ?? this.listExpenseModel,
      listIncomeModel: listIncomeModel ?? this.listIncomeModel,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rangeDate: rangeDate ?? this.rangeDate,
      dateRangePickerView: dateRangePickerView ?? this.dateRangePickerView,
    );
  }
}
