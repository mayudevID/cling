// ignore_for_file: prefer_const_constructors

import 'package:cling/core/utils.dart';
import 'package:cling/features/main/home/home_page.dart';
import 'package:cling/resources/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
                    IndexedStack(
                      index: state.tabIndex,
                      children: const [
                        HomePage(),
                        Text('Index 1: Category'),
                        Text('Index 2: Search'),
                        Text('Index 3: Favorite'),
                      ],
                    ),
                    customNavBar(context, state)
                  ],
                ),
              ),
              floatingActionButton: (state.tabIndex == 0)
                  ? Container(
                      margin: EdgeInsets.only(
                        bottom: Utils.h(96).h,
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFFF599DA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        onPressed: () {},
                        child: Assets.lib.resources.images.plus.svg(),
                      ),
                    )
                  : null,
            ),
          );
        },
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
          horizontal: Utils.w(63).w,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF343437),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTabButton(
              onPressed: () => changeTab(context, 0),
              icon: Assets.lib.resources.images.fluentHome48Filled.svg(),
              isSelected: state.tabIndex == 0,
            ),
            buildTabButton(
              onPressed: () => changeTab(context, 1),
              icon: Assets.lib.resources.images.biBarChartFill.svg(),
              isSelected: state.tabIndex == 1,
            ),
            buildTabButton(
              onPressed: () => changeTab(context, 2),
              icon: Assets.lib.resources.images.faSolidWallet.svg(),
              isSelected: state.tabIndex == 2,
            ),
            buildTabButton(
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
    required VoidCallback onPressed,
    required Widget icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.45,
        child: icon,
      ),
    );
  }

  void changeTab(BuildContext context, int tabIndex) {
    context.read<MainBloc>().add(TabChange(tabIndex: tabIndex));
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
