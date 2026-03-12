import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

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
            children: [
              const SizedBox(
                height: 110,
              ),
              SizedBox(
                width: 100,
                height: 197,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 197,
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
                      right: 90,
                      bottom: 50,
                      child: Container(
                        width: 61.02,
                        height: 61.02,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF2D82D),
                          shape: StarBorder(
                            points: 4,
                            innerRadiusRatio: 0.39,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 118,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF2D82D),
                          shape: StarBorder(
                            points: 4,
                            innerRadiusRatio: 0.39,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 140,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF2D82D),
                          shape: StarBorder(
                            points: 4,
                            innerRadiusRatio: 0.39,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 81,
              ),
              const Text(
                "Verified",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: FontFamily.bungee,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 47),
                child: Text(
                  AppLocalizations.of(context)!.verifSuccess,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 59,
              ),
              PinkButton(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.monthlyData);
                },
                name: AppLocalizations.of(context)!.setMonthlyBudget,
              ),
              const SizedBox(
                height: 8,
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
