// ignore_for_file: use_build_context_synchronously

import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';

import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../../core/open_mail_app.dart';
import '../../language_currency/lang_export.dart';
import '../widgets/box_face.dart';

import '../widgets/oval_stack.dart';
import '../widgets/stack_star_reg.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              width: 100.w,
              height: 33.33.w * 3,
              child: const Stack(
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
            SizedBox(
              height: 97.hmea,
            ),
            Text(
              AppLocalizations.of(context)!.almostThere,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontFamily: FontFamily.bungee,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 16.hmea,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                AppLocalizations.of(context)!.lastStep,
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
              height: 63.hmea,
            ),
            PinkButton(
              onTap: () async {
                var result = await OpenMailApp.openMailApp();

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
    );
  }
}
