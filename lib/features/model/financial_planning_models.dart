import '../../core/static_name_table.dart';

class RecurringExpenseRuleModel {
  factory RecurringExpenseRuleModel.fromMap(Map<String, Object?> row) =>
      RecurringExpenseRuleModel(
        id: row[RecurringExpenseMeta.id] as int,
        name: row[RecurringExpenseMeta.name] as String,
        description: row[RecurringExpenseMeta.description] as String?,
        amountMinor: row[RecurringExpenseMeta.amount] as int,
        categoryId: row[RecurringExpenseMeta.categoryId] as int,
        walletId: row[RecurringExpenseMeta.walletId] as int,
        frequency: row[RecurringExpenseMeta.frequency] as String,
        scheduledDay: row[RecurringExpenseMeta.scheduledDay] as int,
        startDate:
            DateTime.parse(row[RecurringExpenseMeta.startDate] as String),
        endDate: row[RecurringExpenseMeta.endDate] == null
            ? null
            : DateTime.parse(row[RecurringExpenseMeta.endDate] as String),
        nextDate: DateTime.parse(row[RecurringExpenseMeta.nextDate] as String),
        enabled: row[RecurringExpenseMeta.enabled] == 1,
        postingMode: row[RecurringExpenseMeta.postingMode] as String,
      );
  const RecurringExpenseRuleModel({
    this.id,
    required this.name,
    this.description,
    required this.amountMinor,
    required this.categoryId,
    required this.walletId,
    required this.frequency,
    required this.scheduledDay,
    required this.startDate,
    this.endDate,
    required this.nextDate,
    this.enabled = true,
    this.postingMode = 'manual',
  });

  final int? id;
  final String name;
  final String? description;
  final int amountMinor;
  final int categoryId;
  final int walletId;
  final String frequency;
  final int scheduledDay;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime nextDate;
  final bool enabled;
  final String postingMode;
}

class PlanningBillModel {
  factory PlanningBillModel.fromMap(Map<String, Object?> row) =>
      PlanningBillModel(
        id: row[BillMeta.id] as int,
        title: row[BillMeta.title] as String,
        amountMinor: row[BillMeta.amount] as int,
        categoryId: row[BillMeta.categoryId] as int,
        walletId: row[BillMeta.walletId] as int,
        dueDate: DateTime.parse(row[BillMeta.dueDate] as String),
        reminderMask: row[BillMeta.reminderMask] as int,
        note: row[BillMeta.note] as String?,
        recurringRuleId: row[BillMeta.recurringRuleId] as int?,
        expenseId: row[BillMeta.expenseId] as int?,
        isCancelled: row[BillMeta.isCancelled] == 1,
      );
  const PlanningBillModel({
    this.id,
    required this.title,
    required this.amountMinor,
    required this.categoryId,
    required this.walletId,
    required this.dueDate,
    this.reminderMask = 7,
    this.note,
    this.recurringRuleId,
    this.expenseId,
    this.isCancelled = false,
  });

  final int? id;
  final String title;
  final int amountMinor;
  final int categoryId;
  final int walletId;
  final DateTime dueDate;
  final int reminderMask;
  final String? note;
  final int? recurringRuleId;
  final int? expenseId;
  final bool isCancelled;

  String statusOn(DateTime today) {
    if (isCancelled) return 'cancelled';
    if (expenseId != null) return 'paid';
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final now = DateTime(today.year, today.month, today.day);
    if (due.isBefore(now)) return 'overdue';
    if (due == now) return 'due_today';
    return 'upcoming';
  }
}

class PaydayRunwayModel {
  const PaydayRunwayModel({
    required this.payday,
    required this.daysRemaining,
    required this.currency,
    required this.availableMinor,
    required this.billsMinor,
    required this.recurringMinor,
    required this.reserveMinor,
    required this.expectedIncomeMinor,
    required this.excludedWalletNames,
    required this.includedBills,
    required this.includedRecurringDetails,
  });

  final DateTime payday;
  final int daysRemaining;
  final String currency;
  final int availableMinor;
  final int billsMinor;
  final int recurringMinor;
  final int reserveMinor;
  final int expectedIncomeMinor;
  final List<String> excludedWalletNames;
  final List<RunwayObligation> includedBills;
  final List<RunwayObligation> includedRecurringDetails;

  int get estimatedSpendableMinor =>
      availableMinor - billsMinor - recurringMinor - reserveMinor;
  int get dailyAllowanceMinor =>
      daysRemaining > 0 && estimatedSpendableMinor > 0
          ? estimatedSpendableMinor ~/ daysRemaining
          : 0;
}

class RunwayObligation {
  const RunwayObligation({
    required this.name,
    required this.date,
    required this.amountMinor,
  });
  final String name;
  final DateTime date;
  final int amountMinor;
}
