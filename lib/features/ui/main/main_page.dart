import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nil/nil.dart';

import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'home/page/home_page.dart';
import 'main_bloc/main_bloc.dart';
import 'main_widget/custom_fab.dart';
import 'main_widget/custom_nav_bar.dart';
import 'profile/page/profile_page.dart';
import 'statistics/page/statistics_page.dart';
import 'transaction/page/transaction_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainBloc(),
      child: const MainPageContent(),
    );
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF101010),
          body: Stack(
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
                    children: [
                      const HomePage(),
                      const TransactionPage(),
                      StatisticsPage(),
                      const ProfilePage(),
                    ],
                  );
                },
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomNavBar(),
              ),
            ],
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
      ),
    );
  }
}
