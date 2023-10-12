import 'package:equatable/equatable.dart';

class PieDataExpense extends Equatable {
  const PieDataExpense({
    required this.nameCategories,
    required this.amount,
  });
  final String nameCategories;
  final double amount;

  @override
  List<Object?> get props => [nameCategories, amount];
}
