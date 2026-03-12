import 'package:flutter/material.dart';

class StarAnimTwo extends StatefulWidget {
  const StarAnimTwo({super.key});

  @override
  State<StarAnimTwo> createState() => _StarAnimTwoState();
}

class _StarAnimTwoState extends State<StarAnimTwo>
    with TickerProviderStateMixin {
  late final AnimationController animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );
  late final Animation<double> animate = Tween<double>(
    begin: 0,
    end: -12.5664,
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
        width: 34.49,
        height: 34.49,
        decoration: const ShapeDecoration(
          color: Color(0xFFF599DA),
          shape: StarBorder(
            points: 4,
            innerRadiusRatio: 0.39,
          ),
        ),
      ),
    );
  }
}
