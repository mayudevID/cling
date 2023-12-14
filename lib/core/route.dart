import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/ui/main/add_in_ex/page/add_in_ex_page.dart';
import 'package:cling/features/ui/main/edit_monthly/page/edit_budget_or_income.dart';
import 'package:cling/features/ui/main/edit_profile/page/edit_profile_page.dart';
import 'package:flutter/material.dart';
import '../features/ui/forgot_password/page/check_email_page.dart';
import '../features/ui/forgot_password/page/forgot_password_page.dart';
import '../features/ui/login/page/login_page.dart';
import '../features/ui/main/add_goal/page/add_goal_page.dart';
import '../features/ui/main/goal_detail/pages/goal_detail_page.dart';
import '../features/ui/main/main_page.dart';
import '../features/ui/main/stats_detail/page/stats_detail_per_categories_widget.dart';
import '../features/ui/onboard/onboard_page.dart';
import '../features/ui/register/page/register_page.dart';
import '../features/ui/register/page/register_success_page.dart';
import '../features/ui/splash/splash_page.dart';
import '../features/ui/verification_success/page/monthly_data_page.dart';
import '../features/ui/verification_success/page/verification_success_page.dart';

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
      case RouteName.goalsDetail:
        return MaterialPageRoute(
          builder: (_) => GoalDetailPage(
            goalModel: data as GoalModel,
          ),
        );
      case RouteName.addInEx:
        return MaterialPageRoute(
          builder: (_) => AddIncomeExpensePage(
            flowType: data as FlowType,
          ),
        );
      case RouteName.addGoal:
        return MaterialPageRoute(
          builder: (_) => const AddGoalPage(),
        );
      case RouteName.statsDetailPerCategories:
        return MaterialPageRoute(
          builder: (_) => StatsDetailPerCategoriesPage(
            categoryOrSource: data as String,
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
  static const String goalsDetail = "/goalsDetail";
  static const String addGoal = "/addGoal";
  static const String addInEx = "/addInEx";
  static const String statsDetailPerCategories = "/statsDetailPerCategories";
}
