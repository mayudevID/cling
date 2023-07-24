import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/onboard/widgets/button_onboard.dart';
import 'package:cling/features/onboard/widgets/emoticon_widget.dart';
import 'package:cling/features/onboard/widgets/stack_emoticon.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'widgets/stack_star.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Stack(
              children: [
                const StackEmoticon(),
                SizedBox(
                  width: 100.w,
                  height: (215.hmea) * 2,
                  child: const StackStar(),
                ),
                const EmoticonWidget(),
              ],
            ),
            SizedBox(
              height: 40.hmea,
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
              height: 24.hmea,
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
              height: 32.hmea,
            ),
            ButtonOnboard(
              type: "New",
              onTap: () {
                Navigator.pushNamed(context, RouteName.register);
              },
            ),
            SizedBox(
              height: 8.hmea,
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
