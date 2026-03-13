import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/route.dart';
import '../../../../../injection.dart';
import '../../../../core/common_widget.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../../repository/auth_repository.dart';
import '../../language_currency/lang_export.dart';
import '../bloc/register_bloc.dart';
import '../widgets/form_register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(authRepo: getIt<AuthRepository>()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.helloThere,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.descHelloThere,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              ...formRegister(context),
              const SizedBox(height: 40),
              PinkButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<RegisterBloc>().add(const SendRegister());
                },
                name: AppLocalizations.of(context)!.createNewAccount,
              ),
              const Expanded(child: SizedBox()),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.haveAccountTwo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' ${AppLocalizations.of(context)!.login}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
