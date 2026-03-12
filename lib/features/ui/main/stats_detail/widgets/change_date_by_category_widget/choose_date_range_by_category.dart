import 'package:flutter/material.dart';

import 'change_range_date_by_category.dart';
import 'choose_date_based_range_date_by_category.dart';

List<Widget> chooseDateRangeByCategory(BuildContext context) {
  return [
    changeRangeDateByCategory(context),
    const SizedBox(height: 8),
    chooseDateBasedRangeDateByCategory(context),
  ];
}
