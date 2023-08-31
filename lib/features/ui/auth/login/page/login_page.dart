import 'package:cling/core/common_widget.dart';
import 'package:cling/core/route.dart';
import 'package:cling/core/utils.dart';

import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sizer/sizer.dart';

import '../../../../../injection.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../language_currency/lang_export.dart';
import '../bloc/login_bloc.dart';

import '../widgets/form_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static var navKeyLogin = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(getIt<AuthRepository>()),
      child: const LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatelessWidget {
  const LoginPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: LoginPage.navKeyLogin,
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
                  AppLocalizations.of(context)!.welcomeBack,
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
                AppLocalizations.of(context)!.descWelcomeBack,
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
              ...formLogin(context),
              SizedBox(
                height: 40.hmea,
              ),
              PinkButton(
                onTap: () async {
                  context.read<LoginBloc>().add(const SendLogin());
                },
                name: AppLocalizations.of(context)!.login,
              ),
              SizedBox(
                height: 24.hmea,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.hmea,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.wmea),
                    child: Text(
                      "or",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontFamily: FontFamily.cabinetGrotesk,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.hmea,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.hmea,
              ),
              SizedBox(
                width: 390.wmea,
                height: 57.wmea,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF101010),
                    ),
                    overlayColor: null,
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.lib.resources.images.mdiPerson.svg(
                        // ignore: deprecated_member_use_from_same_package
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.wmea,
                      ),
                      Text(
                        "Login with Anonymous",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5.sp,
                          fontFamily: FontFamily.cabinetGrotesk,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.dontHaveAnAccount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${AppLocalizations.of(context)!.createNewAccount}',
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
