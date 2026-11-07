import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../model/transaction_model.dart';
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
  int _requestSequence = 0;

  void _clickLeft(ClickLeft event, Emitter<TransactionState> emit) {
    emit(
      state.copyWith(date: DateTime(state.date.year, state.date.month - 1)),
    );

    add(GetData());
  }

  void _clickRight(ClickRight event, Emitter<TransactionState> emit) {
    emit(
      state.copyWith(date: DateTime(state.date.year, state.date.month + 1)),
    );

    add(GetData());
  }

  Future<void> _getData(GetData event, Emitter<TransactionState> emit) async {
    final requestedDate = state.date;
    final request = ++_requestSequence;
    final revision = _dbRepo.revision;
    final result = await _dbRepo.getTransaction(requestedDate);
    if (isClosed ||
        request != _requestSequence ||
        revision != _dbRepo.revision ||
        state.date.year != requestedDate.year ||
        state.date.month != requestedDate.month) {
      return;
    }
    result.sort((a, b) => b.date.compareTo(a.date));
    emit(state.copyWith(listTransaction: result));
  }
}
