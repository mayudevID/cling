import 'dart:async';

import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../../core/open_mail_app.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import 'enum_flowtype.dart';

Future<void> dialogAddSuccess(
  BuildContext context,
  FlowType? msg,
) async {
  Timer(
    const Duration(milliseconds: 1500),
    () {
      Navigator.of(context)
        ..pop()
        ..pop();
    },
  );
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.6),
            ),
            color: const Color(0xFF313131),
          ),
          padding: EdgeInsets.only(
            top: 44.54.hmea,
            left: 112.5.wmea,
            right: 112.5.wmea,
            bottom: 44.54.hmea,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "✅",
                style: TextStyle(
                  fontSize: 43.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 29.69.hmea,
              ),
              Text(
                (msg == FlowType.income)
                    ? AppLocalizations.of(context)!.incomeAdded
                    : (msg == FlowType.expense)
                        ? AppLocalizations.of(context)!.expenseAdded
                        : "Goal Added",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
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
