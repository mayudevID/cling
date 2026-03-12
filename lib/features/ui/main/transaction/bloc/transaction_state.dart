// ignore_for_file: must_be_immutable

part of 'transaction_bloc.dart';

class TransactionState extends Equatable {

  TransactionState({
    DateTime? date,
    List<TransactionModel>? listTransaction,
  })  : date = date ?? DateTime(DateTime.now().year, DateTime.now().month),
        listTransaction = listTransaction ?? List.empty();
  DateTime date;
  List<TransactionModel> listTransaction;

  @override
  List<Object> get props => [date, listTransaction];

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
