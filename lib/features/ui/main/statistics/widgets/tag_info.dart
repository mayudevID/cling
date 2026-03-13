import 'package:flutter/material.dart';

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
          width: 15,
          height: 15,
          decoration: const ShapeDecoration(
            color: Color(0xFFE54C19),
            shape: OvalBorder(),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          AppLocalizations.of(context)!.expense,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 11,
        ),
        Container(
          width: 15,
          height: 15,
          decoration: const ShapeDecoration(
            color: Color(0xFF07AC65),
            shape: OvalBorder(),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          AppLocalizations.of(context)!.income,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 11,
        ),
        Container(
          width: 15,
          height: 15,
          decoration: const ShapeDecoration(
            color: Color(0xFF006DE9),
            shape: OvalBorder(),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          AppLocalizations.of(context)!.savings,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
