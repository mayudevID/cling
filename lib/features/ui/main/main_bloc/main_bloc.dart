import '../../../../core/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(
          MainState(tabIndex: 0),
        ) {
    on<TabChange>(_tabChange);
  }

  void _tabChange(TabChange event, emit) {
    emit(
      state.copyWith(tabIndex: event.tabIndex),
    );
    Logger.Yellow.log("Tab Clicked: ${event.tabIndex}");
  }
}
