// ignore_for_file: prefer_const_constructors

import 'package:cling/core/utils.dart';
import 'package:cling/features/main/home/add_expense_page.dart';
import 'package:cling/features/main/home/add_income_page.dart';
import 'package:cling/features/main/home/home_page.dart';
import 'package:cling/features/main/statistics/statistics_page.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:cling/resources/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sizer/sizer.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'dart:math' as math;

import 'bloc/enum_home_page_state.dart';
import 'bloc/main_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFF101010),
              body: SizedBox(
                width: 100.w,
                height: 100.h,
                child: Stack(
                  children: [
                    FadeIndexedStack(
                      beginOpacity: 0.5,
                      endOpacity: 1.0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeOutExpo,
                      index: state.tabIndex,
                      children: [
                        (state.homePageState == HomePageState.home)
                            ? HomePage()
                            : (state.homePageState == HomePageState.expense)
                                ? AddExpensePage()
                                : AddIncomePage(),
                        StatisticsPage(),
                        Text('Index 2: Search'),
                        Text('Index 3: Favorite'),
                      ],
                    ),
                    customNavBar(context, state)
                  ],
                ),
              ),
              floatingActionButtonLocation: ExpandableFab.location,
              floatingActionButton: (state.tabIndex == 0 &&
                      state.homePageState == HomePageState.home)
                  ? customFloatingActionButton(context)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget customFloatingActionButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Utils.h(96).h,
      ),
      child: ExpandableFab(
        child: Assets.lib.resources.images.plus.svg(),
        backgroundColor: Color(0xFFF599DA),
        foregroundColor: Colors.black,
        type: ExpandableFabType.up,
        closeButtonStyle: ExpandableFabCloseButtonStyle(
          backgroundColor: Color(0xFFF06AC9),
          foregroundColor: Colors.black,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Assets.lib.resources.images.plus.svg(),
          ),
        ),
        expandedFabShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        collapsedFabShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        distance: 60,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 5,
        ),
        expandedFabSize: ExpandableFabSize.regular,
        children: [
          GestureDetector(
            onTap: () {
              context.read<MainBloc>().add(
                    HomePageStateChange(
                      homePageState: HomePageState.income,
                    ),
                  );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: Utils.w(9).w,
                horizontal: Utils.h(19.5).h,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF599DA),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                'Add income',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<MainBloc>().add(
                    HomePageStateChange(
                      homePageState: HomePageState.expense,
                    ),
                  );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: Utils.w(9).w,
                horizontal: Utils.h(19.5).h,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF599DA),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                'Add expense',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.5.sp,
                  fontFamily: FontFamily.cabinetGrotesk,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customNavBar(BuildContext context, MainState state) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: 100.w - 40,
        margin: EdgeInsets.only(
          bottom: 11,
          left: 20,
          right: 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: Utils.h(25.5).h,
          horizontal: Utils.w(45.5).w,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF343437),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTabButton(
              state: state,
              onPressed: () => changeTab(context, 0),
              icon: Assets.lib.resources.images.fluentHome48Filled.svg(),
              isSelected: state.tabIndex == 0,
            ),
            buildTabButton(
              state: state,
              onPressed: () => changeTab(context, 1),
              icon: Assets.lib.resources.images.biBarChartFill.svg(),
              isSelected: state.tabIndex == 1,
            ),
            buildTabButton(
              state: state,
              onPressed: () => changeTab(context, 2),
              icon: Assets.lib.resources.images.faSolidWallet.svg(),
              isSelected: state.tabIndex == 2,
            ),
            buildTabButton(
              state: state,
              onPressed: () => changeTab(context, 3),
              icon: Assets.lib.resources.images.iconamoonProfileFill.svg(),
              isSelected: state.tabIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabButton({
    required MainState state,
    required VoidCallback onPressed,
    required Widget icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Opacity(
        opacity: isSelected
            ? (state.tabIndex == 0 && state.homePageState != HomePageState.home)
                ? 0.45
                : 1.0
            : 0.45,
        child: icon,
      ),
    );
  }

  void changeTab(BuildContext context, int tabIndex) {
    context.read<MainBloc>().add(TabChange(tabIndex: tabIndex));
  }
}
