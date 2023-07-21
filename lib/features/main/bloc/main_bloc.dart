import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'enum_home_page_state.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(
          const MainState(tabIndex: 0, homePageState: HomePageState.home),
        ) {
    on<TabChange>(tabChange);
    on<HomePageStateChange>(homePageStateChange);
  }

  void tabChange(event, emit) {
    if (kDebugMode) print("Tab Clicked: ${event.tabIndex}");
    emit(
      state.copyWith(
        tabIndex: event.tabIndex,
        homePageState:
            (event.tabIndex == 0) ? HomePageState.home : state.homePageState,
      ),
    );
  }

  void homePageStateChange(event, emit) {
    if (kDebugMode) print("HomePageState Clicked: ${event.homePageState}");
    emit(
      state.copyWith(
        homePageState:
            (state.tabIndex == 0) ? event.homePageState : state.homePageState,
      ),
    );
  }
}
