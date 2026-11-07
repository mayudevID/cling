import 'dart:async';

import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/model/transaction_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cling/features/ui/main/transaction/bloc/transaction_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class DeferredTransactionRepository extends DatabaseRepository {
  DeferredTransactionRepository() : super();

  final Map<String, Completer<List<TransactionModel>>> requests = {};

  String key(DateTime date) => '${date.year}-${date.month}';

  @override
  Future<List<TransactionModel>> getTransaction(DateTime date) {
    return requests
        .putIfAbsent(key(date), () => Completer<List<TransactionModel>>())
        .future;
  }

  void finish(DateTime date, double amount) {
    requests[key(date)]!.complete([
      IncomeModel(
        date: date,
        amount: amount,
        incomeSource: '1 Fulltime Job',
      ),
    ]);
  }
}

void main() {
  test('discard outdated month results when user quickly navigates', () async {
    final repo = DeferredTransactionRepository();
    final bloc = TransactionBloc(dbRepo: repo);
    final initial = bloc.state.date;
    final next = DateTime(initial.year, initial.month + 1);

    bloc.add(GetData());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    bloc.add(ClickRight());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    repo.finish(initial, 100);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.date, next);
    expect(bloc.state.listTransaction, isEmpty);

    repo.finish(next, 200);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.listTransaction.single.amount, 200);
    await bloc.close();
  });
}
