import '../../../../../resources/gen/assets.gen.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import 'package:super_tooltip/super_tooltip.dart';

Widget warningAmountIcon({required String content}) {
  return SuperTooltip(
    positionConfig: const PositionConfiguration(minimumOutsideMargin: 24),
    style: const TooltipStyle(
      shadowColor: Colors.red,
    ),
    content: Text(
      content,
      style: const TextStyle(
        fontFamily: FontFamily.cabinetGrotesk,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 1.8),
      child: Assets.lib.resources.images.warningTriangleSolid.svg(),
    ),
  );
}
