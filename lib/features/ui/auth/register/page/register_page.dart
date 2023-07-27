import 'package:cling/core/utils.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/route.dart';
import '../bloc/register_bloc.dart';
import '../widgets/button_regist.dart';
import '../widgets/tag_name_reg.dart';
import '../widgets/text_field_con_pass_reg.dart';
import '../widgets/text_field_email_reg.dart';
import '../widgets/text_field_pass_reg.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: const RegisterPageContent(),
    );
  }
}

class RegisterPageContent extends StatelessWidget {
  const RegisterPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.wmea),
          child: Column(
            children: [
              SizedBox(
                height: 40.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello THERE! ✨',
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
                'Nice to meet you! enter your identity to reach your goals',
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
              const TagNameReg(name: "Email"),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldEmailReg(),
              SizedBox(
                height: 16.hmea,
              ),
              const TagNameReg(name: "Password"),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldPassReg(),
              SizedBox(
                height: 16.hmea,
              ),
              const TagNameReg(
                name: 'Confirm Password',
              ),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldConPassReg(),
              SizedBox(
                height: 40.hmea,
              ),
              ButtonRegist(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.registerSuccess,
                  );
                },
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' Login',
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
                            RouteName.login,
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
