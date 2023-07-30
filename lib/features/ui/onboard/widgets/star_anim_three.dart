import 'package:cling/core/utils.dart';
import 'package:cling/features/ui/onboard/widgets/animation_onboard.dart';
import 'package:flutter/material.dart';

class StarAnimThree extends StatefulWidget {
  const StarAnimThree({super.key});

  @override
  State<StarAnimThree> createState() => _StarAnimThreeState();
}

class _StarAnimThreeState extends State<StarAnimThree>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AnimationOnboard.setAnimStarThree(this),
      child: Container(
        width: 34.49.wmea,
        height: 34.49.wmea,
        decoration: const ShapeDecoration(
          color: Color(0xFFF599DA),
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
