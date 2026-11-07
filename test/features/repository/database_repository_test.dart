import 'package:cling/core/init_database.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/goal_model.dart';
import 'package:cling/features/model/income_model.dart';
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
        updated.map((e) => e.amount).toList()..sort(), [200.0, 300.0, 450.0]);

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
    await repository.updateExpense(expenses.first.copyWith(amount: 15));
    expect(
        (await repository.getTransaction(now)).whereType<ExpenseModel>().length,
        2);
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
    expect(await repository.getTotalBalance(), 12.34);
  });
}
