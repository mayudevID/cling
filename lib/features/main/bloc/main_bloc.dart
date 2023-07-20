import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainInitial(tabIndex: 0)) {
    on<MainEvent>(
      (event, emit) {
        if (event is TabChange) {
          if (kDebugMode) print("Tab Clicked: ${event.tabIndex}");
          emit(MainInitial(tabIndex: event.tabIndex));
        }
      },
    );
  }
}
