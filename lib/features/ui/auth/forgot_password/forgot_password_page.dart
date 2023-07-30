import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../login/widgets/tag_name_login.dart';

import 'widgets/text_field_email_forgot.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 20.wmea),
          child: Column(
            children: [
              SizedBox(
                height: 40.hmea,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Assets.lib.resources.images.backButton.svg()),
              ),
              SizedBox(
                height: 36.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 8.hmea,
              ),
              Text(
                'Don\'t worry! enter your mail so we can share you link to change password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 32.hmea,
              ),
              const TagNameLogin(name: "Email"),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldEmailForgot(),
              SizedBox(
                height: 40.hmea,
              ),
              PinkButton(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.checkEmail,
                  );
                },
                name: "Send me link",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
