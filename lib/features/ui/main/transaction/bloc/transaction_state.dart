// ignore_for_file: must_be_immutable

part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  DateTime date;
  List<TransactionModel> listTransaction;

  TransactionState({
    DateTime? date,
    List<TransactionModel>? listTransaction,
  })  : date = date ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              1,
            ),
        listTransaction = listTransaction ?? List.empty();

  @override
  List<Object> get props => [
        date,
        listTransaction,
      ];

  TransactionState copyWith({
    DateTime? date,
    List<TransactionModel>? listTransaction,
  }) {
    return TransactionState(
      date: date ?? this.date,
      listTransaction: listTransaction ?? this.listTransaction,
    );
  }
}
