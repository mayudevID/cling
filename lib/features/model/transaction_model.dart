// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

abstract class TransactionModel extends Equatable {
  TransactionType getType();
  late DateTime date;
  late int? id;
  late double amount;
}
