// ignore_for_file: use_build_context_synchronously

import '../../../../core/common_widget.dart';
import '../../../../resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

import '../../../../core/open_mail_app.dart';
import '../../language_currency/lang_export.dart';
import '../widgets/email_with_star.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(
              height: 110,
            ),
            const EmailWithStar(),
            const SizedBox(
              height: 81,
            ),
            Text(
              AppLocalizations.of(context)!.checkYourEmail,
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
              padding: const EdgeInsets.symmetric(horizontal: 47),
              child: Text(
                AppLocalizations.of(context)!.descCheckYourEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 81,
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
    );
  }
}
