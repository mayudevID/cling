import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class WarningAmountIcon extends StatefulWidget {
  const WarningAmountIcon({super.key, required this.content});
  final String content;

  @override
  State<WarningAmountIcon> createState() => _WarningAmountIconState();
}

class _WarningAmountIconState extends State<WarningAmountIcon> {
  final _controller = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.showTooltip();
      },
      child: SuperTooltip(
        controller: _controller,
        sigmaY: -10,
        minimumOutsideMargin: 24.wmea,
        hasShadow: false,
        fadeOutDuration: const Duration(milliseconds: 150),
        content: Text(
          widget.content,
          style: const TextStyle(
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 1.8.hmea),
          child: Assets.lib.resources.images.warningTriangleSolid.svg(),
        ),
      ),
    );
  }
}
