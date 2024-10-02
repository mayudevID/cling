import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

class TagInfo extends StatelessWidget {
  const TagInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: const ShapeDecoration(
            color: Color(0xFFE54C19),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          AppLocalizations.of(context)!.expense,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Container(
          width: 15.w,
          height: 15.w,
          decoration: const ShapeDecoration(
            color: Color(0xFF07AC65),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          AppLocalizations.of(context)!.income,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Container(
          width: 15.w,
          height: 15.w,
          decoration: const ShapeDecoration(
            color: Color(0xFF006DE9),
            shape: OvalBorder(),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          AppLocalizations.of(context)!.savings,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
