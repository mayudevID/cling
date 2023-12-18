import 'package:cling/core/logger.dart';
import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget tagCategoriesWithTypeFlowWidget(
  BuildContext context,
  String type,
  String categoryOrSourceIcon,
  String categoryOrSourceClass,
) {
  Logger.Red.log(type);
  return Container(
    padding: EdgeInsets.all(16.hmea),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              categoryOrSourceIcon,
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
        SizedBox(width: 16.wmea),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryOrSourceClass,
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: (type == "income")
                    ? const Color(0xFF07AC65)
                    : const Color(0xFFE54C19),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (type == "income")
                    ? AppLocalizations.of(context)!.income
                    : AppLocalizations.of(context)!.expense,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
