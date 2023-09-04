import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'monthly_data_page.dart';

class VerificationSuccessPage extends StatelessWidget {
  const VerificationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110.hmea,
              ),
              SizedBox(
                width: 100.w,
                height: 197.hmea,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 197.wmea,
                        height: double.infinity,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF313131),
                          shape: OvalBorder(),
                        ),
                        child: Center(
                          child: Lottie.asset(
                            "lib/resources/anim/green_tick.json",
                            animate: true,
                            repeat: true,
                            width: double.infinity,
                            height: double.infinity,
                            frameRate: FrameRate.max,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 90.wmea,
                      bottom: 50.hmea,
                      child: Container(
                        width: 61.02.wmea,
                        height: 61.02.wmea,
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
                    Positioned(
                      top: 10.hmea,
                      left: 118.wmea,
                      child: Container(
                        width: 48.wmea,
                        height: 48.wmea,
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
                    Positioned(
                      bottom: 0,
                      left: 140.wmea,
                      child: Container(
                        width: 29.wmea,
                        height: 29.wmea,
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
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 81.hmea,
              ),
              Text(
                "Verified",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontFamily: FontFamily.bungee,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 16.hmea,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 47.wmea),
                child: Text(
                  "Get ready to dive headfirst into the app, where you can effortlessly glide through its awesome features and unlock a goal!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 59.hmea,
              ),
              PinkButton(
                onTap: () {
                  // Navigator.pushNamed(
                  //   context,
                  //   RouteName.monthlyBudget,
                  // );
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const MonthlyDataPage();
                  }));
                },
                name: "Set Monthly Budget",
              ),
              SizedBox(
                height: 8.hmea,
              ),
              BlackButton(
                name: "Skip",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
