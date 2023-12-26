import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../../core/route.dart';
import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';

Widget seeAllWidget(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, RouteName.goalList),
    child: Container(
      margin: EdgeInsets.only(left: 12.wmea, right: 24.wmea),
      height: 156.855.hmea,
      padding: EdgeInsets.symmetric(vertical: 16.wmea, horizontal: 16.wmea),
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
