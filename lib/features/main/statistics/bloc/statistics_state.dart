// ignore_for_file: must_be_immutable

part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  int typeCategories;
  StatisticsState({required this.typeCategories});

  @override
  List<Object> get props => [typeCategories];

  StatisticsState copyWith({
    int? typeCategories,
  }) {
    return StatisticsState(
      typeCategories: typeCategories ?? this.typeCategories,
    );
  }
}
