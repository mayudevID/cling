import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Stack(
                children: [
                  const StackEmoticon(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: const StackStar(),
                  ),
                  const EmoticonWidget(),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                "Cling!",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: FontFamily.bungee,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppLocalizations.of(context)!.onboarding,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
              const SizedBox(height: 8),
              SizedBox(
                width: 370,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showBottomSheetChooseLang(context);
                      },
                      child: Container(
                        width: 57,
                        height: 57,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child:
                              BlocBuilder<LangCurrencyBloc, LangCurrencyState>(
                            builder: (context, state) {
                              return Text(
                                state.selectedLanguage.text.substring(
                                  0,
                                  state.selectedLanguage.text.indexOf(" "),
                                ),
                                style: const TextStyle(fontSize: 22),
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
                        style: const TextStyle(
                          color: Color(0xFFF599DA),
                          fontSize: 16,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
