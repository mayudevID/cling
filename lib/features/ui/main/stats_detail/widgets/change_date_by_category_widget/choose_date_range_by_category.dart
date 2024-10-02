import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'change_range_date_by_category.dart';
import 'choose_date_based_range_date_by_category.dart';

List<Widget> chooseDateRangeByCategory(BuildContext context) {
  return [
    changeRangeDateByCategory(context),
    SizedBox(height: 8.h),
    chooseDateBasedRangeDateByCategory(context),
  ];
}
