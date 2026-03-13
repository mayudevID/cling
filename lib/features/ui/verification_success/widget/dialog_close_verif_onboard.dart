import '../../language_currency/lang_export.dart';
import 'package:flutter/material.dart';

import '../../../../../resources/gen/fonts.gen.dart';

Future<void> dialogCloseVerifOnboard(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              const Text(
                "Close",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Are you sure want to close? Monthly budget and Monthly Income will be empty.",
                style: TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Align(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        child: Text(
                          AppLocalizations.of(context)!.back,
                          style: const TextStyle(
                            fontFamily: FontFamily.cabinetGrotesk,
                            fontSize: 14,
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
