import 'package:cling/features/repository/auth_repository.dart';
import 'package:cling/features/ui/main/profile/bloc/profile_bloc.dart';
import 'package:cling/features/ui/main/profile/page/profile_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nil/nil.dart';
import 'package:sizer/sizer.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

import '../../../injection.dart';
import '../../repository/database_repository.dart';
import 'home/bloc/home_bloc.dart';
import 'home/page/home_page.dart';
import 'main_bloc/main_bloc.dart';
import 'main_widget/custom_fab.dart';
import 'main_widget/custom_nav_bar.dart';
import 'statistics/bloc/statistics_bloc.dart';
import 'statistics/page/statistics_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static GlobalKey<NavigatorState> navKeyMain = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MainBloc(),
        ),
        BlocProvider(
          create: (_) => HomeBloc(
            dbRepo: getIt<DatabaseRepository>(),
          )
            ..add(GetIncomeExpenseAmountTotalCurrMonth())
            ..add(GetGoals())
            ..add(GetTodayExpenses()),
        ),
        BlocProvider(
          create: (_) => StatisticsBloc(
            dbRepo: getIt<DatabaseRepository>(),
          )
            ..add(GetIncomeExpenseTotalAllMonth())
            ..add(GetMostExpense())
            ..add(GetYearlyIncome())
            ..add(GetIncomeBreakdown()),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(
            authRepo: getIt<AuthRepository>(),
            dbRepo: getIt<DatabaseRepository>(),
          )
            ..add(GetProfile())
            ..add(GetVerifiedStatus()),
        ),
      ],
      child: const MainPageContent(),
    );
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: MainPage.navKeyMain,
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF101010),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Stack(
            children: [
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) {
                  return previous.tabIndex != current.tabIndex;
                },
                builder: (context, state) {
                  return FadeIndexedStack(
                    index: state.tabIndex,
                    duration: const Duration(milliseconds: 60),
                    beginOpacity: 0.75,
                    endOpacity: 1,
                    children: const [
                      HomePage(),
                      StatisticsPage(),
                      ProfilePage(),
                    ],
                  );
                },
              ),
              const Positioned(
                bottom: 0,
                child: CustomNavBar(),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state.tabIndex == 0) {
              return customFloatingActionButton(context);
            }

            return nil;
          },
        ),
      ),
    );
  }
}
