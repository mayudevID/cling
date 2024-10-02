import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget seeAllWidget(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, RouteName.goalList),
    child: Container(
      margin: EdgeInsets.only(left: 12.w, right: 24.w),
      height: 156.855.h,
      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0x3D787880),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: math.pi,
            child: Assets.lib.resources.images.backButton.svg(),
          ),
          Text(
            AppLocalizations.of(context)!.seeAll,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: FontFamily.cabinetGrotesk,
            ),
          ),
        ],
      ),
    ),
  );
}
