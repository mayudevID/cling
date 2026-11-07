import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../../core/init_database.dart';
import '../../core/money_amount.dart';
import '../../core/recurring_schedule.dart';
import '../../core/logger.dart';
import '../../core/static_name_table.dart';
import '../model/expense_categories_model.dart';
import '../model/expense_model.dart';
import '../model/goal_model.dart';
import '../model/goal_saving_model.dart';
import '../model/income_model.dart';
import '../model/income_source_model.dart';
import '../model/notification_model_class.dart';
import '../model/transaction_model.dart';
import '../ui/main/statistics/bloc/statistics_bloc.dart';

class DatabaseRepository {
  DatabaseRepository({String? userId}) : _userId = userId;

  // Each Firebase identity gets its own database. Unauthenticated sessions
  // never see the data of the previously signed-in account.
  String? _userId;
  Database? _database;
  static const databaseName = 'cling_database.db';
  Database get db => _database ?? (throw StateError('Database has not opened'));
  String get databaseFileName =>
      _userId == null ? 'cling_guest.db' : 'cling_database_${_userId!}.db';
  Future<String> get databasePath async =>
      join(await getDatabasesPath(), databaseFileName);

  Future<void> open({bool recoverRollback = true}) async {
    if (_database != null) return;
    final path = await databasePath;
    final rollback = File('$path.rollback');
    if (recoverRollback && await rollback.exists()) {
      // Restore was interrupted before it could commit successfully.
      final current = File(path);
      if (await current.exists()) await current.delete();
      await rollback.rename(path);
    }
    // A pre-upgrade database belongs to the cached, authenticated user only.
    // Never infer ownership of the legacy file during a new login.
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (database, version) async {
        await initDatabaseTable(database, version);
        await migrateMoneyColumns(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) await migrateMoneyColumns(database);
      },
    );
    await db.execute('''CREATE TABLE IF NOT EXISTS recurring_occurrences (
      rule_id INTEGER NOT NULL,
      period TEXT NOT NULL,
      PRIMARY KEY (rule_id, period)
    )''');
    // Older versions inserted one equivalent rule on every login.
    await db.transaction((txn) async {
      final rules = await txn.query(
        RecurringMeta.nameTable,
        orderBy: '${RecurringMeta.id} ASC',
      );
      final seen = <String>{};
      for (final rule in rules) {
        final key =
            '${rule[RecurringMeta.type]}:${rule[RecurringMeta.idModel]}';
        if (!seen.add(key)) {
          await txn.delete(
            RecurringMeta.nameTable,
            where: '${RecurringMeta.id} = ?',
            whereArgs: [rule[RecurringMeta.id]],
          );
        }
      }
    });
    await checkAndInputRecurring();
  }

  Future<void> close() async {
    final current = _database;
    _database = null;
    if (current != null) await current.close();
  }

  Future<void> switchAccount(String? uid) async {
    if (_userId == uid && _database != null) return;
    await close();
    _userId = uid;
    await open();
  }

  /// Legacy database is copied only for the already authenticated owner,
  /// not for arbitrary users logging in on the same device. Do not delete the
  /// original file; it remains a fallback for older installations.
  Future<void> migrateLegacyForAuthenticatedUser() async {
    if (_userId == null) return;
    final dir = await getDatabasesPath();
    final legacy = File(join(dir, databaseName));
    final target = File(await databasePath);
    if (!await legacy.exists() || await target.exists()) return;
    await close();
    // VACUUM INTO includes committed WAL changes in a standalone snapshot.
    final source = await openDatabase(legacy.path);
    var snapshotCreated = false;
    try {
      try {
        await source
            .execute("VACUUM INTO '${target.path.replaceAll("'", "''")}'");
        snapshotCreated = true;
      } on DatabaseException {
        // Older Android SQLite versions do not support VACUUM INTO.
        // Flush any WAL before copying a database that is no longer open.
        if (await target.exists()) await target.delete();
        final result = await source.rawQuery('PRAGMA wal_checkpoint(TRUNCATE)');
        if (result.isNotEmpty && result.first['busy'] == 1) {
          throw StateError('Legacy WAL is busy; refusing unsafe migration');
        }
      }
    } finally {
      await source.close();
    }
    if (!snapshotCreated) await legacy.copy(target.path);
    await open();
  }

  /// Creates a self-consistent SQLite snapshot while the live database is
  /// open. SQLite VACUUM INTO takes care of the active journal/WAL.
  Future<File> createBackupSnapshot(String outputPath) async {
    final target = File(outputPath);
    if (await target.exists()) await target.delete();
    await db.execute("VACUUM INTO '${outputPath.replaceAll("'", "''")}'");
    return target;
  }

  Future<Map<String, double?>> getTotalIncomeExpenseCurrMonth() async {
    final monthNow = DateTime.now();
    final monthNowFirstDay = DateTime(
      monthNow.year,
      monthNow.month,
    ).toIso8601String();

    final monthNowLastDay = monthNow.toIso8601String();

    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month,
        (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome
        FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Month
      ''',
        [monthNowFirstDay, monthNowLastDay],
      ),
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${ExpenseMeta.date}) AS Month,
        (SUM(${ExpenseMeta.amountMinor}) / 100.0) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
        GROUP BY Month
      ''',
        [monthNowFirstDay, monthNowLastDay],
      ),
    ]);

    //* Empty: []
    //* Non Empty: [{....}]

    double? incomeParse;
    double? expenseParse;

    if (result[0].isNotEmpty) {
      final income = result[0][0]['TotalIncome'];
      incomeParse = double.parse(income.toString());
    }

    if (result[1].isNotEmpty) {
      final expense = result[1][0]['TotalExpense'] ?? 0.0;
      expenseParse = double.parse(expense.toString());
    }

    return {"income": incomeParse, "expense": expenseParse};
  }

  Future<double> getTotalBalance() async {
    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome
        FROM ${IncomeMeta.nameTable}
      ''',
      ),
      db.rawQuery(
        '''
        SELECT (SUM(${ExpenseMeta.amountMinor}) / 100.0) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
      ''',
      ),
    ]);

    final Object? totInc = result[0][0]['TotalIncome'];
    final Object? totEx = result[1][0]['TotalExpense'];

    final income = totInc != null
        ? (totInc is int ? totInc.toDouble() : totInc as double)
        : 0.0;

    final expense = totEx != null
        ? (totEx is int ? totEx.toDouble() : totEx as double)
        : 0.0;

    return income - expense;
  }

  Future<Map<String, Map<String, dynamic>>?>
      getTotalIncomeExpenseAllMonth() async {
    final now = DateTime.now();

    final monthNowFormatted = DateTime(now.year, 12, 31).toIso8601String();
    final fourMonthsAgoFormatted = DateTime(now.year).toIso8601String();

    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month, 
        (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome 
        FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Month 
        ORDER BY Month
      ''',
        [fourMonthsAgoFormatted, monthNowFormatted],
      ),
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${ExpenseMeta.date}) AS Month, 
        (SUM(${ExpenseMeta.amountMinor}) / 100.0) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
        GROUP BY Month 
        ORDER BY Month
      ''',
        [fourMonthsAgoFormatted, monthNowFormatted],
      ),
    ]);

    final Map<String, Map<String, dynamic>> combinedData = {};

    if (result[0].isNotEmpty) {
      for (final income in result[0]) {
        final month = income["Month"] as String;
        combinedData[month] ??= {"TotalIncome": 0.0, "TotalExpense": 0.0};
        combinedData[month]!["TotalIncome"] = income["TotalIncome"];
      }
    }

    if (result[1].isNotEmpty) {
      for (final expense in result[1]) {
        final month = expense["Month"] as String;
        combinedData[month] ??= {"TotalIncome": 0.0, "TotalExpense": 0.0};
        combinedData[month]!["TotalExpense"] = expense["TotalExpense"];
      }
    }

    return (combinedData.isEmpty) ? null : combinedData;
  }

  Future<List<Map<String, Object?>>> getMost(
    AllStatsChoose allStatsChoose,
  ) async {
    final first = DateTime(DateTime.now().year).toIso8601String();
    final last = DateTime(DateTime.now().year, 12, 31).toIso8601String();
    List<Map<String, Object?>> result;
    switch (allStatsChoose) {
      case AllStatsChoose.expense:
        result = await db.rawQuery(
          '''
            SELECT ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.expenseCategories} AS Categories, 
            (SUM(${ExpenseMeta.amountMinor}) / 100.0) AS TotalExpense
            FROM ${ExpenseMeta.nameTable}
            INNER JOIN ${ExpenseCategoriesMeta.nameTable} 
            ON ${ExpenseMeta.nameTable}.${ExpenseMeta.idCategories} 
            = 
            ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.id} 
            WHERE date(${ExpenseMeta.date}) >= date(?)
            AND date(${ExpenseMeta.date}) <= date(?)
            GROUP BY Categories
            ORDER BY TotalExpense
            DESC LIMIT 7;
          ''',
          [first, last],
        );
        return result;
      case AllStatsChoose.income:
        result = await db.rawQuery(
          '''
            SELECT ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.incomeSource} AS Source, 
            (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome
            FROM ${IncomeMeta.nameTable}
            INNER JOIN ${IncomeSourceMeta.nameTable} 
            ON ${IncomeMeta.nameTable}.${IncomeMeta.idIncomeSource} 
            = 
            ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.id} 
            WHERE date(${IncomeMeta.date}) >= date(?)
            AND date(${IncomeMeta.date}) <= date(?)
            GROUP BY Source
            ORDER BY TotalIncome
            DESC LIMIT 7;
          ''',
          [first, last],
        );
        return result;
    }
  }

  Future<List<TransactionModel>> getTransaction(DateTime date) async {
    final List<IncomeModel> incomeData = [];
    final List<ExpenseModel> expenseData = [];

    final start = DateTime(date.year, date.month).toIso8601String();
    final end = DateTime(
      date.year,
      date.month,
      DateTime(date.year, date.month + 1, 0).day,
    ).toIso8601String();

    final res = await Future.wait([
      db.rawQuery(
        '''
        SELECT * FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
      ''',
        [start, end],
      ),
      db.rawQuery(
        '''
        SELECT * FROM ${ExpenseMeta.nameTable}
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
      ''',
        [start, end],
      ),
    ]);

    for (final data in res[0]) {
      incomeData.add(IncomeModel.fromDatabase(data));
    }
    for (final data in res[1]) {
      expenseData.add(ExpenseModel.fromDatabase(data));
    }

    return <TransactionModel>[...incomeData, ...expenseData];
  }

  //* ================ GOAL CRUD ================

  Future<void> insertGoal(GoalModel goalModel) async {
    await db.insert(
      GoalMeta.nameTable,
      {
        GoalMeta.name: goalModel.name,
        GoalMeta.image: goalModel.image,
        GoalMeta.target: goalModel.target,
        GoalMeta.collected: goalModel.collected,
        GoalMeta.targetMinor: MoneyAmount.toMinorUnits(goalModel.target),
        GoalMeta.collectedMinor:
            MoneyAmount.toMinorUnits(goalModel.collected, allowZero: true),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateGoal(GoalModel goalModel) async {
    final updated = await db.rawUpdate(
      '''
        UPDATE ${GoalMeta.nameTable} 
        SET ${GoalMeta.name} = ?,
        ${GoalMeta.image} = ?,
        ${GoalMeta.target} = ?,
        ${GoalMeta.targetMinor} = ?
        WHERE ${GoalMeta.id} = ? AND ${GoalMeta.collectedMinor} <= ?
      ''',
      [
        goalModel.name,
        goalModel.image,
        goalModel.target,
        MoneyAmount.toMinorUnits(goalModel.target),
        goalModel.id,
        MoneyAmount.toMinorUnits(goalModel.target),
      ],
    );
    if (updated != 1)
      throw StateError('Goal not found or target below savings');
  }

  Future<void> updateCollectedGoal(GoalModel goalModel) async {
    await db.rawUpdate(
      '''
        UPDATE ${GoalMeta.nameTable} 
        SET ${GoalMeta.collected} = ?,
            ${GoalMeta.collectedMinor} = ?
        WHERE ${GoalMeta.id} = ?
      ''',
      [
        goalModel.collected,
        MoneyAmount.toMinorUnits(goalModel.collected, allowZero: true),
        goalModel.id
      ],
    );
  }

  Future<List<GoalSavingModel>> getGoalDetailSave(int goalId) async {
    final List<GoalSavingModel> dataList = [];
    final result = await db.rawQuery(
      '''
        SELECT * FROM ${GoalSavingMeta.nameTable} 
        WHERE ${GoalSavingMeta.idGoal} = ?
        ORDER BY ${GoalSavingMeta.date} DESC
      ''',
      [goalId],
    );

    for (final data in result) {
      dataList.add(GoalSavingModel.fromDatabase(data));
    }

    return dataList;
  }

  Future<GoalModel> getSingleGoalModel(int goalId) async {
    final result = await db.rawQuery(
      '''
        SELECT * FROM ${GoalMeta.nameTable}
        WHERE ${GoalMeta.id} = ? 
      ''',
      [goalId],
    );

    return GoalModel.fromDatabase(result[0]);
  }

  Future<void> saveGoalSaving(
    int idGoal,
    DateTime date,
    double amount,
  ) async {
    await db.insert(
      GoalSavingMeta.nameTable,
      {
        GoalSavingMeta.idGoal: idGoal,
        GoalSavingMeta.date: date.toIso8601String(),
        GoalSavingMeta.amount: amount,
        GoalSavingMeta.amountMinor: MoneyAmount.toMinorUnits(amount),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GoalModel>> getGoalsHome() async {
    final List<GoalModel> dataList = [];
    final List<Map<String, dynamic>> maps = await db.query(
      GoalMeta.nameTable,
      limit: 5,
    );
    for (final element in maps) {
      dataList.add(GoalModel.fromDatabase(element));
    }
    return dataList;
  }

  Future<List<GoalModel>> getGoalsList(int id) async {
    final List<GoalModel> dataList = [];
    final maps = await db.rawQuery(
      '''
        SELECT * FROM ${GoalMeta.nameTable}
        WHERE ${GoalMeta.id} < ?
        ORDER BY ${GoalMeta.id} DESC LIMIT 12
      ''',
      [id],
    );
    for (final data in maps) {
      dataList.add(GoalModel.fromDatabase(data));
    }

    return dataList;
  }

  Future<GoalModel?> checkLastRowGoals() async {
    final maps = await db.rawQuery(
      '''
        SELECT *
        FROM ${GoalMeta.nameTable}
        ORDER BY ${GoalMeta.id} DESC
        LIMIT 1
      ''',
    );
    return (maps.isEmpty) ? null : GoalModel.fromDatabase(maps[0]);
  }

  Future<int> getGoalsCount() async {
    final total = await db.rawQuery(
      '''
      SELECT COUNT(*) AS goals_count
      FROM ${GoalMeta.nameTable}
    ''',
    );

    return total[0]['goals_count'] as int;
  }

  Future<void> deleteGoalWithSaving(int id) async {
    await db.transaction((txn) async {
      await txn.delete(
        GoalSavingMeta.nameTable,
        where: "${GoalSavingMeta.idGoal} = ?",
        whereArgs: [id],
      );
      await txn.delete(
        GoalMeta.nameTable,
        where: "${GoalMeta.id} = ?",
        whereArgs: [id],
      );
    });
  }

  Future<void> deleteSingleSaving(int id) async {
    await db.delete(
      GoalSavingMeta.nameTable,
      where: "${GoalSavingMeta.id} = ?",
      whereArgs: [id],
    );
  }

  /// All goal balance mutations are atomic and constrained at write-time.
  Future<void> addSavingAtomic(int goalId, DateTime date, double amount) async {
    final minor = MoneyAmount.toMinorUnits(amount);
    await db.transaction((txn) async {
      final updated = await txn.rawUpdate(
        'UPDATE ${GoalMeta.nameTable} SET '
        '${GoalMeta.collectedMinor} = ${GoalMeta.collectedMinor} + ?, '
        '${GoalMeta.collected} = (${GoalMeta.collectedMinor} + ?) / 100.0 '
        'WHERE ${GoalMeta.id} = ? AND '
        '${GoalMeta.collectedMinor} + ? <= ${GoalMeta.targetMinor}',
        [minor, minor, goalId, minor],
      );
      if (updated != 1) throw StateError('Goal not found or target exceeded');
      await txn.insert(GoalSavingMeta.nameTable, {
        GoalSavingMeta.idGoal: goalId,
        GoalSavingMeta.date: date.toIso8601String(),
        GoalSavingMeta.amount: amount,
        GoalSavingMeta.amountMinor: minor,
      });
    });
  }

  Future<void> deleteSavingAtomic(int goalId, int savingId) async {
    await db.transaction((txn) async {
      final rows = await txn.query(
        GoalSavingMeta.nameTable,
        columns: [GoalSavingMeta.amountMinor],
        where: '${GoalSavingMeta.id} = ? AND ${GoalSavingMeta.idGoal} = ?',
        whereArgs: [savingId, goalId],
      );
      if (rows.isEmpty) throw StateError('Saving not found');
      final minor = rows.single[GoalSavingMeta.amountMinor] as int;
      final updated = await txn.rawUpdate(
        'UPDATE ${GoalMeta.nameTable} SET '
        '${GoalMeta.collectedMinor} = ${GoalMeta.collectedMinor} - ?, '
        '${GoalMeta.collected} = (${GoalMeta.collectedMinor} - ?) / 100.0 '
        'WHERE ${GoalMeta.id} = ? AND ${GoalMeta.collectedMinor} >= ?',
        [minor, minor, goalId, minor],
      );
      if (updated != 1) throw StateError('Invalid goal balance');
      await txn.delete(
        GoalSavingMeta.nameTable,
        where: '${GoalSavingMeta.id} = ?',
        whereArgs: [savingId],
      );
    });
  }

  //* ================ INCOME CRUD ================

  Future<void> insertIncome(IncomeModel data) async {
    final foreignId = data.incomeSource.substring(
      0,
      data.incomeSource.indexOf(" "),
    );

    await db.insert(
      IncomeMeta.nameTable,
      {
        IncomeMeta.date: data.date.toIso8601String(),
        IncomeMeta.amount: data.amount,
        IncomeMeta.amountMinor: MoneyAmount.toMinorUnits(data.amount),
        IncomeMeta.desc: data.desc,
        IncomeMeta.idIncomeSource: foreignId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateIncome(IncomeModel data) async {
    final foreignId = data.incomeSource.substring(
      0,
      data.incomeSource.indexOf(" "),
    );

    await db.update(
      IncomeMeta.nameTable,
      {
        IncomeMeta.date: data.date.toIso8601String(),
        IncomeMeta.amount: data.amount,
        IncomeMeta.desc: data.desc,
        IncomeMeta.idIncomeSource: foreignId,
      },
      where: "${IncomeMeta.id} = ?",
      whereArgs: [data.id],
    );
  }

  Future<void> deleteIncome(int id) async {
    await db.delete(
      IncomeMeta.nameTable,
      where: "${IncomeMeta.id} = ?",
      whereArgs: [id],
    );
  }

  Future<List<IncomeSourceModel>> getIncomeSource() async {
    final List<IncomeSourceModel> listData = [];
    final List<Map<String, dynamic>> maps = await db.query(
      IncomeSourceMeta.nameTable,
    );
    for (final element in maps) {
      listData.add(IncomeSourceModel.fromMap(element));
    }
    return listData;
  }

  Future<num> getTotalIncome() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT (SUM(${IncomeMeta.amountMinor}) / 100.0) AS total
        FROM ${IncomeMeta.nameTable}
      ''');
    return (maps.first['total'] as num?) ?? 0;
  }

  Future<Map<String, double>> getYearlyIncome() async {
    final nowYear = DateTime.now().year;

    final Map<String, double> uniqueData = {
      "$nowYear-01": 0.0,
      "$nowYear-02": 0.0,
      "$nowYear-03": 0.0,
      "$nowYear-04": 0.0,
      "$nowYear-05": 0.0,
      "$nowYear-06": 0.0,
      "$nowYear-07": 0.0,
      "$nowYear-08": 0.0,
      "$nowYear-09": 0.0,
      "$nowYear-10": 0.0,
      "$nowYear-11": 0.0,
      "$nowYear-12": 0.0,
    };

    final now = DateTime.now();
    final firstDate = DateTime(now.year).toIso8601String();
    final lastDate = DateTime(now.year, 12, 31).toIso8601String();

    final result = await db.rawQuery(
      '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month, 
        (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome 
        FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Month
      ''',
      [firstDate, lastDate],
    );

    for (final Map<String, Object?> item in result) {
      final Object? totInc = item["TotalIncome"];

      final result = totInc != null
          ? (totInc is int ? totInc.toDouble() : totInc as double)
          : 0.0;

      final month = item["Month"].toString();
      uniqueData[month] = result;
      Logger.Red.log(item["TotalIncome"]);
    }

    return uniqueData;
  }

  Future<List<Map<String, Object?>>> getIncomeBreakdown(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await db.rawQuery(
      '''
        SELECT ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.incomeSource} AS Source, 
        (SUM(${IncomeMeta.amountMinor}) / 100.0) AS TotalIncome
        FROM ${IncomeMeta.nameTable}
        INNER JOIN ${IncomeSourceMeta.nameTable} 
        ON ${IncomeMeta.nameTable}.${IncomeMeta.idIncomeSource} 
        = 
        ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.id} 
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Source;
      ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );
    return result;
  }

  Future<List<IncomeModel>> getMostIncomeByCategory({
    required String source,
    String? startDate,
    String? endDate,
  }) async {
    final List<IncomeModel> listData = [];

    final now = DateTime.now();
    startDate ??= DateTime(now.year).toIso8601String();
    endDate ??= DateTime(now.year, 12, 31).toIso8601String();

    final read = await db.rawQuery(
      '''
        SELECT ${IncomeSourceMeta.id} 
        FROM ${IncomeSourceMeta.nameTable} 
        WHERE ${IncomeSourceMeta.incomeSource} = ?
      ''',
      [source],
    );

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
        SELECT *
        FROM ${IncomeMeta.nameTable}
        INNER JOIN ${IncomeSourceMeta.nameTable} 
        ON ${IncomeMeta.nameTable}.${IncomeMeta.idIncomeSource} 
        = 
        ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.id} 
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        AND ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.id} = ?
        ORDER BY ${IncomeMeta.amountMinor} DESC
      ''',
      [startDate, endDate, read[0].values.first],
    );

    for (final element in maps) {
      listData.add(IncomeModel.fromDatabase(element));
    }

    return listData;
  }

  //* ================ EXPENSE CRUD ================

  Future<void> insertExpense(ExpenseModel data) async {
    final foreignId = data.categories.substring(
      0,
      data.categories.indexOf(" "),
    );

    await db.insert(
      ExpenseMeta.nameTable,
      {
        ExpenseMeta.date: data.date.toIso8601String(),
        ExpenseMeta.amount: data.amount,
        ExpenseMeta.amountMinor: MoneyAmount.toMinorUnits(data.amount),
        ExpenseMeta.item: data.item,
        ExpenseMeta.idCategories: foreignId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(ExpenseModel data) async {
    final foreignId = data.categories.substring(
      0,
      data.categories.indexOf(" "),
    );

    await db.update(
      ExpenseMeta.nameTable,
      {
        ExpenseMeta.date: data.date.toIso8601String(),
        ExpenseMeta.amount: data.amount,
        ExpenseMeta.item: data.item,
        ExpenseMeta.idCategories: foreignId,
      },
      where: "${ExpenseMeta.id} = ?",
      whereArgs: [data.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    await db.delete(
      ExpenseMeta.nameTable,
      where: "${ExpenseMeta.id} = ?",
      whereArgs: [id],
    );
  }

  Future<List<ExpenseCategoriesModel>> getExpenseCategories() async {
    final List<ExpenseCategoriesModel> listData = [];
    final List<Map<String, dynamic>> maps = await db.query(
      ExpenseCategoriesMeta.nameTable,
    );
    for (final element in maps) {
      listData.add(ExpenseCategoriesModel.fromMap(element));
    }
    return listData;
  }

  Future<List<ExpenseModel>> getTodayExpenses() async {
    final List<ExpenseModel> listData = [];
    final now = DateTime.now();
    final List<Map<String, dynamic>> maps = await db.query(
      ExpenseMeta.nameTable,
      where: "date(${ExpenseMeta.date}) = date(?)",
      whereArgs: [DateTime(now.year, now.month, now.day).toIso8601String()],
      orderBy: "${ExpenseMeta.date} DESC",
    );

    for (final element in maps) {
      listData.add(ExpenseModel.fromDatabase(element));
    }
    return listData;
  }

  Future<List<Map<String, Object?>>> getExpenseBreakdown(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await db.rawQuery(
      '''
        SELECT ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.expenseCategories} AS Categories, 
        (SUM(${ExpenseMeta.amountMinor}) / 100.0) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
        INNER JOIN ${ExpenseCategoriesMeta.nameTable} 
        ON ${ExpenseMeta.nameTable}.${ExpenseMeta.idCategories} 
        = 
        ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.id} 
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
        GROUP BY Categories;
      ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return result;
  }

  Future<List<ExpenseModel>> getMostExpenseByCategory({
    required String source,
    String? startDate,
    String? endDate,
  }) async {
    final List<ExpenseModel> listData = [];

    final now = DateTime.now();
    startDate ??= DateTime(now.year).toIso8601String();
    endDate ??= DateTime(now.year, 12, 31).toIso8601String();

    final read = await db.rawQuery(
      '''
        SELECT ${ExpenseCategoriesMeta.id} 
        FROM ${ExpenseCategoriesMeta.nameTable} 
        WHERE ${ExpenseCategoriesMeta.expenseCategories} = ?
      ''',
      [source],
    );

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
        SELECT *
        FROM ${ExpenseMeta.nameTable}
        INNER JOIN ${ExpenseCategoriesMeta.nameTable} 
        ON ${ExpenseMeta.nameTable}.${ExpenseMeta.idCategories} 
        = 
        ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.id} 
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
        AND ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.id} = ?
        ORDER BY ${ExpenseMeta.amountMinor} DESC
      ''',
      [startDate, endDate, read[0].values.first],
    );

    for (final element in maps) {
      listData.add(ExpenseModel.fromDatabase(element));
    }

    return listData;
  }

  //* ================ NOTIFICATION CRUD ======================

  Future<void> updateNotificationIsRead(int id) async {
    await db.rawUpdate(
      '''
        UPDATE ${NotificationMeta.nameTable}
        SET ${NotificationMeta.isRead} = ?
        WHERE ${NotificationMeta.id} = ?
      ''',
      [1, id],
    );
  }

  Future<void> updateNotificationIsReadAll() async {
    await db.rawUpdate(
      '''
        UPDATE ${NotificationMeta.nameTable}
        SET ${NotificationMeta.isRead} = ?
      ''',
      [1],
    );
  }

  Future<int> getNotificationCount() async {
    final total = await db.rawQuery(
      '''
      SELECT COUNT(*) AS unread_count
      FROM ${NotificationMeta.nameTable}
      WHERE ${NotificationMeta.isRead} = ?
    ''',
      [0],
    );

    return total[0]['unread_count'] as int;
  }

  Future<NotificationModelClass?> checkLastRowNotification() async {
    final maps = await db.rawQuery(
      '''
        SELECT *
        FROM ${NotificationMeta.nameTable}
        ORDER BY ${NotificationMeta.id} DESC
        LIMIT 1
      ''',
    );

    return (maps.isEmpty)
        ? null
        : NotificationModelClass(
            id: maps[0][NotificationMeta.id] as int,
            title: maps[0][NotificationMeta.title] as String,
            desc: maps[0][NotificationMeta.desc] as String,
            date: DateTime.parse(maps[0][NotificationMeta.date] as String),
            isRead: (maps[0][NotificationMeta.isRead] == 0) ? false : true,
            type: maps[0][NotificationMeta.type] as int,
          );
  }

  Future<List<NotificationModelClass>> getNotificationList(
    String timeOffset,
    int idOffset,
  ) async {
    Logger.Green.log('time: $timeOffset id: $idOffset');
    final List<NotificationModelClass> dataList = [];
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
        SELECT * FROM ${NotificationMeta.nameTable}
        WHERE (date(${NotificationMeta.date}) = date(?) AND ${NotificationMeta.id} < ?) 
        OR date(${NotificationMeta.date}) < date(?)
        ORDER BY ${NotificationMeta.date} DESC
        LIMIT 12
      ''',
      [timeOffset, idOffset, timeOffset],
    );

    for (final data in maps) {
      dataList.add(
        NotificationModelClass(
          id: data[NotificationMeta.id],
          title: data[NotificationMeta.title],
          desc: data[NotificationMeta.desc],
          date: DateTime.parse(data[NotificationMeta.date]),
          isRead: (data[NotificationMeta.isRead] == 0) ? false : true,
          type: data[NotificationMeta.type],
        ),
      );
    }
    return dataList;
  }

  Future<bool> checkNotificationMonthlyBudget() async {
    final now = DateFormat('yyyy-MM').format(DateTime.now());
    final checkNotification = await db.rawQuery(
      '''
        SELECT * FROM ${NotificationMeta.nameTable}
        WHERE ${NotificationMeta.type} = ?
        AND strftime('%Y-%m', ${NotificationMeta.date}) = ?
      ''',
      [0, now],
    );

    return (checkNotification.isNotEmpty) ? false : true;
  }

  Future<bool> checkNotificationCurrentBalance() async {
    final now = DateFormat('yyyy-MM').format(DateTime.now());
    final checkNotification = await db.rawQuery(
      '''
        SELECT * FROM ${NotificationMeta.nameTable}
        WHERE ${NotificationMeta.type} = ?
        AND strftime('%Y-%m', ${NotificationMeta.date}) = ?
      ''',
      [1, now],
    );

    return (checkNotification.isNotEmpty) ? false : true;
  }

  Future<bool> checkNotificationTotalBalance() async {
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final checkNotification = await db.rawQuery(
      '''
        SELECT * FROM ${NotificationMeta.nameTable}
        WHERE ${NotificationMeta.type} = ?
        AND strftime('%Y-%m-%d', ${NotificationMeta.date}) = ?
      ''',
      [2, now],
    );

    return (checkNotification.isNotEmpty) ? false : true;
  }

  Future<int> saveNotification(NotificationModelClass data) async {
    return await db.insert(
      NotificationMeta.nameTable,
      {
        NotificationMeta.title: data.title,
        NotificationMeta.desc: data.desc,
        NotificationMeta.date: data.date.toIso8601String(),
        NotificationMeta.type: data.type,
        NotificationMeta.isRead: 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //* ================ RECURRING CRUD ======================

  Future<void> checkAndInputRecurring() async {
    final today = DateTime.now();
    final through = DateTime(today.year, today.month, today.day);
    final rules = await db.query(
      RecurringMeta.nameTable,
      orderBy: '${RecurringMeta.id} ASC',
    );
    for (final rule in rules) {
      final ruleId = rule[RecurringMeta.id] as int;
      final day = rule[RecurringMeta.recurringDay] as int;
      final latest =
          DateTime.parse(rule[RecurringMeta.recurringLast] as String);
      var due = RecurringSchedule.next(latest, day);
      while (!due.isAfter(through)) {
        await db.transaction((txn) async {
          // A unique rule/month key also prevents duplicates if processing is
          // interrupted and re-entered.
          final period = '${due.year}-${due.month.toString().padLeft(2, '0')}';
          final prior = await txn.query(
            'recurring_occurrences',
            where: 'rule_id = ? AND period = ?',
            whereArgs: [ruleId, period],
            limit: 1,
          );
          if (prior.isEmpty) {
            await txn.insert(
              'recurring_occurrences',
              {'rule_id': ruleId, 'period': period},
            );

            final minor = (rule[RecurringMeta.amountMinor] as num).toInt();
            if (minor > 0) {
              await txn.insert(IncomeMeta.nameTable, {
                IncomeMeta.date: due.toIso8601String(),
                IncomeMeta.desc: 'Monthly Income (Recurring)',
                IncomeMeta.amount: minor / MoneyAmount.factor,
                IncomeMeta.amountMinor: minor,
                IncomeMeta.idIncomeSource: 0,
              });
            }
          }
          await txn.update(
            RecurringMeta.nameTable,
            {RecurringMeta.recurringLast: due.toIso8601String()},
            where: '${RecurringMeta.id} = ?',
            whereArgs: [ruleId],
          );
        });
        due = RecurringSchedule.next(due, day);
      }
    }
  }

  Future<void> saveRecurringMonthly({
    required int recDay,
    required int type,
    required double amount,
    required bool isFromLogin,
  }) async {
    if (recDay < 1 || recDay > 31) {
      throw RangeError.range(recDay, 1, 31, 'recDay');
    }
    final minor = MoneyAmount.toMinorUnits(amount);
    await db.transaction((txn) async {
      final existing = await txn.query(
        RecurringMeta.nameTable,
        where: '${RecurringMeta.type} = ? AND ${RecurringMeta.idModel} = ?',
        whereArgs: [type, 0],
        orderBy: '${RecurringMeta.id} ASC',
      );
      if (existing.isNotEmpty) {
        final first = existing.first;
        await txn.update(
          RecurringMeta.nameTable,
          {
            RecurringMeta.recurringDay: recDay,
            RecurringMeta.amount: amount,
            RecurringMeta.amountMinor: minor,
          },
          where: '${RecurringMeta.id} = ?',
          whereArgs: [first[RecurringMeta.id]],
        );
        // Prior versions could add duplicate rules on every login. Remove
        // extras without touching the income entries already recorded.
        for (final duplicate in existing.skip(1)) {
          await txn.delete(
            RecurringMeta.nameTable,
            where: '${RecurringMeta.id} = ?',
            whereArgs: [duplicate[RecurringMeta.id]],
          );
        }
      } else {
        await txn.insert(RecurringMeta.nameTable, {
          RecurringMeta.idModel: 0,
          RecurringMeta.type: type,
          RecurringMeta.recurringDay: recDay,
          RecurringMeta.recurringLast:
              RecurringSchedule.initialLast(DateTime.now(), recDay)
                  .toIso8601String(),
          RecurringMeta.amount: amount,
          RecurringMeta.amountMinor: minor,
        });
      }
    });
    if (isFromLogin) await checkAndInputRecurring();
  }

  //! ================ DELETE ALL ================

  Future<void> deleteAllTable() async {
    final table = [
      IncomeMeta.nameTable,
      ExpenseMeta.nameTable,
      GoalMeta.nameTable,
      GoalSavingMeta.nameTable,
      NotificationMeta.nameTable,
      RecurringMeta.nameTable,
    ];

    await Future.wait(table.map((e) => db.delete(e)).toList());
    await Future.wait(
      table
          .map(
            (e) => db.rawUpdate(
              "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME = ?",
              [e],
            ),
          )
          .toList(),
    );
  }
}
