part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class ClickLeft extends TransactionEvent {}

class ClickRight extends TransactionEvent {}

class GetData extends TransactionEvent {}
