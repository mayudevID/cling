import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stats_detail_event.dart';
part 'stats_detail_state.dart';

class StatsDetailBloc extends Bloc<StatsDetailEvent, StatsDetailState> {
  StatsDetailBloc() : super(StatsDetailInitial()) {
    on<StatsDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
