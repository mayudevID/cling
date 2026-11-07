import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/financial_intelligence.dart';
import '../../../repository/database_repository.dart';

sealed class FinancialInsightsEvent extends Equatable {
  const FinancialInsightsEvent();
  @override
  List<Object?> get props => [];
}

class LoadFinancialInsights extends FinancialInsightsEvent {
  const LoadFinancialInsights({required this.now, required this.budgetMinor});
  final DateTime now;
  final int? budgetMinor;
  @override
  List<Object?> get props => [now, budgetMinor];
}

class FinancialInsightsState extends Equatable {
  const FinancialInsightsState({
    this.isLoading = true,
    this.error,
    this.currencyMismatch = false,
    this.currency = 'IDR',
    this.insights = const [],
  });
  final bool isLoading;
  final String? error;
  final bool currencyMismatch;
  final String currency;
  final List<FinancialInsight> insights;
  @override
  List<Object?> get props =>
      [isLoading, error, currencyMismatch, currency, insights];
}

class FinancialInsightsBloc
    extends Bloc<FinancialInsightsEvent, FinancialInsightsState> {
  FinancialInsightsBloc(this._repository)
      : super(const FinancialInsightsState()) {
    on<LoadFinancialInsights>(_load);
  }
  final DatabaseRepository _repository;
  int _generation = 0;

  Future<void> _load(
    LoadFinancialInsights event,
    Emitter<FinancialInsightsState> emit,
  ) async {
    final generation = ++_generation;
    final revision = _repository.revision;
    emit(const FinancialInsightsState());
    try {
      final input = await _repository.getFinancialInsightInput(
        now: event.now,
        monthlyBudgetMinor: event.budgetMinor,
      );
      if (isClosed ||
          revision != _repository.revision ||
          generation != _generation) return;
      emit(FinancialInsightsState(
        isLoading: false,
        currency: input.currency,
        insights: generateFinancialInsights(input),
      ));
    } catch (error) {
      if (!isClosed &&
          revision == _repository.revision &&
          generation == _generation) {
        emit(FinancialInsightsState(
          isLoading: false,
          error: error.toString(),
          currencyMismatch: error is FinancialInsightCurrencyException,
        ));
      }
    }
  }
}
