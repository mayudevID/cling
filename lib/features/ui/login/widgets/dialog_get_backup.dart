import '../../language_currency/lang_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';

Future<bool> dialogGetBackup(
  BuildContext context,
  DateTime dateOfLastBackup,
) async {
  final dateFormat = context
      .read<LangCurrencyBloc>()
      .state
      .selectedLanguage
      .value
      .toLanguageTag();
  return await showDialog(
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
                AppLocalizations.of(context)!.backupFound,
                style: const TextStyle(
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.lastBackup,
                    style: const TextStyle(
                      fontFamily: FontFamily.cabinetGrotesk,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: " "),
                      TextSpan(
                        text: DateFormat.yMd(dateFormat)
                            .add_jm()
                            .format(dateOfLastBackup),
                        style: const TextStyle(
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.useThisBackup,
                  style: const TextStyle(
                    fontFamily: FontFamily.cabinetGrotesk,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Align(
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                          style: const TextStyle(
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
                    onTap: () {
                      Navigator.pop(context, false);
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
                          AppLocalizations.of(context)!.skip,
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
