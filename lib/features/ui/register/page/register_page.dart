import 'package:cling/core/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 24.wmea),
          child: Column(
            children: [
              SizedBox(height: 40.hmea),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.helloThere,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: FontFamily.bungee,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 8.hmea),
              Text(
                AppLocalizations.of(context)!.descHelloThere,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32.hmea),
              ...formRegister(context),
              SizedBox(height: 40.hmea),
              PinkButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<RegisterBloc>().add(const SendRegister());
                },
                name: AppLocalizations.of(context)!.createNewAccount,
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.haveAccountTwo,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: FontFamily.cabinetGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' ${AppLocalizations.of(context)!.login}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
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
              SizedBox(height: 24.hmea),
            ],
          ),
        ),
      ),
    );
  }
}
