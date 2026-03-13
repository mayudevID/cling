// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';

import '../../../../core/common_widget.dart';

import '../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import '../../../../core/open_mail_app.dart';
import '../../language_currency/lang_export.dart';
import '../widgets/box_face.dart';

import '../widgets/oval_stack.dart';
import '../widgets/stack_star_reg.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              const SizedBox(
                width: 100,
                height: 33.33 * 3,
                child: Stack(
                  //fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        OvalStack(),
                        OvalStack(),
                        OvalStack(),
                      ],
                    ),
                    BoxFace(),
                    StackStarReg(),
                  ],
                ),
              ),
              const SizedBox(
                height: 97,
              ),
              Text(
                AppLocalizations.of(context)!.almostThere,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  AppLocalizations.of(context)!.lastStep,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 63,
              ),
              PinkButton(
                onTap: () async {
                  final result = await OpenMailApp.openMailApp();

                  if (!result.didOpen && !result.canOpen) {
                    Future.microtask(() {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Open Mail App"),
                            content: const Text("No mail apps installed"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    });
                  } else if (!result.didOpen && result.canOpen) {
                    Future.microtask(() {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                          );
                        },
                      );
                    });
                  }
                },
                name: AppLocalizations.of(context)!.goToMail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
