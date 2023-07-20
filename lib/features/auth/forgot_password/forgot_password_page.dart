import 'package:cling/core/route.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils.dart';
import '../../../resources/gen/fonts.gen.dart';
import '../login/widgets/tag_name_login.dart';
import 'widgets/button_send_link.dart';
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
          padding: EdgeInsets.symmetric(horizontal: Utils.w(20).w),
          child: Column(
            children: [
              SizedBox(
                height: Utils.h(40).h,
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
                height: Utils.h(36).h,
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
                height: Utils.h(8).h,
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
                height: Utils.h(32).h,
              ),
              const TagNameLogin(name: "Email"),
              SizedBox(
                height: Utils.h(8).h,
              ),
              const TextFieldEmailForgot(),
              SizedBox(
                height: Utils.h(40).h,
              ),
              ButtonSendLink(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.checkEmail,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
