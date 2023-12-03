import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'change_range_date.dart';
import 'choose_date_based_range_date.dart';

List<Widget> chooseDateRange(BuildContext context) {
  return [
    changeRangeDate(context),
    SizedBox(height: 8.hmea),
    chooseDateBasedRangeDate(context),
  ];
}
