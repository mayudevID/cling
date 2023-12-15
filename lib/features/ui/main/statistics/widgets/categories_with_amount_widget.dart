import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Widget categoriesWithAmount({
  required BuildContext context,
  required Map<String, Object?> data,
  required List<String> type,
  required String title,
}) {
  final categoryStr = data[type[1]].toString();
  final categoryIcon = categoryStr.substring(0, categoryStr.indexOf(" "));
  final categoryClass = categoryStr.substring(categoryStr.indexOf(" ") + 1);
  final totalAmount = double.parse(data[type[2]].toString());

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.statsDetailPerCategories,
        arguments: <String>[type[0], categoryStr, title],
      );
    },
    child: Container(
      padding: EdgeInsets.all(16.wmea),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.wmea),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                " $categoryIcon",
                style: TextStyle(fontSize: 9.sp),
              ),
            ),
          ),
          SizedBox(width: 12.wmea),
          Text(
            categoryClass,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          NominalMoneyFormatter(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 9.5.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
            amount: totalAmount,
            decimalDigits: 2,
            isWithName: true,
          ),
        ],
      ),
    ),
  );
}
