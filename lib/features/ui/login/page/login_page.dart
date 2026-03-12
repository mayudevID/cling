import '../../../../core/common_widget.dart';
import '../../../../core/route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection.dart';
import '../../../../../resources/gen/fonts.gen.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/database_repository.dart';
import '../../../repository/settings_repository.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/login_bloc.dart';

import '../widgets/form_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(
        authRepo: getIt<AuthRepository>(),
        settingsRepo: getIt<SettingsRepository>(),
        dbRepo: getIt<DatabaseRepository>(),
      ),
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                AppLocalizations.of(context)!.descWelcomeBack,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              ...formLogin(context),
              const SizedBox(
                height: 40,
              ),
              PinkButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<LoginBloc>().add(const SendLogin());
                },
                name: AppLocalizations.of(context)!.login,
              ),
              // SizedBox(
              //   height: 24,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 1,
              //         color: Colors.grey,
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 24),
              //       child: Text(
              //         AppLocalizations.of(context)!.or,
              //         style: TextStyle(
              //           fontSize: 10,
              //           color: Colors.white,
              //           fontFamily: FontFamily.cabinetGrotesk,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Container(
              //         height: 1,
              //         color: Colors.grey,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 24,
              // ),
              // SizedBox(
              //   width: 390,
              //   height: 57,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(
              //         const Color(0xFF101010),
              //       ),
              //       overlayColor: null,
              //       shape: MaterialStateProperty.all(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Assets.lib.resources.images.mdiPerson.svg(
              //           // ignore: deprecated_member_use_from_same_package
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           AppLocalizations.of(context)!.loginWithAnon,
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 11.5,
              //             fontFamily: FontFamily.cabinetGrotesk,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.dontHaveAnAccount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${AppLocalizations.of(context)!.createNewAccount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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
              const SizedBox(
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
