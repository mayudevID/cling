import '../../../../../core/logger.dart';
import 'package:flutter/material.dart';

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
    padding: const EdgeInsets.all(16),
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
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryOrSourceClass,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.bold,
                fontSize: 13,
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
