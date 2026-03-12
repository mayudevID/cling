import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common_widget.dart';
import '../../../../injection.dart';
import '../../../../resources/gen/assets.gen.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../../repository/auth_repository.dart';
import '../../language_currency/lang_export.dart';
import '../../login/widgets/tag_name_login.dart';

import '../cubit/forgot_password_cubit.dart';
import '../widgets/text_field_email_forgot.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        authRepo: getIt<AuthRepository>(),
      ),
      child: const ForgotPasswordPageContent(),
    );
  }
}

class ForgotPasswordPageContent extends StatelessWidget {
  const ForgotPasswordPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Assets.lib.resources.images.backButton.svg(),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.forgotPasswordPage,
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
                AppLocalizations.of(context)!.descForgotPassword,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              TagNameLogin(name: AppLocalizations.of(context)!.email),
              const SizedBox(height: 8),
              const TextFieldEmailForgot(),
              const SizedBox(height: 40),
              PinkButton(
                onTap: () {
                  context.read<ForgotPasswordCubit>().sendResetPassword();
                },
                name: AppLocalizations.of(context)!.sendMeLink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
