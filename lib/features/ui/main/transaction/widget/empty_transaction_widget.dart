import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/language_currency/lang_export.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/gen/assets.gen.dart';

Widget emptyTransactionWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.hmea,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 135.wmea,
              child: Assets.lib.resources.images.warningTriangleSolid.svg(
                height: 75.hmea,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              left: 180.wmea,
              child: Assets.lib.resources.images.transaction.svg(
                height: 75.hmea,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8.hmea),
      Text(
        AppLocalizations.of(context)!.emptyTransaction,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: FontFamily.cabinetGrotesk,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 180.hmea),
    ],
  );
}
