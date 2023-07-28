import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

class AnimationOnboard {
  static late AnimationController animC1;
  static late AnimationController animC2;
  static late AnimationController animC3;
  static late AnimationController animC4;

  static Animation<double> setAnimStarOne(classMixin) {
    animC1 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 35),
    );

    Animation<double> animate = Tween<double>(
      begin: 0,
      end: -12.5664,
    ).animate(animC1);
    animC1.forward();

    animate.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animC1.repeat();
        }
      },
    );

    return animate;
  }

  static Animation<double> setAnimStarThree(classMixin) {
    animC2 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 15),
    );

    Animation<double> animate = Tween<double>(
      begin: 0,
      end: 12.5664,
    ).animate(animC2);
    animC2.forward();

    animate.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animC2.repeat();
        }
      },
    );

    return animate;
  }

  static Animation<double> setAnimStarTwo(classMixin) {
    animC3 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 60),
    );

    Animation<double> animate = Tween<double>(
      begin: 0,
      end: -12.5664,
    ).animate(animC3);
    animC3.forward();

    animate.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animC3.repeat();
        }
      },
    );

    return animate;
  }

  static Animation<RelativeRect> setAnimationEmoticon(classMixin) {
    animC4 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 2),
    );
    late Animation<RelativeRect> animationTween;

    animationTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, 0, 0, -1 * 55.hmea),
      end: RelativeRect.fromLTRB(0, 0, 0, 55.hmea),
    ).animate(
      CurvedAnimation(
        parent: animC4,
        curve: Curves.easeInOut,
      ),
    );

    animC4.forward();
    animationTween.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          animC4.reverse();
          Future.delayed(const Duration(seconds: 2)).then(
            (value) {
              animC4.forward();
            },
          );
        }
      },
    );

    return animationTween;
  }
}
