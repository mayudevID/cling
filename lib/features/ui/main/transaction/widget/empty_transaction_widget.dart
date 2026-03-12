import '../../../language_currency/lang_export.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/gen/assets.gen.dart';

Widget emptyTransactionWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 135,
              child: Assets.lib.resources.images.warningTriangleSolid.svg(
                height: 75,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              left: 180,
              child: Assets.lib.resources.images.transaction.svg(
                height: 75,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        AppLocalizations.of(context)!.emptyTransaction,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 180),
    ],
  );
}
