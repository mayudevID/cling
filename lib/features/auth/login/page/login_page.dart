import 'package:cling/core/route.dart';
import 'package:cling/features/onboard/widgets/animation_onboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../bloc/login_bloc.dart';
import '../widgets/button_login.dart';
import '../widgets/tag_name_login.dart';
import '../widgets/text_field_email_login.dart';
import '../widgets/text_field_pass_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(),
      child: const LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatelessWidget {
  const LoginPageContent({super.key});

  Future<void> stopAnimation() async {
    AnimationOnboard.animC1.dispose();
    AnimationOnboard.animC2.dispose();
    AnimationOnboard.animC3.dispose();
    AnimationOnboard.animC4.dispose();
    await Future.delayed(const Duration(milliseconds: 250));
  }

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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome Back! ✨',
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
                'Enter your registed account to manage your money and reach your goals',
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
              const TextFieldEmailLogin(),
              SizedBox(
                height: 16.hmea,
              ),
              const TagNameLogin(name: "Password"),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldPassLogin(),
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
              SizedBox(
                height: 40.hmea,
              ),
              ButtonLogin(
                onTap: () async {
                  await stopAnimation();
                  Future.microtask(() {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.main,
                      (route) => false,
                    );
                  });
                },
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' Create New Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteName.register,
                          );
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 55.hmea,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
