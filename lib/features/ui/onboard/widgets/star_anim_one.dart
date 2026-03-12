import 'package:flutter/material.dart';

class StarAnimOne extends StatefulWidget {
  const StarAnimOne({super.key});

  @override
  State<StarAnimOne> createState() => _StarAnimOneState();
}

class _StarAnimOneState extends State<StarAnimOne>
    with TickerProviderStateMixin {
  late AnimationController animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 35),
  );
  late Animation<double> animate = Tween<double>(
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
        width: 61.02,
        height: 61.02,
        decoration: const ShapeDecoration(
          color: Color(0xFF07AC65),
          shape: StarBorder(
            points: 4,
            innerRadiusRatio: 0.39,
          ),
        ),
      ),
    );
  }
}
