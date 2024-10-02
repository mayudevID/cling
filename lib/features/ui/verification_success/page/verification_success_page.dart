import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common_widget.dart';
import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../widget/dialog_close_verif_onboard.dart';

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
                height: 110.h,
              ),
              SizedBox(
                width: 100.w,
                height: 197.h,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 197.w,
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
                      right: 90.w,
                      bottom: 50.h,
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
                    Positioned(
                      top: 10.h,
                      left: 118.w,
                      child: Container(
                        width: 48.w,
                        height: 48.w,
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
                      left: 140.w,
                      child: Container(
                        width: 29.w,
                        height: 29.w,
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
                height: 81.h,
              ),
              Text(
                "Verified",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: FontFamily.bungee,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 47.w),
                child: Text(
                  AppLocalizations.of(context)!.verifSuccess,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 59.h,
              ),
              PinkButton(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.monthlyData);
                },
                name: AppLocalizations.of(context)!.setMonthlyBudget,
              ),
              SizedBox(
                height: 8.h,
              ),
              BlackButton(
                name: AppLocalizations.of(context)!.skip,
                onTap: () {
                  dialogCloseVerifOnboard(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
