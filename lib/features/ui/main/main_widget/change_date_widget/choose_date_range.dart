import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'change_range_date.dart';
import 'choose_date_based_range_date.dart';

List<Widget> chooseDateRange(BuildContext context) {
  return [
    changeRangeDate(context),
    SizedBox(height: 8.h),
    chooseDateBasedRangeDate(context),
  ];
}
