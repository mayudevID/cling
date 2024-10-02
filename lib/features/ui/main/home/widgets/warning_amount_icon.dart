import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

Widget warningAmountIcon({required String content}) {
  return SuperTooltip(
    minimumOutsideMargin: 24.w,
    hasShadow: true,
    shadowColor: Colors.red,
    fadeOutDuration: const Duration(milliseconds: 150),
    content: Text(
      content,
      style: const TextStyle(
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(bottom: 1.8.h),
      child: Assets.lib.resources.images.warningTriangleSolid.svg(),
    ),
  );
}
