// ignore_for_file: must_be_immutable

part of 'edit_monthly_bloc.dart';

class EditMonthlyState extends Equatable {

  EditMonthlyState({
    this.dateRec = 0,
    this.amount = 0,
  });
  double amount;
  int dateRec;

  @override
  List<dynamic> get props => [dateRec, amount];

  EditMonthlyState copyWith({
    int? dateRec,
    double? amount,
  }) {
    return EditMonthlyState(
      amount: amount ?? this.amount,
      dateRec: dateRec ?? this.dateRec,
    );
  }
}
