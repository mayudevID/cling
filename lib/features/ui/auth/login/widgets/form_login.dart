import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/route.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import 'tag_name_login.dart';
import 'text_field_email_login.dart';
import 'text_field_pass_login.dart';

List<Widget> formLogin(BuildContext context) {
  return [
    const TagNameLogin(name: "Email"),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldEmailLogin(context),
    SizedBox(
      height: 16.hmea,
    ),
    const TagNameLogin(name: "Password"),
    SizedBox(
      height: 8.hmea,
    ),
    textFieldPassLogin(context),
    SizedBox(
      height: 16.hmea,
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
          'Forgot Password?',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FontFamily.cabinetGrotesk,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  ];
}
