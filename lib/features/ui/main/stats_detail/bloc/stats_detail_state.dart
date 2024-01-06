// ignore_for_file: must_be_immutable

part of 'stats_detail_bloc.dart';

class StatsDetailState extends Equatable {
  List<TransactionModel> listTransactionModel;
  DateTime startDate;
  DateTime endDate;
  RangeDate rangeDate;
  DateRangePickerView dateRangePickerView;

  StatsDetailState({
    List<TransactionModel>? listTransactionModel,
    DateTime? startDate,
    DateTime? endDate,
    this.rangeDate = RangeDate.daily,
    this.dateRangePickerView = DateRangePickerView.month,
  })  : listTransactionModel = listTransactionModel ?? List.empty(),
        startDate = startDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
        endDate = endDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  @override
  List<Object> get props => [
        listTransactionModel,
        startDate,
        endDate,
        rangeDate,
        dateRangePickerView,
      ];

  StatsDetailState copyWith({
    List<TransactionModel>? listTransactionModel,
    DateTime? startDate,
    DateTime? endDate,
    RangeDate? rangeDate,
    DateRangePickerView? dateRangePickerView,
  }) {
    return StatsDetailState(
      listTransactionModel: listTransactionModel ?? this.listTransactionModel,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rangeDate: rangeDate ?? this.rangeDate,
      dateRangePickerView: dateRangePickerView ?? this.dateRangePickerView,
    );
  }
}
