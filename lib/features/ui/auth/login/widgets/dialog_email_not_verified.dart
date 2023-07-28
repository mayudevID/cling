import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogEmailNotVerified(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            top: 18.hmea,
            left: 18.wmea,
            right: 18.wmea,
            bottom: 18.hmea,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Email not verified",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Text(
                "Please verify email to unlock other features like database backup, photo replacement, and more",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.hmea,
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await Future.microtask(() async {
                        await openMail(context);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.hmea),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF06AC9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Go to mail",
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.wmea),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.hmea),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> openMail(BuildContext context) async {
  var result = await OpenMailApp.openMailApp();
  if (!result.didOpen && !result.canOpen) {
    await Future.microtask(() async {
      await showDialog(
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
}
