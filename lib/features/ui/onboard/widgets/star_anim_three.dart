import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

class StarAnimThree extends StatefulWidget {
  const StarAnimThree({super.key});

  @override
  State<StarAnimThree> createState() => _StarAnimThreeState();
}

class _StarAnimThreeState extends State<StarAnimThree>
    with TickerProviderStateMixin {
  late final AnimationController animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  );
  late final Animation<double> animate = Tween<double>(
    begin: 0,
    end: 12.5664,
  ).animate(animation);

  @override
  void initState() {
    animation.forward();

    animate.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animation.repeat();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animate,
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
