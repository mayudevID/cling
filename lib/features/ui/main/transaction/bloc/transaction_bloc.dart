import 'package:bloc/bloc.dart';
import 'package:cling/core/debouncer.dart';
import 'package:cling/features/model/transaction_model.dart';
import 'package:equatable/equatable.dart';
import '../../../../repository/database_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({required DatabaseRepository dbRepo})
      : _dbRepo = dbRepo,
        super(TransactionState()) {
    on<ClickLeft>(_clickLeft);
    on<ClickRight>(_clickRight);
    on<GetData>(_getData);
  }

  final DatabaseRepository _dbRepo;
  final _debouncer = Debouncer(milliseconds: 750);

  void _clickLeft(event, emit) {
    emit(
      state.copyWith(
        date: DateTime(state.date.year, state.date.month - 1),
      ),
    );

    add(GetData());
  }

  void _clickRight(event, emit) {
    emit(
      state.copyWith(
        date: DateTime(state.date.year, state.date.month + 1),
      ),
    );

    add(GetData());
  }

  void _getData(event, emit) async {
    final result = await _dbRepo.getTransaction(state.date);

    if (result.isNotEmpty) {
      result.sort((a, b) => b.date.compareTo(a.date));
      emit(state.copyWith(listTransaction: result));
    } else {
      emit(state.copyWith(listTransaction: List.empty()));
    }
  }
}
