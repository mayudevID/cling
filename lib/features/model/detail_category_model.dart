import 'package:cling/features/ui/main/main_widget/enum_range_date.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DetailCategoryModel {
  final String type;
  final String categoryStr;
  final String title;
  final RangeDate rangeDate;
  final DateRangePickerView dateRangePickerView;
  final DateTime startDate;
  final DateTime endDate;

  DetailCategoryModel({
    required this.type,
    required this.categoryStr,
    required this.title,
    required this.rangeDate,
    required this.dateRangePickerView,
    required this.startDate,
    required this.endDate,
  });
}
