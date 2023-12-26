import 'package:cling/core/utils.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget goalListWidget(BuildContext context, GoalModel goalModel) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48.wmea,
          height: 64.hmea,
          //height: double.maxFinite,
          //padding: EdgeInsets.symmetric(vertical: 8.hmea),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Expanded(
            child: Center(
              child: Text(
                goalModel.image,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.wmea),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              goalModel.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.5.sp,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.wmea),
            Stack(
              children: [
                Container(
                  width: 292.5.wmea,
                  height: 8.hmea,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white.withOpacity(0.76),
                  ),
                ),
                Container(
                  width: 165,
                  height: 8.hmea,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFF006DE9),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.wmea),
            Text(
              "Target",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.8.sp,
                fontFamily: FontFamily.cabinetGrotesk,
              ),
            ),
            Text(
              "Collected",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.8.sp,
                fontFamily: FontFamily.cabinetGrotesk,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
