import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../model/goal_model.dart';

Widget widgetGoals(
  BuildContext context,
  int index,
  GoalModel goalModel,
  int length,
) {
  final percent = ((goalModel.collected * 100) / goalModel.target).round();

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.goalsDetail,
        arguments: goalModel.id!,
      );
    },
    child: Container(
      margin: EdgeInsets.only(
        left: (index == 0) ? 24.w : 12.w,
        right: (index == length - 1) ? 24.w : 0,
      ),
      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(goalModel.image, style: TextStyle(fontSize: 18.sp)),
          ),
          SizedBox(height: 12.h),
          Text(
            goalModel.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontFamily: FontFamily.cabinetGrotesk,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Stack(
            children: [
              Container(
                width: 133.w,
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(0.76),
                ),
              ),
              Container(
                width: ((133.w * percent) / 100.0),
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF006DE9),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              NominalMoneyFormatter(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 9.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
                amount: goalModel.target,
                isWithName: true,
              ),
              Text(
                " / $percent%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
