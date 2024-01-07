// ignore_for_file: must_be_immutable

part of 'edit_monthly_bloc.dart';

class EditMonthlyState extends Equatable {
  int initDateRec;
  int changeDateRec;

  EditMonthlyState({this.initDateRec = 0, this.changeDateRec = 0});

  @override
  List<dynamic> get props => [initDateRec, changeDateRec];

  EditMonthlyState copyWith({
    int? initDateRec,
    int? changeDateRec,
  }) {
    return EditMonthlyState(
      initDateRec: initDateRec ?? this.initDateRec,
      changeDateRec: changeDateRec ?? this.changeDateRec,
    );
  }
}
