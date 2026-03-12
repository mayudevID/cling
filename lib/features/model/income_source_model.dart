import '../../core/static_name_table.dart';
import 'package:equatable/equatable.dart';

class IncomeSourceModel extends Equatable {

  const IncomeSourceModel({
    required this.id,
    required this.incomeSource,
  });

  factory IncomeSourceModel.fromMap(Map<String, dynamic> json) =>
      IncomeSourceModel(
        id: json[IncomeSourceMeta.id],
        incomeSource: json[IncomeSourceMeta.incomeSource],
      );
  final int id;
  final String incomeSource;

  @override
  List<Object?> get props => [id, incomeSource];
}
