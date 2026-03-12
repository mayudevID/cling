import 'package:flutter/material.dart';

import '../../language_currency/lang_export.dart';
import 'enum_range_date.dart';

String setName(BuildContext context, RangeDate rangeDate) {
  final appContext = AppLocalizations.of(context)!;
  switch (rangeDate) {
    case RangeDate.daily:
      return appContext.daily;
    case RangeDate.period:
      return appContext.period;
    case RangeDate.monthy:
      return appContext.monthly;
    case RangeDate.yearly:
      return appContext.yearly;
  }
}
