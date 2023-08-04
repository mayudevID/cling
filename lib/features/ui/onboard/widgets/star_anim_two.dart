import 'package:cling/features/ui/onboard/widgets/animation_onboard.dart';
import 'package:flutter/material.dart';

class StarAnimTwo extends StatefulWidget {
  const StarAnimTwo({super.key});

  @override
  State<StarAnimTwo> createState() => _StarAnimTwoState();
}

class _StarAnimTwoState extends State<StarAnimTwo>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    AnimationOnboard.animC3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AnimationOnboard.setAnimStarTwo(this),
      child: Container(
        width: 34.49,
        height: 34.49,
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
