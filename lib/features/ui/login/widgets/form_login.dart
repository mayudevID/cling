import 'package:flutter/material.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import 'tag_name_login.dart';
import 'text_field_email_login.dart';
import 'text_field_pass_login.dart';

List<Widget> formLogin(BuildContext context) {
  return [
    TagNameLogin(name: AppLocalizations.of(context)!.email),
    const SizedBox(
      height: 8,
    ),
    const TextFieldEmailLogin(),
    const SizedBox(
      height: 16,
    ),
    TagNameLogin(name: AppLocalizations.of(context)!.password),
    const SizedBox(
      height: 8,
    ),
    const TextFieldPassLogin(),
    const SizedBox(
      height: 16,
    ),
    Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.forgotPassword,
          );
        },
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  ];
}
