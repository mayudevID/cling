import 'package:cling/core/init_database.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/core/reference_id.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/model/financial_planning_models.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/model/notification_model_class.dart';
import 'package:cling/features/model/wallet_model.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseRepository repository;
  late String databasePath;
  var sequence = 0;
  setUp(() async {
    repository = DatabaseRepository(
      userId:
          'regression_${DateTime.now().microsecondsSinceEpoch}_${sequence++}',
    );
    databasePath = await repository.databasePath;
    await repository.open();
  });

  tearDown(() async {
    await repository.close();
    await databaseFactory.deleteDatabase(databasePath);
  });

  test('editing a single transaction does not overwrite other rows', () async {
    final now = DateTime.now();
    for (final amount in [100.0, 200.0, 300.0]) {
      await repository.insertIncome(
        IncomeModel(
          date: now,
          amount: amount,
          desc: 'salary',
          incomeSource: '1 Fulltime Job',
        ),
      );
    }
    final before = await repository.getTransaction(now);
    expect(before.length, 3);
    final first = before.whereType<IncomeModel>().first;
    await repository.updateIncome(first.copyWith(amount: 450));
    final updated = (await repository.getTransaction(now))
        .whereType<IncomeModel>()
        .toList();
    expect(updated.length, 3);
    expect(
      updated.map((e) => e.amount).toList()..sort(),
      [200.0, 300.0, 450.0],
    );

    await repository.insertExpense(
      ExpenseModel(
        date: now,
        item: 'food',
        amount: 25,
        categories: '4 Food',
      ),
    );
    await repository.insertExpense(
      ExpenseModel(
        date: now,
        item: 'travel',
        amount: 10,
        categories: '9 Transport',
      ),
    );
    final expenses = (await repository.getTransaction(now))
        .whereType<ExpenseModel>()
        .toList();
    await repository.updateExpense(
      expenses
          .firstWhere((expense) => expense.item == 'food')
          .copyWith(amount: 15),
    );
    expect(
      (await repository.getTransaction(now)).whereType<ExpenseModel>().length,
      2,
    );
    // The canonical integer columns must update with the editable UI amounts.
    final incomeRows = await repository.db.query(IncomeMeta.nameTable);
    expect(
      incomeRows.map((e) => e[IncomeMeta.amountMinor]).toSet(),
      {45000, 20000, 30000},
    );
    final expenseRows = await repository.db.query(ExpenseMeta.nameTable);
    expect(
      expenseRows.map((e) => e[ExpenseMeta.amountMinor]).toSet(),
      {1500, 1000},
    );
    expect(await repository.getTotalBalance(), 925.0);
  });

  test('legacy source IDs decode from integers and numeric Strings', () {
    final date = DateTime(2026, 11, 7).toIso8601String();
    final income = IncomeModel.fromDatabase({
      IncomeMeta.id: 1,
      IncomeMeta.date: date,
      IncomeMeta.desc: 'legacy',
      IncomeMeta.amountMinor: 12345,
      IncomeMeta.idIncomeSource: '1',
    });
    expect(income.incomeSource, inSourceData[1]);
    expect(income.amount, 123.45);
    final expense = ExpenseModel.fromDatabase({
      ExpenseMeta.id: 3,
      ExpenseMeta.date: date,
      ExpenseMeta.item: 'legacy',
      ExpenseMeta.amountMinor: 2000,
      ExpenseMeta.idCategories: '4',
    });
    expect(expense.categories, exCategoriesData[4]);
    expect(expense.amount, 20);
    expect(parseReferenceId('7'), 7);
    expect(requireReferenceId(inSourceData[1], inSourceData), 1);
    expect(requireReferenceId(exCategoriesData[4], exCategoriesData), 4);
    expect(parseReferenceId('invalid'), isNull);
    expect(
      displayReference('900', inSourceData, unknownType: 'income source'),
      contains('Unknown income source'),
    );
    expect(
      () => requireReferenceId('invalid', inSourceData),
      throwsFormatException,
    );
  });

  test('foreign key constraints reject orphan transactions', () async {
    final config = await repository.db.rawQuery('PRAGMA foreign_keys');
    expect(config.first['foreign_keys'], 1);
    await expectLater(
      repository.db.insert(IncomeMeta.nameTable, {
        IncomeMeta.date: DateTime.now().toIso8601String(),
        IncomeMeta.amount: 100,
        IncomeMeta.amountMinor: 10000,
        IncomeMeta.idIncomeSource: 99999,
      }),
      throwsA(isA<Exception>()),
    );
    expect(await repository.db.rawQuery('PRAGMA foreign_key_check'), isEmpty);
  });

  test('missing breakdown category does not crash or return unrelated rows',
      () async {
    expect(
      await repository.getMostIncomeByCategory(
        source: 'not-present',
      ),
      isEmpty,
    );
    expect(
      await repository.getMostExpenseByCategory(
        source: 'not-present',
      ),
      isEmpty,
    );
  });

  test('goal contributions update the aggregate atomically', () async {
    await repository.insertGoal(
      GoalModel(name: 'Emergency', image: '📱', target: 100, collected: 0),
    );
    final goal = (await repository.getGoalsHome()).single;
    final today = DateTime.now();
    await repository.addSavingAtomic(goal.id!, today, 40);
    expect((await repository.getSingleGoalModel(goal.id!)).collected, 40);
    await expectLater(
      repository.addSavingAtomic(goal.id!, today, 70),
      throwsStateError,
    );
    expect((await repository.getGoalDetailSave(goal.id!)).length, 1);
    expect((await repository.getSingleGoalModel(goal.id!)).collected, 40);
    final saving = (await repository.getGoalDetailSave(goal.id!)).single;
    await repository.deleteSavingAtomic(goal.id!, saving.id!);
    expect((await repository.getSingleGoalModel(goal.id!)).collected, 0);
  });

  test('recurring income is idempotent across logins', () async {
    final day = DateTime.now().day;
    await repository.saveRecurringMonthly(
      recDay: day,
      type: 0,
      amount: 1100,
      isFromLogin: true,
    );
    await repository.saveRecurringMonthly(
      recDay: day,
      type: 0,
      amount: 1100,
      isFromLogin: true,
    );
    final rules = await repository.db.query(RecurringMeta.nameTable);
    expect(rules.length, 1);
    final incomes = await repository.db.query(IncomeMeta.nameTable);
    expect(incomes.length, 1);
    expect(incomes.single[IncomeMeta.amountMinor], 110000);
  });

  test('account switching isolates local finance records', () async {
    final primary = repository.databaseFileName;
    await repository.insertIncome(
      IncomeModel(
        date: DateTime.now(),
        amount: 55,
        desc: 'balance',
        incomeSource: '1 Job',
      ),
    );
    await repository.switchAccount('different_test_account_${sequence++}');
    final alternatePath = await repository.databasePath;
    expect(await repository.getTotalBalance(), 0);
    await repository.switchAccount(
      primary.substring(
        'cling_database_'.length,
        primary.length - '.db'.length,
      ),
    );
    expect(await repository.getTotalBalance(), 55);
    await databaseFactory.deleteDatabase(alternatePath);
  });

  test('schema v1 values migrate to canonical minor units', () async {
    await repository.close();
    await databaseFactory.deleteDatabase(databasePath);
    final legacy = await openDatabase(
      databasePath,
      version: 1,
      onCreate: initDatabaseTable,
    );
    await legacy.insert(IncomeMeta.nameTable, {
      IncomeMeta.date: DateTime.now().toIso8601String(),
      IncomeMeta.desc: 'legacy',
      IncomeMeta.amount: 12.34,
      IncomeMeta.idIncomeSource: 1,
    });
    await legacy.close();
    await repository.open();
    final rows = await repository.db.query(IncomeMeta.nameTable);
    expect(rows.single[IncomeMeta.amountMinor], 1234);
    expect(rows.single[IncomeMeta.walletId], 1);
    expect(await repository.getTotalBalance(), 12.34);
    expect((await repository.getWallets()).single.balanceMinor, 1234);
  });

  test(
      'wallet ledger includes opening balance and transfer without income/expense',
      () async {
    final cashId = await repository.getDefaultWalletId();
    final bankId = await repository.saveWallet(const WalletModel(
      name: 'BCA',
      type: 'bank',
      openingBalanceMinor: 200000,
      currency: 'IDR',
    ));
    await repository.insertExpense(ExpenseModel(
      date: DateTime.now(),
      item: 'Lunch',
      amount: 25,
      categories: exCategoriesData[4],
      walletId: bankId,
    ));
    final before = await repository.getTotalBalance();
    await repository.transfer(
        sourceWalletId: bankId,
        destinationWalletId: cashId,
        amountMinor: 5000,
        date: DateTime.now(),
        note: 'ATM');
    expect(await repository.getTotalBalance(), before);
    final wallets = await repository.getWallets();
    expect(wallets.firstWhere((w) => w.id == bankId).balanceMinor, 192500);
    expect(wallets.firstWhere((w) => w.id == cashId).balanceMinor, 5000);
    expect(
        (await repository.getTotalIncomeExpenseCurrMonth())['income'], isNull);
    expect((await repository.getTotalIncomeExpenseCurrMonth())['expense'], 25);
  });

  test('transfer rejects same wallet, nonpositive amount and archived wallet',
      () async {
    final id = await repository.getDefaultWalletId();
    await expectLater(
        repository.transfer(
            sourceWalletId: id,
            destinationWalletId: id,
            amountMinor: 10,
            date: DateTime.now()),
        throwsArgumentError);
    await expectLater(
        repository.transfer(
            sourceWalletId: id,
            destinationWalletId: id + 1,
            amountMinor: 0,
            date: DateTime.now()),
        throwsArgumentError);
    final other = await repository.saveWallet(const WalletModel(
      name: 'Bank',
      type: 'bank',
      openingBalanceMinor: 0,
      currency: 'IDR',
    ));
    await repository.archiveWallet(other);
    await expectLater(
        repository.transfer(
            sourceWalletId: id,
            destinationWalletId: other,
            amountMinor: 1,
            date: DateTime.now()),
        throwsStateError);
  });

  test('unpaid bill is not accounted until idempotent payment', () async {
    final walletId = await repository.getDefaultWalletId();
    final billId = await repository.saveBill(PlanningBillModel(
        title: 'Internet',
        amountMinor: 35000,
        categoryId: 0,
        walletId: walletId,
        dueDate: DateTime(2026, 11, 12),
        reminderMask: 7));
    expect(await repository.getTotalBalance(), 0);
    final firstExpense =
        await repository.payBill(billId, DateTime(2026, 11, 12));
    final secondExpense =
        await repository.payBill(billId, DateTime(2026, 11, 12));
    expect(secondExpense, firstExpense);
    expect((await repository.db.query(ExpenseMeta.nameTable)).length, 1);
    expect(await repository.getTotalBalance(), -350);
    expect(
        (await repository.getBills()).single.statusOn(DateTime(2026, 11, 12)),
        'paid');
  });

  test('deleting linked expense returns bill to unpaid without losing bill',
      () async {
    final walletId = await repository.getDefaultWalletId();
    final billId = await repository.saveBill(PlanningBillModel(
        title: 'Gym',
        amountMinor: 25000,
        categoryId: 0,
        walletId: walletId,
        dueDate: DateTime(2026, 11, 20)));
    await repository.insertExpense(ExpenseModel(
        date: DateTime(2026, 11, 20),
        item: 'Gym paid already',
        amount: 250,
        categories: exCategoriesData[0],
        walletId: walletId));
    final expenseId = (await repository.db.query(ExpenseMeta.nameTable))
        .single[ExpenseMeta.id] as int;
    await repository.linkBillExpense(billId, expenseId);
    expect((await repository.getBills()).single.expenseId, expenseId);
    await repository.deleteExpense(expenseId);
    final restored = (await repository.getBills()).single;
    expect(restored.expenseId, isNull);
    expect(restored.statusOn(DateTime(2026, 11, 20)), 'due_today');
    expect(await repository.getTotalBalance(), 0);
  });

  test(
      'automatic monthly expense reconciliation posts each missed occurrence once',
      () async {
    final walletId = await repository.getDefaultWalletId();
    await repository.saveRecurringExpenseRule(RecurringExpenseRuleModel(
        name: 'Rent',
        amountMinor: 12500,
        categoryId: 0,
        walletId: walletId,
        frequency: 'monthly',
        scheduledDay: 31,
        startDate: DateTime(2026, 1, 31),
        nextDate: DateTime(2026, 1, 31),
        postingMode: 'automatic'));
    await repository.reconcileFinancialPlanning(DateTime(2026, 3, 31));
    await repository.reconcileFinancialPlanning(DateTime(2026, 3, 31));
    final expenses = await repository.db.query(ExpenseMeta.nameTable);
    final occurrences =
        await repository.db.query(RecurringExpenseOccurrenceMeta.table);
    expect(expenses.length, 3);
    expect(occurrences.length, 3);
    expect(
        occurrences
            .map((row) => row[RecurringExpenseOccurrenceMeta.scheduledDate]),
        ['2026-01-31', '2026-02-28', '2026-03-31']);
    expect(await repository.getTotalBalance(), -375);
  });

  test('runway deducts bills and reserve but keeps expected income separate',
      () async {
    final walletId = await repository.getDefaultWalletId();
    await repository.saveWallet(const WalletModel(
      id: 1,
      name: 'Cash',
      type: 'cash',
      openingBalanceMinor: 300000000,
      currency: 'IDR',
      isDefault: true,
    ));
    await repository.db.insert(RecurringMeta.nameTable, {
      RecurringMeta.idModel: 0,
      RecurringMeta.type: 0,
      RecurringMeta.recurringDay: 31,
      RecurringMeta.recurringLast: '2026-04-30',
      RecurringMeta.amount: 2500000,
      RecurringMeta.amountMinor: 250000000,
    });
    await repository.saveBill(PlanningBillModel(
      title: 'Bills',
      amountMinor: 85000000,
      categoryId: 0,
      walletId: walletId,
      dueDate: DateTime(2026, 5, 24),
    ));
    await repository.setPlanningSettings(
        paydayDay: null, safetyReserveMinor: 50000000);
    final result = await repository.getPaydayRunway(DateTime(2026, 5, 20));
    expect(result, isNotNull);
    expect(result!.payday, DateTime(2026, 5, 31));
    expect(result.availableMinor, 300000000);
    expect(result.billsMinor, 85000000);
    expect(result.recurringMinor, 0);
    expect(result.reserveMinor, 50000000);
    expect(result.expectedIncomeMinor, 250000000);
    expect(result.daysRemaining, 11);
    expect(result.estimatedSpendableMinor, 165000000);
    expect(result.dailyAllowanceMinor, 15000000);
  });

  test('runway does not double count recurring rule linked to a bill',
      () async {
    final walletId = await repository.getDefaultWalletId();
    await repository.saveWallet(const WalletModel(
      id: 1,
      name: 'Cash',
      type: 'cash',
      openingBalanceMinor: 10000000,
      currency: 'IDR',
      isDefault: true,
    ));
    final ruleId =
        await repository.saveRecurringExpenseRule(RecurringExpenseRuleModel(
      name: 'Internet',
      amountMinor: 2000000,
      categoryId: 0,
      walletId: walletId,
      frequency: 'monthly',
      scheduledDay: 25,
      startDate: DateTime(2026, 5, 25),
      nextDate: DateTime(2026, 5, 25),
    ));
    await repository.saveBill(PlanningBillModel(
      title: 'Internet bill',
      amountMinor: 2000000,
      categoryId: 0,
      walletId: walletId,
      dueDate: DateTime(2026, 5, 25),
      recurringRuleId: ruleId,
    ));
    await repository.setPlanningSettings(paydayDay: 31, safetyReserveMinor: 0);
    final runway = await repository.getPaydayRunway(DateTime(2026, 5, 20));
    expect(runway!.billsMinor, 2000000);
    expect(runway.recurringMinor, 0);
    expect(runway.includedBills.single.name, 'Internet bill');
  });

  test('bill reminder appears once in local inbox for its due date', () async {
    final walletId = await repository.getDefaultWalletId();
    await repository.saveBill(PlanningBillModel(
      title: 'Rent',
      amountMinor: 100000,
      categoryId: 0,
      walletId: walletId,
      dueDate: DateTime(2026, 7, 10),
      reminderMask: 1,
    ));
    await repository.reconcileFinancialPlanning(DateTime(2026, 7, 7));
    await repository.reconcileFinancialPlanning(DateTime(2026, 7, 7));
    final notifications = await repository.db.query(
      NotificationMeta.nameTable,
      where: '${NotificationMeta.type}=?',
      whereArgs: [4],
    );
    expect(notifications.length, 1);
    expect(notifications.single[NotificationMeta.desc], 'Rent');
    final markers = await repository.db.query(PlanningReminderMeta.table);
    expect(markers.length, 1);
    expect(markers.single[PlanningReminderMeta.scheduledDate], '2026-07-10');
  });

  test('goals use stable keyset pagination for 0, 1, 12 and 25 items',
      () async {
    expect(await repository.getGoalsPage(), isEmpty);

    for (var i = 1; i <= 25; ++i) {
      await repository.insertGoal(
        GoalModel(
          name: 'Goal $i',
          image: '📱',
          target: 100,
          collected: 0,
        ),
      );
      if (i == 1) {
        expect((await repository.getGoalsPage()).single.name, 'Goal 1');
      }
    }
    final first = await repository.getGoalsPage();
    expect(first.length, 12);
    final second = await repository.getGoalsPage(beforeId: first.last.id);
    expect(second.length, 12);
    final last = await repository.getGoalsPage(beforeId: second.last.id);
    expect(last.length, 1);
    expect(last.single.name, 'Goal 1');
    expect((await repository.getGoalsPage(beforeId: last.single.id)), isEmpty);
    expect([...first, ...second, ...last].map((e) => e.id).toSet().length, 25);
  });

  test('notifications page correctly with equal timestamps', () async {
    final when = DateTime(2026, 11, 7, 7);
    expect(await repository.getNotificationsPage(), isEmpty);
    for (var i = 0; i < 25; ++i) {
      await repository.saveNotification(
        NotificationModelClass(
          title: 'Notification $i',
          desc: 'Message $i',
          date: when,
          type: 0,
          isRead: false,
        ),
      );
      if (i == 0) {
        expect((await repository.getNotificationsPage()).length, 1);
      }
    }
    final a = await repository.getNotificationsPage();
    final b = await repository.getNotificationsPage(
      beforeDate: a.last.date,
      beforeId: a.last.id,
    );
    final c = await repository.getNotificationsPage(
      beforeDate: b.last.date,
      beforeId: b.last.id,
    );
    expect([a.length, b.length, c.length], [12, 12, 1]);
    expect([...a, ...b, ...c].map((e) => e.id).toSet().length, 25);
    expect(
      await repository.getNotificationsPage(
        beforeDate: c.last.date,
        beforeId: c.last.id,
      ),
      isEmpty,
    );
  });

  test('warning notifications are inserted at most once per period', () async {
    final date = DateTime(2026, 11, 7);
    final first = await repository.saveWarningNotificationOnce(
      type: 0,
      title: 'Budget exceeded',
      description: 'Monthly warning',
      date: date,
    );
    final duplicate = await repository.saveWarningNotificationOnce(
      type: 0,
      title: 'Budget exceeded',
      description: 'Monthly warning',
      date: date.add(const Duration(days: 1)),
    );
    expect(first, isTrue);
    expect(duplicate, isFalse);
    expect((await repository.getNotificationsPage()).length, 1);
  });

  test('legacy recurring rows reserve paid months before processing', () async {
    final today = DateTime.now();
    await repository.insertIncome(
      IncomeModel(
        date: today,
        desc: 'Monthly Income (Recurring)',
        amount: 1800,
        incomeSource: '0 Other',
      ),
    );
    await repository.saveRecurringMonthly(
      recDay: today.day,
      type: 0,
      amount: 1800,
      isFromLogin: false,
    );
    await repository.close();
    await repository.open(); // Backfills the new occurrence ledger.
    final markers = await repository.db.query('recurring_occurrences');
    expect(markers.length, 1);
    await repository.checkAndInputRecurring();
    expect((await repository.db.query(IncomeMeta.nameTable)).length, 1);
  });

  test('new recurring rule does not repay a legacy salary in the same month',
      () async {
    final today = DateTime.now();
    await repository.insertIncome(
      IncomeModel(
        date: today,
        desc: 'Monthly Income (Recurring)',
        amount: 200,
        incomeSource: '0 Other',
      ),
    );
    await repository.syncMonthlyIncomeRule(
      recurringDay: today.day,
      amount: 200,
    );
    expect((await repository.db.query(IncomeMeta.nameTable)).length, 1);
    expect((await repository.db.query('recurring_occurrences')).length, 1);
  });

  test('opening the database never generates income before reconciliation',
      () async {
    final today = DateTime.now();
    await repository.saveRecurringMonthly(
      recDay: today.day,
      type: 0,
      amount: 999,
      isFromLogin: false,
    );
    await repository.close();
    await repository.open();
    expect((await repository.db.query(IncomeMeta.nameTable)), isEmpty);
    await repository.syncMonthlyIncomeRule(
      recurringDay: 0,
      amount: 0,
    );
    expect((await repository.db.query(IncomeMeta.nameTable)), isEmpty);
  });

  test('financial changes receive a durable modification timestamp', () async {
    expect(await repository.hasFinancialRecords(), false);
    expect(await repository.lastFinanceChangeAt(), isNull);
    await repository.insertIncome(
      IncomeModel(
        date: DateTime.now(),
        amount: 20,
        desc: 'purchase',
        incomeSource: '0 Other',
      ),
    );
    expect(await repository.hasFinancialRecords(), true);
    final modified = await repository.lastFinanceChangeAt();
    expect(modified, isNotNull);
    expect(modified!.isUtc, true);
  });

  test('recurring edits and disable do not duplicate a paid month', () async {
    final today = DateTime.now();
    await repository.syncMonthlyIncomeRule(
      recurringDay: today.day,
      amount: 1000,
    );
    expect((await repository.db.query(IncomeMeta.nameTable)).length, 1);
    await repository.syncMonthlyIncomeRule(recurringDay: 0, amount: 0);
    await repository.syncMonthlyIncomeRule(
      recurringDay: today.day,
      amount: 1800,
    );
    expect((await repository.db.query(IncomeMeta.nameTable)).length, 1);
    final rules = await repository.db.query(RecurringMeta.nameTable);
    expect(rules.length, 1);
    expect(rules.single[RecurringMeta.amountMinor], 180000);
  });
}
