import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/expense_categories_model.dart';
import '../../../model/financial_planning_models.dart';
import '../../../model/wallet_model.dart';
import '../../../repository/database_repository.dart';

sealed class PlanningEvent extends Equatable {
  const PlanningEvent();
  @override
  List<Object?> get props => [];
}

class LoadPlanning extends PlanningEvent {
  const LoadPlanning(this.asOf);
  final DateTime asOf;
  @override
  List<Object?> get props => [asOf];
}

class SaveRecurringRule extends PlanningEvent {
  const SaveRecurringRule(this.rule);
  final RecurringExpenseRuleModel rule;
  @override
  List<Object?> get props =>
      [rule.id, rule.name, rule.amountMinor, rule.frequency, rule.scheduledDay];
}

class ToggleRecurringRule extends PlanningEvent {
  const ToggleRecurringRule(this.id, this.enabled);
  final int id;
  final bool enabled;
  @override
  List<Object?> get props => [id, enabled];
}

class RemoveRecurringRule extends PlanningEvent {
  const RemoveRecurringRule(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class SavePlanningBill extends PlanningEvent {
  const SavePlanningBill(this.bill);
  final PlanningBillModel bill;
  @override
  List<Object?> get props =>
      [bill.id, bill.title, bill.amountMinor, bill.dueDate];
}

class PayPlanningBill extends PlanningEvent {
  const PayPlanningBill(this.id, this.paidAt);
  final int id;
  final DateTime paidAt;
  @override
  List<Object?> get props => [id, paidAt];
}

class CancelPlanningBill extends PlanningEvent {
  const CancelPlanningBill(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class PayOccurrence extends PlanningEvent {
  const PayOccurrence(this.id, this.paidAt);
  final int id;
  final DateTime paidAt;
  @override
  List<Object?> get props => [id, paidAt];
}

class SkipOccurrence extends PlanningEvent {
  const SkipOccurrence(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class SavePlanningPreferences extends PlanningEvent {
  const SavePlanningPreferences(this.paydayDay, this.reserveMinor);
  final int? paydayDay;
  final int reserveMinor;
  @override
  List<Object?> get props => [paydayDay, reserveMinor];
}

class PlanningState extends Equatable {
  const PlanningState({
    this.isLoading = true,
    this.error,
    this.bills = const [],
    this.rules = const [],
    this.occurrences = const [],
    this.categories = const [],
    this.wallets = const [],
    this.runway,
    this.configuredPaydayDay,
    this.safetyReserveMinor = 0,
    this.financialMutationId = 0,
  });
  final bool isLoading;
  final String? error;
  final List<PlanningBillModel> bills;
  final List<RecurringExpenseRuleModel> rules;
  final List<Map<String, Object?>> occurrences;
  final List<ExpenseCategoriesModel> categories;
  final List<WalletModel> wallets;
  final PaydayRunwayModel? runway;
  final int? configuredPaydayDay;
  final int safetyReserveMinor;
  final int financialMutationId;

  PlanningState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<PlanningBillModel>? bills,
    List<RecurringExpenseRuleModel>? rules,
    List<Map<String, Object?>>? occurrences,
    List<ExpenseCategoriesModel>? categories,
    List<WalletModel>? wallets,
    PaydayRunwayModel? runway,
    bool clearRunway = false,
    int? configuredPaydayDay,
    int? safetyReserveMinor,
    int? financialMutationId,
  }) =>
      PlanningState(
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        bills: bills ?? this.bills,
        rules: rules ?? this.rules,
        occurrences: occurrences ?? this.occurrences,
        categories: categories ?? this.categories,
        wallets: wallets ?? this.wallets,
        runway: clearRunway ? null : runway ?? this.runway,
        configuredPaydayDay: configuredPaydayDay ?? this.configuredPaydayDay,
        safetyReserveMinor: safetyReserveMinor ?? this.safetyReserveMinor,
        financialMutationId: financialMutationId ?? this.financialMutationId,
      );

  @override
  List<Object?> get props => [
        isLoading,
        error,
        bills,
        rules,
        occurrences,
        categories,
        wallets,
        runway,
        configuredPaydayDay,
        safetyReserveMinor,
        financialMutationId,
      ];
}

class PlanningBloc extends Bloc<PlanningEvent, PlanningState> {
  PlanningBloc(this._repository) : super(const PlanningState()) {
    on<LoadPlanning>(_load);
    on<SaveRecurringRule>((event, emit) async {
      await _mutate(
          () => _repository.saveRecurringExpenseRule(event.rule), emit);
    });
    on<ToggleRecurringRule>((event, emit) async {
      await _mutate(
          () => _repository.setRecurringExpenseEnabled(event.id, event.enabled),
          emit);
    });
    on<RemoveRecurringRule>((event, emit) async {
      await _mutate(
          () => _repository.deleteRecurringExpenseRule(event.id), emit);
    });
    on<SavePlanningBill>((event, emit) async {
      await _mutate(() => _repository.saveBill(event.bill), emit);
    });
    on<PayPlanningBill>((event, emit) async {
      await _mutate(() => _repository.payBill(event.id, event.paidAt), emit);
    });
    on<CancelPlanningBill>((event, emit) async {
      await _mutate(() => _repository.cancelBill(event.id), emit);
    });
    on<PayOccurrence>((event, emit) async {
      await _mutate(
          () =>
              _repository.payRecurringExpenseOccurrence(event.id, event.paidAt),
          emit);
    });
    on<SkipOccurrence>((event, emit) async {
      await _mutate(
          () => _repository.skipRecurringExpenseOccurrence(event.id), emit);
    });
    on<SavePlanningPreferences>((event, emit) async {
      await _mutate(
          () => _repository.setPlanningSettings(
              paydayDay: event.paydayDay,
              safetyReserveMinor: event.reserveMinor),
          emit);
    });
  }

  final DatabaseRepository _repository;
  int _loadGeneration = 0;
  int _financialMutationId = 0;

  Future<void> _mutate(
      Future<dynamic> Function() operation, Emitter<PlanningState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await operation();
      if (!isClosed) {
        await _refresh(DateTime.now(), emit,
            financialMutationId: ++_financialMutationId);
      }
    } catch (error) {
      if (!isClosed)
        emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> _load(
    LoadPlanning event,
    Emitter<PlanningState> emit,
  ) =>
      _refresh(event.asOf, emit);

  Future<void> _refresh(DateTime asOf, Emitter<PlanningState> emit,
      {int? financialMutationId}) async {
    final generation = ++_loadGeneration;
    final revision = _repository.revision;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.reconcileFinancialPlanning(asOf);
      final results = await Future.wait<Object?>([
        _repository.getBills(),
        _repository.getRecurringExpenseRules(),
        _repository.getRecurringExpenseOccurrences(unpaidOnly: true),
        _repository.getExpenseCategories(),
        _repository.getWallets(),
        _repository.getPaydayRunway(asOf),
        _repository.getPlanningSettings(),
      ]);
      if (isClosed ||
          revision != _repository.revision ||
          generation != _loadGeneration) return;
      emit(PlanningState(
        isLoading: false,
        bills: results[0] as List<PlanningBillModel>,
        rules: results[1] as List<RecurringExpenseRuleModel>,
        occurrences: results[2] as List<Map<String, Object?>>,
        categories: results[3] as List<ExpenseCategoriesModel>,
        wallets: results[4] as List<WalletModel>,
        runway: results[5] as PaydayRunwayModel?,
        configuredPaydayDay: (results[6] as Map<String, int?>)['paydayDay'],
        safetyReserveMinor:
            (results[6] as Map<String, int?>)['safetyReserveMinor'] ?? 0,
        financialMutationId: financialMutationId ?? state.financialMutationId,
      ));
    } catch (error) {
      if (!isClosed &&
          revision == _repository.revision &&
          generation == _loadGeneration) {
        emit(state.copyWith(isLoading: false, error: error.toString()));
      }
    }
  }
}
