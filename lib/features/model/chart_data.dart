import 'package:equatable/equatable.dart';

class ChartData extends Equatable {
  const ChartData({required this.x, required this.y});
  final String x;
  final double y;

  @override
  List<Object?> get props => [x, y];
}
