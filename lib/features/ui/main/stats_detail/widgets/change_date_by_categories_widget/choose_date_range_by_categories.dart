import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'change_range_date_by_categories.dart';
import 'choose_date_based_range_date_by_categories.dart';

List<Widget> chooseDateRangeByCategories(BuildContext context) {
  return [
    changeRangeDateByCategories(context),
    SizedBox(height: 8.hmea),
    chooseDateBasedRangeDateByCategories(context),
  ];
}
