import 'package:equatable/equatable.dart';

class PieDataExSav extends Equatable {
  const PieDataExSav({
    required this.nameData,
    required this.amount,
    required this.text,
  });
  final String nameData;
  final double amount;
  final String text;

  @override
  List<Object?> get props => [nameData, amount, text];
}
