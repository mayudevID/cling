import 'package:flutter/material.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget emptyGoalsWidget(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: const Color(0x3D787880),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          AppLocalizations.of(context)!.goalEmpty,
          style: const TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 16,
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
                width: 14,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                AppLocalizations.of(context)!.addGoals,
                style: const TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
