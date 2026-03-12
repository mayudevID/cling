import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../language_currency/lang_export.dart';

String convertEnumToDetailDate(
  BuildContext mainContext,
  DateRangePickerView dateRangePickerView,
) {
  final appLocal = AppLocalizations.of(mainContext)!;

  switch (dateRangePickerView) {
    case DateRangePickerView.month:
      return appLocal.byDay;
    case DateRangePickerView.year:
      return appLocal.byMonth;
    case DateRangePickerView.decade:
      return appLocal.byYear;
    case DateRangePickerView.century:
      return '';
  }
}
