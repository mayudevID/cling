// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(
            top: 44.54,
            left: 112.5,
            right: 112.5,
            bottom: 44.54,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "✅",
                style: TextStyle(
                  fontSize: 43,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 29.69,
              ),
              Text(
                (msg == FlowType.income)
                    ? AppLocalizations.of(context)!.incomeAdded
                    : (msg == FlowType.expense)
                        ? AppLocalizations.of(context)!.expenseAdded
                        : "Goal Added",
                style: const TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5,
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
  final result = await OpenMailApp.openMailApp();
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
