import 'package:cling/features/ui/main/home/page/add_goal_page.dart';
import 'package:cling/features/ui/main/home/page/add_in_ex_page.dart';
import 'package:cling/features/ui/main/profile/page/profile_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nil/nil.dart';
import 'package:sizer/sizer.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

import '../../../injection.dart';
import '../../repository/database_repository.dart';
import 'bloc/enum_home_page_state.dart';
import 'bloc/main_bloc.dart';
import 'home/bloc/home_bloc.dart';
import 'home/page/home_page.dart';
import 'main_widget/custom_fab.dart';
import 'main_widget/custom_nav_bar.dart';
import 'statistics/bloc/statistics_bloc.dart';
import 'statistics/page/statistics_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static GlobalKey<NavigatorState> navigatorKeyMain =
      GlobalKey<NavigatorState>();

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
            ..add(GetTotalIncome())
            ..add(GetTotalExpense())
            ..add(GetTodayExpenses())
            ..add(GetGoals()),
        ),
        BlocProvider(
          create: (_) => StatisticsBloc(),
        ),
      ],
      child: const MainPageContent(),
    );
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  Widget homePageStatus(MainState state) {
    switch (state.homePageState) {
      case HomePageState.home:
        return const HomePage();
      case HomePageState.goal:
        return const AddGoalPage();
      case HomePageState.income:
        return const AddIncomeExpensePage(flowType: FlowType.income);
      case HomePageState.expense:
        return const AddIncomeExpensePage(flowType: FlowType.expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: MainPage.navigatorKeyMain,
        backgroundColor: const Color(0xFF101010),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Stack(
            children: [
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) {
                  return (previous.tabIndex != current.tabIndex) ||
                      (previous.homePageState != current.homePageState);
                },
                builder: (context, state) {
                  return FadeIndexedStack(
                    index: state.tabIndex,
                    duration: const Duration(milliseconds: 50),
                    beginOpacity: 0.75,
                    endOpacity: 1,
                    children: [
                      homePageStatus(state),
                      const StatisticsPage(),
                      const ProfilePage(),
                    ],
                  );
                },
              ),
              customNavBar(context),
            ],
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state.tabIndex == 0 &&
                state.homePageState == HomePageState.home) {
              return customFloatingActionButton(context);
            }

            return nil;
          },
        ),
      ),
    );
  }
}
