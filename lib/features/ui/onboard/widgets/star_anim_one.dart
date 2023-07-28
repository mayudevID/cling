import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/onboard/widgets/animation_onboard.dart';
import 'package:flutter/material.dart';

class StarAnimOne extends StatefulWidget {
  const StarAnimOne({super.key});

  @override
  State<StarAnimOne> createState() => _StarAnimOneState();
}

class _StarAnimOneState extends State<StarAnimOne>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AnimationOnboard.setAnimStarOne(this),
      child: Container(
        width: 61.02.wmea,
        height: 61.02.wmea,
        decoration: const ShapeDecoration(
          color: Color(0xFF07AC65),
          shape: StarBorder(
            points: 4,
            innerRadiusRatio: 0.39,
            pointRounding: 0,
            valleyRounding: 0,
            rotation: 0,
            squash: 0,
          ),
        ),
      ),
    );
  }
}
