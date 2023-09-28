import 'package:cling/core/common_widget.dart';
import 'package:cling/core/utils.dart';
import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:cling/injection.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../resources/gen/fonts.gen.dart';
import '../../language_currency/lang_export.dart';
import '../../login/widgets/tag_name_login.dart';

import '../widgets/text_field_email_forgot.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        context: context,
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
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
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
                  child: Assets.lib.resources.images.backButton.svg(),
                ),
              ),
              SizedBox(
                height: 36.hmea,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.forgotPasswordPage,
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
                AppLocalizations.of(context)!.descForgotPassword,
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
              TagNameLogin(name: AppLocalizations.of(context)!.email),
              SizedBox(
                height: 8.hmea,
              ),
              const TextFieldEmailForgot(),
              SizedBox(
                height: 40.hmea,
              ),
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
