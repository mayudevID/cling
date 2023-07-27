import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc()
      : super(
          StatisticsState(typeCategories: 0),
        ) {
    on<TypeCategoriesEvent>(typeCategories);
  }

  void typeCategories(
    TypeCategoriesEvent event,
    Emitter<StatisticsState> emit,
  ) {
    emit(
      state.copyWith(
        typeCategories: event.type,
      ),
    );
  }
}
