import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:sizer/sizer.dart';

import '../widgets/box_face.dart';
import '../widgets/button_go_to_mail.dart';
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
              height: Utils.h(97).h,
            ),
            Text(
              'Almost there',
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
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: Text(
                'The last step is verify your account. Go to mail to verify your account now',
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
              height: Utils.h(63).h,
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
            ),
          ],
        ),
      ),
    );
  }
}
