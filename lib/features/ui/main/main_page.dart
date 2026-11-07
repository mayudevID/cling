import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nil/nil.dart';
import 'package:get_it/get_it.dart';

import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'home/page/home_page.dart';
import 'main_bloc/main_bloc.dart';
import 'main_widget/custom_fab.dart';
import 'main_widget/custom_nav_bar.dart';
import 'profile/page/profile_page.dart';
import 'statistics/page/statistics_page.dart';
import 'transaction/page/transaction_page.dart';
import '../../repository/database_repository.dart';
import 'main_widget/finance_refresh.dart';

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

class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent>
    with WidgetsBindingObserver {
  final _repository = GetIt.I<DatabaseRepository>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reconcilePlanning());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reconcilePlanning();
  }

  Future<void> _reconcilePlanning() async {
    if (!_repository.isReady) return;
    final revision = _repository.revision;
    final uid = _repository.activeUserId;
    try {
      await _repository.reconcileFinancialPlanning(DateTime.now());
      if (!mounted ||
          revision != _repository.revision ||
          uid != _repository.activeUserId) {
        return;
      }
      refreshFinancialViews(context);
    } catch (_) {
      // Planning remains available offline; errors are shown when its screen
      // reloads the local reconciliation state.
    }
  }

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
