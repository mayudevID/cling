import 'package:cling/core/logger.dart';
import 'package:cling/features/ui/main/home/bloc/home_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'enum_home_page_state.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(
          MainState(tabIndex: 0, homePageState: HomePageState.home),
        ) {
    on<TabChange>(_tabChange);
    on<HomePageStateChange>(_homePageStateChange);
  }

  void _tabChange(TabChange event, emit) {
    final lastHomePageState = state.homePageState;
    emit(
      state.copyWith(
        tabIndex: event.tabIndex,
        homePageState:
            (event.tabIndex == 0) ? HomePageState.home : state.homePageState,
      ),
    );
    Logger.Yellow.log("Tab Clicked: ${event.tabIndex}");

    if (lastHomePageState != HomePageState.home) {
      event.context.read<HomeBloc>().add(ClearListDropdown());
    }
  }

  void _homePageStateChange(HomePageStateChange event, emit) async {
    emit(
      state.copyWith(
        homePageState:
            (state.tabIndex == 0) ? event.homePageState : state.homePageState,
      ),
    );
    Logger.Yellow.log("HomePageState Clicked: ${event.homePageState}");
  }
}
