// ignore_for_file: must_be_immutable

part of 'edit_monthly_bloc.dart';

class EditMonthlyState extends Equatable {
  String value;
  String newValue;

  EditMonthlyState({required this.value, required this.newValue});

  @override
  List<Object> get props => [value, newValue];

  EditMonthlyState copyWith({
    String? value,
    String? newValue,
  }) {
    return EditMonthlyState(
      value: value ?? this.value,
      newValue: newValue ?? this.newValue,
    );
  }
}
