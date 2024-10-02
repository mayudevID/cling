import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/common_widget.dart';
import '../../../core/route.dart';
import '../../../resources/gen/fonts.gen.dart';
import '../language_currency/lang_export.dart';
import '../language_currency/lang_currency_bloc.dart';
import 'widgets/emoticon_widget.dart';
import 'widgets/stack_emoticon.dart';
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
                  width: 1.sw,
                  height: (215.h) * 2,
                  child: const StackStar(),
                ),
                const EmoticonWidget(),
              ],
            ),
            SizedBox(
              height: 40.h,
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
              height: 24.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppLocalizations.of(context)!.onboarding,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            PinkButton(
              name: AppLocalizations.of(context)!.newUser,
              onTap: () {
                Navigator.pushNamed(context, RouteName.register);
              },
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 370.w,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showBottomSheetChooseLang(context);
                    },
                    child: Container(
                      width: 57.h,
                      height: 57.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                          builder: (context, state) {
                            return Text(
                              state.selectedLanguage.text.substring(
                                0,
                                state.selectedLanguage.text.indexOf(" "),
                              ),
                              style: TextStyle(fontSize: 22.sp),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.login);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.haveAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF599DA),
                        fontSize: 16.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}
