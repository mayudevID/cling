// ignore_for_file: must_be_immutable

part of 'verification_onboard_bloc.dart';

sealed class VerificationOnboardEvent extends Equatable {
  const VerificationOnboardEvent();

  @override
  List<Object> get props => [];
}

class SetIncome extends VerificationOnboardEvent {
  SetIncome(this.income);

  String income;
}

class SetSpent extends VerificationOnboardEvent {
  SetSpent(this.spent);

  String spent;
}
