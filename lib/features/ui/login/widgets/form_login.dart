
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import 'tag_name_login.dart';
import 'text_field_email_login.dart';
import 'text_field_pass_login.dart';

List<Widget> formLogin(BuildContext context) {
  return [
    TagNameLogin(name: AppLocalizations.of(context)!.email),
    SizedBox(
      height: 8.h,
    ),
    const TextFieldEmailLogin(),
    SizedBox(
      height: 16.h,
    ),
    TagNameLogin(name: AppLocalizations.of(context)!.password),
    SizedBox(
      height: 8.h,
    ),
    const TextFieldPassLogin(),
    SizedBox(
      height: 16.h,
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  ];
}
