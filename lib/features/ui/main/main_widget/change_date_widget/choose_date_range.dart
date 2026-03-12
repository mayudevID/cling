import 'package:flutter/material.dart';

import 'change_range_date.dart';
import 'choose_date_based_range_date.dart';

List<Widget> chooseDateRange(BuildContext context) {
  return [
    changeRangeDate(context),
    const SizedBox(height: 8),
    chooseDateBasedRangeDate(context),
  ];
}
