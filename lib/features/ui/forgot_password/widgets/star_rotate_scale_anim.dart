import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarRotateScaleAnim extends StatefulWidget {
  const StarRotateScaleAnim({super.key});

  @override
  State<StarRotateScaleAnim> createState() => _StarRotateScaleAnimState();
}

class _StarRotateScaleAnimState extends State<StarRotateScaleAnim>
    with TickerProviderStateMixin {
  late AnimationController _animC;
  late AnimationController _animC2;
  late Animation<double> _curveAnimC2;

  @override
  void initState() {
    _animC = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    Animation<double> animate = Tween<double>(
      begin: 0,
      end: -12.5664,
    ).animate(_animC);
    _animC.forward();

    animate.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animC.repeat();
        }
      },
    );

    _animC2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _curveAnimC2 = CurvedAnimation(
      parent: _animC2,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animC.dispose();
    _animC2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 120.w,
      child: ScaleTransition(
        scale: _curveAnimC2,
        child: RotationTransition(
          turns: _animC,
          child: Container(
            width: 61.02.w,
            height: 61.02.w,
            decoration: const ShapeDecoration(
              color: Color(0xFFF2D82D),
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
        ),
      ),
    );
  }
}
