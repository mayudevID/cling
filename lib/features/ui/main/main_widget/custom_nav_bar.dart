import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/gen/assets.gen.dart';
import '../main_bloc/main_bloc.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Material(
        color: const Color(0xFF343437),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (p, c) {
                    return isStartBuild(p, c, 0);
                  },
                  builder: (context, state) {
                    return buildTabButton(
                      state: state,
                      onPressed: () => changeTab(state, context, 0),
                      icon:
                          Assets.lib.resources.images.fluentHome48Filled.svg(),
                      isSelected: state.tabIndex == 0,
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (p, c) {
                    return isStartBuild(p, c, 1);
                  },
                  builder: (context, state) {
                    return buildTabButton(
                      state: state,
                      onPressed: () => changeTab(state, context, 1),
                      icon: Assets.lib.resources.images.transaction.svg(),
                      isSelected: state.tabIndex == 1,
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (p, c) {
                    return isStartBuild(p, c, 2);
                  },
                  builder: (context, state) {
                    return buildTabButton(
                      state: state,
                      onPressed: () => changeTab(state, context, 2),
                      icon: Assets.lib.resources.images.biBarChartFill.svg(),
                      isSelected: state.tabIndex == 2,
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (p, c) {
                    return isStartBuild(p, c, 3);
                  },
                  builder: (context, state) {
                    return buildTabButton(
                      state: state,
                      onPressed: () => changeTab(state, context, 3),
                      icon: Assets.lib.resources.images.iconamoonProfileFill
                          .svg(),
                      isSelected: state.tabIndex == 3,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isStartBuild(MainState p, MainState c, int index) {
    return ((p.tabIndex == index && c.tabIndex != index) ||
        (p.tabIndex != index && c.tabIndex == index));
  }

  Widget buildTabButton({
    required MainState state,
    required VoidCallback onPressed,
    required Widget icon,
    required bool isSelected,
  }) {
    return SizedBox(
      height: double.infinity,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Opacity(
            opacity: isSelected ? 1.0 : 0.45,
            child: SizedBox.square(
              dimension: 24,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  void changeTab(
    MainState state,
    BuildContext context,
    int tabIndex,
  ) {
    context.read<MainBloc>().add(TabChange(tabIndex: tabIndex));
  }
}
