import 'package:cling/features/ui/main/edit_monthly/page/edit_budget_or_income.dart';
import 'package:cling/features/ui/main/edit_profile/page/edit_profile.dart';
import 'package:cling/features/ui/main/verification_success/page/verification_success_page.dart';
import 'package:flutter/material.dart';

import '../features/ui/auth/forgot_password/check_email_page.dart';
import '../features/ui/auth/forgot_password/forgot_password_page.dart';
import '../features/ui/auth/login/page/login_page.dart';
import '../features/ui/auth/register/page/register_page.dart';
import '../features/ui/auth/register/page/register_success_page.dart';
import '../features/ui/main/main_page.dart';
import '../features/ui/main/verification_success/page/monthly_data_page.dart';

import '../features/ui/onboard/onboard_page.dart';
import '../features/ui/splash/splash_page.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final data = settings.arguments;
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case RouteName.onboard:
        return MaterialPageRoute(
          builder: (_) => const OnboardPage(),
        );
      case RouteName.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );
      case RouteName.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case RouteName.registerSuccess:
        return MaterialPageRoute(
          builder: (_) => const RegisterSuccessPage(),
        );
      case RouteName.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
        );
      case RouteName.checkEmail:
        return MaterialPageRoute(
          builder: (_) => const CheckEmailPage(),
        );
      case RouteName.main:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
        );
      case RouteName.verifOnboard:
        return MaterialPageRoute(
          builder: (_) => const VerificationSuccessPage(),
        );
      case RouteName.monthlyData:
        return MaterialPageRoute(
          builder: (_) => const MonthlyDataPage(),
        );
      case RouteName.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfilePage(),
        );
      case RouteName.editMonBudgetOrIncome:
        return MaterialPageRoute(
          builder: (_) => EditMonBudgetOrIncomePage(
            monthlyMode: data as EditMonthlyMode,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(child: Text('Error page')),
        );
      },
    );
  }
}

class RouteName {
  static const String splash = "/";
  static const String onboard = "/onboard";
  static const String register = "/register";
  static const String login = "/login";
  static const String registerSuccess = "/registerSuccess";
  static const String forgotPassword = "/forgotPassword";
  static const String checkEmail = "/checkEmail";
  static const String main = "/main";
  static const String verifOnboard = "/verifOnboard";
  static const String monthlyData = "/monthlyData";
  static const String editProfile = "/editProfile";
  static const String editMonBudgetOrIncome = "/editMonBudgetOrIncome";
}
