import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/onboard/widgets/button_onboard.dart';
import 'package:cling/features/onboard/widgets/stack_emoticon.dart';

import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'widgets/animation_onboard.dart';
import 'widgets/stack_star.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage>
    with TickerProviderStateMixin {
  late List<Animation<double>> listSpinAnimation;
  late Animation<RelativeRect> _animationTween;

  @override
  void initState() {
    listSpinAnimation = AnimationOnboard.setAnimationsStar(this);
    _animationTween = AnimationOnboard.setAnimationEmoticon(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              width: 100.w,
              height: Utils.h(430).h,
              child: Stack(
                children: [
                  const StackEmoticon(),
                  StackStar(
                    listAnimation: listSpinAnimation,
                  ),
                  PositionedTransition(
                    rect: _animationTween,
                    child: Center(
                      child: Assets.lib.resources.images.emoticon.image(
                        width: Utils.w(238.9).w,
                        height: Utils.w(238.9).w,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Utils.h(24).h,
            ),
            Text(
              "Cling!",
              style: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: FontFamily.bungee,
              ),
            ),
            SizedBox(
              height: Utils.h(24).h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Manage Your Money, Reach Your Goals, and Thrive.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: Utils.h(32).h,
            ),
            ButtonOnboard(
              type: "New",
              onTap: () {
                Navigator.pushNamed(context, RouteName.register);
              },
            ),
            SizedBox(
              height: Utils.h(8).h,
            ),
            ButtonOnboard(
              type: "Already",
              onTap: () {
                Navigator.pushNamed(context, RouteName.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
