import 'package:cling/features/ui/main/verification_success/page/verification_success_page.dart';
import 'package:flutter/material.dart';

import '../features/ui/auth/forgot_password/check_email_page.dart';
import '../features/ui/auth/forgot_password/forgot_password_page.dart';
import '../features/ui/auth/login/page/login_page.dart';
import '../features/ui/auth/register/page/register_page.dart';
import '../features/ui/auth/register/page/register_success_page.dart';
import '../features/ui/main/main_page.dart';
import '../features/ui/main/verification_success/page/monthly_budget_income_page.dart';
import '../features/ui/main/verification_success/page/monthly_budget_spend_page.dart';
import '../features/ui/onboard/onboard_page.dart';
import '../features/ui/splash/splash_page.dart';

class RouteGen {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case '/onboard':
        return MaterialPageRoute(
          builder: (_) => const OnboardPage(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case '/registerSuccess':
        return MaterialPageRoute(
          builder: (_) => const RegisterSuccessPage(),
        );
      case '/forgotPassword':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
        );
      case '/checkEmail':
        return MaterialPageRoute(
          builder: (_) => const CheckEmailPage(),
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
        );
      case '/verifOnboard':
        return MaterialPageRoute(
          builder: (_) => const VerificationSuccessPage(),
        );
      case '/monthlyBudgetIncome':
        return MaterialPageRoute(
          builder: (_) => const MonthlyBudgetIncomePage(),
        );
      case '/monthlyBudgetSpend':
        return MaterialPageRoute(
          builder: (_) => const MonthlyBudgetSpendPage(),
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
  static String splash = "/";
  static String onboard = "/onboard";
  static String register = "/register";
  static String login = "/login";
  static String registerSuccess = "/registerSuccess";
  static String forgotPassword = "/forgotPassword";
  static String checkEmail = "/checkEmail";
  static String main = "/main";
  static String verifOnboard = "/verifOnboard";
  static String monthlyBudgetIncome = "/monthlyBudgetIncome";
  static String monthlyBudgetSpend = "/monthlyBudgetSpend";
}
