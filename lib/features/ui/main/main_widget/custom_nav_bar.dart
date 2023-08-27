import 'package:cling/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../bloc/enum_home_page_state.dart';
import '../bloc/main_bloc.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listenWhen: (p, c) {
        return p.homePageState != c.homePageState;
      },
      listener: (context, state) {
        setState(() {
          isHidden = !isHidden;
        });
      },
      child: AnimatedPositioned(
        bottom: isHidden ? -200 : 0,
        duration: const Duration(milliseconds: 275),
        curve: Curves.easeInOutExpo,
        child: Container(
          width: 100.w - 40,
          margin: const EdgeInsets.only(
            bottom: 11,
            left: 20,
            right: 20,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 25.5.hmea,
            horizontal: 45.5.wmea,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF343437),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (p, c) {
                  return isStartBuild(p, c, 0);
                },
                builder: (context, state) {
                  return buildTabButton(
                    state: state,
                    onPressed: () => changeTab(state, context, 0),
                    icon: Assets.lib.resources.images.fluentHome48Filled.svg(),
                    isSelected: state.tabIndex == 0,
                  );
                },
              ),
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (p, c) {
                  return isStartBuild(p, c, 1);
                },
                builder: (context, state) {
                  return buildTabButton(
                    state: state,
                    onPressed: () => changeTab(state, context, 1),
                    icon: Assets.lib.resources.images.biBarChartFill.svg(),
                    isSelected: state.tabIndex == 1,
                  );
                },
              ),
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (p, c) {
                  return isStartBuild(p, c, 2);
                },
                builder: (context, state) {
                  return buildTabButton(
                    state: state,
                    onPressed: () => changeTab(state, context, 2),
                    icon:
                        Assets.lib.resources.images.iconamoonProfileFill.svg(),
                    isSelected: state.tabIndex == 2,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isStartBuild(MainState p, MainState c, int index) {
    return ((p.tabIndex == index && c.tabIndex != index) ||
            (p.tabIndex != index && c.tabIndex == index)) ||
        ((p.homePageState == HomePageState.home &&
                c.homePageState != HomePageState.home) ||
            (p.homePageState != HomePageState.home &&
                c.homePageState == HomePageState.home));
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

  void changeTab(
    MainState state,
    BuildContext context,
    int tabIndex,
  ) {
    if (state.homePageState == HomePageState.home) {
      context.read<MainBloc>().add(
            TabChange(
              tabIndex: tabIndex,
            ),
          );
    }
  }
}
