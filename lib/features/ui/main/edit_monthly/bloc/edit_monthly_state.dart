// ignore_for_file: must_be_immutable

part of 'edit_monthly_bloc.dart';

class EditMonthlyState extends Equatable {
  double amount;
  int initDateRec;
  int changeDateRec;

  EditMonthlyState({
    this.initDateRec = 0,
    this.changeDateRec = 0,
    this.amount = 0,
  });

  @override
  List<dynamic> get props => [initDateRec, changeDateRec, amount];

  EditMonthlyState copyWith({
    int? initDateRec,
    int? changeDateRec,
    double? amount,
  }) {
    return EditMonthlyState(
      amount: amount ?? this.amount,
      initDateRec: initDateRec ?? this.initDateRec,
      changeDateRec: changeDateRec ?? this.changeDateRec,
    );
  }
}
