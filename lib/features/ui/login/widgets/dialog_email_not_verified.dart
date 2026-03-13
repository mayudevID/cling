// ignore_for_file: use_build_context_synchronously

import '../../language_currency/lang_export.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/gen/fonts.gen.dart';
import '../../../../core/open_mail_app.dart';

Future<void> dialogEmailNotVerified(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => Dialog(
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
        padding: const EdgeInsets.only(
          top: 18,
          left: 18,
          right: 18,
          bottom: 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.emailNotConfirmed,
              style: const TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.goVerify,
              style: const TextStyle(
                fontFamily: FontFamily.cabinetGrotesk,
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                await Future.microtask(() async {
                  await openMail(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF06AC9),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Align(
                  child: Text(
                    "Go to mail",
                    style: TextStyle(
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                  Navigator.of(context)
                    ..pop()
                    ..pop();
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
