import 'package:flutter/material.dart';

class AnimationOnboard {
  static late AnimationController animC1;
  static late AnimationController animC2;
  static late AnimationController animC3;
  static late AnimationController animC4;

  static List<Animation<double>> setAnimationsStar(classMixin) {
    List<Animation<double>> listSpinAnimation = [];

    animC1 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 35),
    );
    animC2 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 15),
    );
    animC3 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 60),
    );

    List<Map<String, dynamic>> animations = [
      {
        'animationController': animC1,
        'animation': Tween<double>(
          begin: 0,
          end: -12.5664,
        ),
      },
      {
        'animationController': animC2,
        'animation': Tween<double>(
          begin: 0,
          end: 12.5664,
        ),
      },
      {
        'animationController': animC3,
        'animation': Tween<double>(
          begin: 0,
          end: -12.5664,
        ),
      },
    ];

    for (int i = 0; i < animations.length; i++) {
      AnimationController animationController =
          animations[i]['animationController'];
      Tween<double> animation = animations[i]['animation'];

      Animation<double> animate = animation.animate(animationController);
      animationController.forward();

      animate.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            animationController.repeat();
          }
        },
      );

      listSpinAnimation.add(animate);
    }

    return listSpinAnimation;
  }

  static Animation<RelativeRect> setAnimationEmoticon(classMixin) {
    animC4 = AnimationController(
      vsync: classMixin,
      duration: const Duration(seconds: 2),
    );
    late Animation<RelativeRect> animationTween;

    animationTween = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 0, 0, -55),
      end: const RelativeRect.fromLTRB(0, 0, 0, 55),
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
