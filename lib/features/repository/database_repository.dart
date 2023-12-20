import 'dart:async';
import 'package:cling/core/logger.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../../core/init_database.dart';
import '../model/expense_categories_model.dart';
import '../model/expense_model.dart';
import '../model/goal_model.dart';
import '../model/income_model.dart';
import '../model/income_source_model.dart';
import '../model/notification_model_class.dart';
import '../ui/main/statistics/bloc/statistics_bloc.dart';

class DatabaseRepository {
  late Database db;
  static const databaseName = 'cling_database.db';

  DatabaseRepository() {
    open();
  }

  Map<String, dynamic> emptyData = {
    "2023-01": 0,
    "2023-02": 0,
    "2023-03": 0,
    "2023-04": 0,
    "2023-05": 0,
    "2023-06": 0,
    "2023-07": 0,
    "2023-08": 0,
    "2023-09": 0,
    "2023-10": 0,
    "2023-11": 0,
    "2023-12": 0,
  };

  Future<void> open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: initDatabaseTable,
      version: 1,
    );
    Logger.Green.log("Database Created");
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
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateImageGoal(GoalModel goalModel) async {
    await db.rawUpdate(
      '''
        UPDATE ${GoalMeta.nameTable} 
        SET ${GoalMeta.image} = ? 
        WHERE ${GoalMeta.id} = ?
      ''',
      [goalModel.image, goalModel.id],
    );
  }

  Future<void> updateCollectedGoal(GoalModel goalModel) async {
    await db.rawUpdate(
      '''
        UPDATE ${GoalMeta.nameTable} 
        SET ${GoalMeta.collected} = ? 
        WHERE ${GoalMeta.id} = ?
      ''',
      [goalModel.collected, goalModel.id],
    );
  }

  Future<List<Map<String, Object?>>> getGoalDetailSave(int goalId) async {
    final result = await db.rawQuery(
      '''
        SELECT ${GoalSavingMeta.date} AS Date,
        SUM(${GoalSavingMeta.amount}) AS TotalSavings 
        FROM ${GoalSavingMeta.nameTable}
        WHERE ${GoalSavingMeta.idGoal} = ?
        GROUP BY Date;
      ''',
      [goalId],
    );

    return result;
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
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
        IncomeMeta.desc: data.desc,
        IncomeMeta.idIncomeSource: foreignId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IncomeSourceModel>> getIncomeSource() async {
    List<IncomeSourceModel> listData = [];
    List<Map<String, dynamic>> maps = await db.query(
      IncomeSourceMeta.nameTable,
    );
    for (var element in maps) {
      listData.add(IncomeSourceModel.fromMap(element));
    }
    return listData;
  }

  Future<num> getTotalIncome() async {
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT SUM(${IncomeMeta.amount}) 
        FROM ${IncomeMeta.nameTable}
      ''');
    return maps.first['SUM(${IncomeMeta.amount})'] ?? 0;
  }

  Future<Map<String, dynamic>> getYearlyIncome() async {
    var uniqueData = emptyData;

    final now = DateTime.now();
    final firstDate = DateTime(now.year, 1, 1).toIso8601String();
    final lastDate = DateTime(now.year, 12, 31).toIso8601String();

    final result = await db.rawQuery(
      '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month, 
        SUM(${IncomeMeta.amount}) AS TotalIncome 
        FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Month
      ''',
      [firstDate, lastDate],
    );

    for (Map<String, Object?> item in result) {
      final month = item["Month"].toString();
      uniqueData[month] = item["TotalIncome"];
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
        SUM(${IncomeMeta.amount}) AS TotalIncome
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
    List<IncomeModel> listData = [];

    final now = DateTime.now();
    startDate ??= DateTime(now.year, 1, 1).toIso8601String();
    endDate ??= DateTime(now.year, 12, 31).toIso8601String();

    final read = await db.rawQuery(
      '''
        SELECT ${IncomeSourceMeta.id} 
        FROM ${IncomeSourceMeta.nameTable} 
        WHERE ${IncomeSourceMeta.incomeSource} = ?
      ''',
      [source],
    );

    List<Map<String, dynamic>> maps = await db.rawQuery(
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
        ORDER BY ${IncomeMeta.amount} DESC
      ''',
      [startDate, endDate, read[0].values.first],
    );

    for (var element in maps) {
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
        ExpenseMeta.item: data.item,
        ExpenseMeta.idCategories: foreignId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExpenseCategoriesModel>> getExpenseCategories() async {
    List<ExpenseCategoriesModel> listData = [];
    List<Map<String, dynamic>> maps = await db.query(
      ExpenseCategoriesMeta.nameTable,
    );
    for (var element in maps) {
      listData.add(ExpenseCategoriesModel.fromMap(element));
    }
    return listData;
  }

  Future<List<ExpenseModel>> getTodayExpenses() async {
    List<ExpenseModel> listData = [];
    final now = DateTime.now();
    List<Map<String, dynamic>> maps = await db.query(
      ExpenseMeta.nameTable,
      where: "date(${ExpenseMeta.date}) = date(?)",
      whereArgs: [DateTime(now.year, now.month, now.day).toIso8601String()],
    );

    Logger.Red.log(maps);

    for (var element in maps) {
      listData.add(ExpenseModel.fromDatabase(element));
    }
    return listData;
  }

  Future<List<GoalModel>> getGoals() async {
    List<GoalModel> dataList = [];
    List<Map<String, dynamic>> maps = await db.query(
      GoalMeta.nameTable,
    );
    for (var element in maps) {
      dataList.add(GoalModel.fromDatabase(element));
    }
    return dataList;
  }

  Future<Map<String, double?>> getTotalIncomeExpenseCurrMonth() async {
    final monthNow = DateTime.now();
    final monthNowFirstDay = DateTime(
      monthNow.year,
      monthNow.month,
      1,
    ).toIso8601String();

    final monthNowLastDay = monthNow.toIso8601String();

    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month,
        SUM(${IncomeMeta.amount}) AS TotalIncome
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
        SUM(${ExpenseMeta.amount}) AS TotalExpense
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
      final expense = result[1][0]['TotalExpense'] ?? 0;
      expenseParse = double.parse(expense.toString());
    }

    return {"income": incomeParse, "expense": expenseParse};
  }

  Future<Map<String, Map<String, dynamic>>?>
      getTotalIncomeExpenseAllMonth() async {
    final now = DateTime.now();

    final monthNowFormatted = DateTime(
      now.year,
      now.month,
      DateTime(now.year, now.month + 1, 0).day,
    ).toIso8601String();

    final fourMonthsAgoFormatted = DateTime(
      now.year,
      1,
      1,
    ).toIso8601String();

    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${IncomeMeta.date}) AS Month, 
        SUM(${IncomeMeta.amount}) AS TotalIncome 
        FROM ${IncomeMeta.nameTable}
        WHERE date(${IncomeMeta.date}) >= date(?)
        AND date(${IncomeMeta.date}) <= date(?)
        GROUP BY Month
      ''',
        [fourMonthsAgoFormatted, monthNowFormatted],
      ),
      db.rawQuery(
        '''
        SELECT strftime('%Y-%m', ${ExpenseMeta.date}) AS Month, 
        SUM(${ExpenseMeta.amount}) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
        WHERE date(${ExpenseMeta.date}) >= date(?)
        AND date(${ExpenseMeta.date}) <= date(?)
        GROUP BY Month
      ''',
        [fourMonthsAgoFormatted, monthNowFormatted],
      ),
    ]);

    Map<String, Map<String, dynamic>> combinedData = {};

    if (result[0].isNotEmpty) {
      for (var income in result[0]) {
        var month = income["Month"] as String;
        combinedData[month] ??= {"TotalIncome": 0, "TotalExpense": 0};
        combinedData[month]!["TotalIncome"] = income["TotalIncome"];
      }
    }

    if (result[1].isNotEmpty) {
      for (var expense in result[1]) {
        var month = expense["Month"] as String;
        combinedData[month] ??= {"TotalIncome": 0, "TotalExpense": 0};
        combinedData[month]!["TotalExpense"] = expense["TotalExpense"];
      }
    }

    return (combinedData.isEmpty) ? null : combinedData;
  }

  Future<List<Map<String, Object?>>> getMost(
    AllStatsChoose allStatsChoose,
  ) async {
    final first = DateTime(DateTime.now().year, 1, 1).toIso8601String();
    final last = DateTime(DateTime.now().year, 12, 31).toIso8601String();
    List<Map<String, Object?>> result;
    switch (allStatsChoose) {
      case AllStatsChoose.expense:
        result = await db.rawQuery(
          '''
            SELECT ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.expenseCategories} AS Categories, 
            SUM(${ExpenseMeta.amount}) AS TotalExpense
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
            SUM(${IncomeMeta.amount}) AS TotalIncome
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

  Future<List<Map<String, Object?>>> getExpenseBreakdown(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await db.rawQuery(
      '''
        SELECT ${ExpenseCategoriesMeta.nameTable}.${ExpenseCategoriesMeta.expenseCategories} AS Categories, 
        SUM(${ExpenseMeta.amount}) AS TotalExpense
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
    List<ExpenseModel> listData = [];

    final now = DateTime.now();
    startDate ??= DateTime(now.year, 1, 1).toIso8601String();
    endDate ??= DateTime(now.year, 12, 31).toIso8601String();

    final read = await db.rawQuery(
      '''
        SELECT ${ExpenseCategoriesMeta.id} 
        FROM ${ExpenseCategoriesMeta.nameTable} 
        WHERE ${ExpenseCategoriesMeta.expenseCategories} = ?
      ''',
      [source],
    );

    List<Map<String, dynamic>> maps = await db.rawQuery(
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
        ORDER BY ${ExpenseMeta.amount} DESC
      ''',
      [startDate, endDate, read[0].values.first],
    );

    for (var element in maps) {
      listData.add(ExpenseModel.fromDatabase(element));
    }

    return listData;
  }

  //* ================ MISC ======================

  Future<int> getTotalBalance() async {
    final result = await Future.wait([
      db.rawQuery(
        '''
        SELECT SUM(${IncomeMeta.amount}) AS TotalIncome
        FROM ${IncomeMeta.nameTable}
      ''',
      ),
      db.rawQuery(
        '''
        SELECT SUM(${ExpenseMeta.amount}) AS TotalExpense
        FROM ${ExpenseMeta.nameTable}
      ''',
      ),
    ]);
    final income = (result[0][0]['TotalIncome'] ?? 0) as int;
    final expense = (result[1][0]['TotalExpense'] ?? 0) as int;

    return income - expense;
  }

  Future<void> updateNotificationIsRead(int id) async {
    await db.rawQuery(
      '''
        UPDATE ${NotificationMeta.nameTable}
        SET ${NotificationMeta.isRead} = ?
        WHERE ${NotificationMeta.id} = ?
      ''',
      [1, id],
    );
  }

  Future<void> updateNotificationIsReadAll() async {
    await db.rawQuery(
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

  Future<List<NotificationModelClass>> getNotificationList() async {
    List<NotificationModelClass> dataList = [];
    List<Map<String, dynamic>> maps = await db.query(
      NotificationMeta.nameTable,
    );
    for (var data in maps) {
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

  Future<bool> checkNotification() async {
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

  //! ================ DELETE ALL ================

  Future<void> deleteAllTable() async {
    await Future.wait([
      db.delete(IncomeMeta.nameTable),
      db.delete(ExpenseMeta.nameTable),
      db.delete(GoalMeta.nameTable),
      db.delete(GoalSavingMeta.nameTable),
      db.delete(NotificationMeta.nameTable),
    ]);
  }
}
