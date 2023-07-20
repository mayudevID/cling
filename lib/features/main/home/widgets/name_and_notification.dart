import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';

Widget nameAndNotification() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Good day, Jane',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        Assets.lib.resources.images.bell.svg()
      ],
    ),
  );
}
