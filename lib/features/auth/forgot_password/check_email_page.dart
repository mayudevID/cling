import 'package:cling/core/utils.dart';
import 'package:cling/features/auth/forgot_password/widgets/email_with_star.dart';
import 'package:cling/features/auth/register/widgets/button_go_to_mail.dart';

import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:sizer/sizer.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              height: Utils.h(110).h,
            ),
            const EmailWithStar(),
            SizedBox(
              height: Utils.h(81).h,
            ),
            Text(
              'Check your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: FontFamily.bungee,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: Utils.h(16).h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Utils.w(47).w),
              child: Text(
                'Great! Now you can change your password through the link we send to your mail',
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
              height: Utils.h(81).h,
            ),
            ButtonGoToMail(
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
            )
          ],
        ),
      ),
    );
  }
}
