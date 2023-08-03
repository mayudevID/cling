import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/model/language.dart';
import 'package:cling/features/ui/language/language_bloc.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import '../../../resources/gen/assets.gen.dart';
import '../language/lang_export.dart';
import 'widgets/emoticon_widget.dart';
import 'widgets/stack_emoticon.dart';
import 'widgets/stack_star.dart';
import 'dart:math' as math;

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
            SizedBox(
              height: 32.hmea,
            ),
            PinkButton(
              name: AppLocalizations.of(context)!.newUser,
              onTap: () {
                Navigator.pushNamed(context, RouteName.register);
              },
            ),
            SizedBox(
              height: 8.hmea,
            ),
            SizedBox(
              width: 390.wmea,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showBottomsheetChooseLang(context);
                    },
                    child: Container(
                      width: 57.hmea,
                      height: 57.hmea,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: BlocBuilder<LanguageBloc, LanguageState>(
                          builder: (context, state) {
                            return Text(
                              state.selectedLanguage.text.substring(
                                0,
                                state.selectedLanguage.text.indexOf(" "),
                              ),
                              style: TextStyle(fontSize: 24.sp),
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
                        fontSize: 13.5.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showBottomsheetChooseLang(BuildContext context) async {
    showMaterialModalBottomSheet(
      duration: const Duration(milliseconds: 200),
      context: context,
      enableDrag: false,
      builder: (context) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.all(24.wmea),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chooseLang,
                        style: TextStyle(
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Assets.lib.resources.images.plus.svg(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.hmea,
                  ),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        return listLanguage(state);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  ListView listLanguage(LanguageState state) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: Language.values.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            context.read<LanguageBloc>().add(
                  ChangeLanguage(
                    selectedLanguage: Language.values[index],
                  ),
                );
            await Future.delayed(
              const Duration(milliseconds: 300),
            ).then((value) {
              Navigator.pop(context);
            });
          },
          leading: Text(
            Language.values[index].text.substring(
              0,
              Language.values[index].text.indexOf(" "),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: FontFamily.cabinetGrotesk,
            ),
          ),
          title: Text(
            Language.values[index].text.substring(
              Language.values[index].text.indexOf(" ") + 1,
            ),
          ),
          trailing: Language.values[index] == state.selectedLanguage
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.black,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: Language.values[index] == state.selectedLanguage
                ? const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  )
                : BorderSide(color: Colors.grey[300]!),
          ),
          tileColor: Language.values[index] == state.selectedLanguage
              ? Colors.black.withOpacity(0.05)
              : null,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 18.hmea,
        );
      },
    );
  }
}
