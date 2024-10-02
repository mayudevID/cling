import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget emptyGoalsWidget(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24.w),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 16.h,
        ),
        Text(
          AppLocalizations.of(context)!.goalEmpty,
          style: TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontSize: 10.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.addGoal);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.lib.resources.images.plus.svg(
                // ignore: deprecated_member_use_from_same_package
                color: Colors.white,
                width: 14.w,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                AppLocalizations.of(context)!.addGoals,
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
      ],
    ),
  );
}
