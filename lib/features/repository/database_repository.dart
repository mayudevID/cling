import 'dart:async';

import 'package:cling/core/logger.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/income_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../../core/init_database.dart';
import '../model/goal_model.dart';

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

  Future<void> insertGoal(GoalModel data) async {
    await db.insert(
      GoalMeta.nameTable,
      {
        GoalMeta.name: data.name,
        GoalMeta.image: data.image,
        GoalMeta.target: data.target,
        GoalMeta.collected: data.collected,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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
        IncomeSourceMeta.id: foreignId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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
        ExpenseCategoriesMeta.id: foreignId,
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

    for (var element in maps) {
      listData.add(ExpenseModel.fromDatabase(element));
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

  Future<num> getTotalExpense() async {
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT SUM(${ExpenseMeta.amount}) 
        FROM ${ExpenseMeta.nameTable}
      ''');
    return maps.first['SUM(${ExpenseMeta.amount})'] ?? 0;
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

  Future<List<ExpenseModel>> getMostExpense() async {
    List<ExpenseModel> dataList = [];
    final result = await db.rawQuery(
      "SELECT * FROM ${ExpenseMeta.nameTable} ORDER BY ${ExpenseMeta.amount} DESC LIMIT 7",
    );

    for (var element in result) {
      dataList.add(ExpenseModel.fromDatabase(element));
    }
    return dataList;
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

  Future<List<Map<String, Object?>>> getIncomeBreakdown() async {
    final result = await db.rawQuery(
      '''
        SELECT ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.incomeSource} AS Categories, 
        SUM(${IncomeMeta.amount}) AS TotalIncome
        FROM ${IncomeMeta.nameTable}
        INNER JOIN ${IncomeSourceMeta.nameTable} 
        ON ${IncomeMeta.nameTable}.${IncomeSourceMeta.id} 
        = 
        ${IncomeSourceMeta.nameTable}.${IncomeSourceMeta.id} 
        GROUP BY Categories;
      ''',
    );

    return result;
  }

  //! ================ DELETE ALL ================

  Future<void> deleteAllTable() async {
    await Future.wait([
      db.delete(IncomeMeta.nameTable),
      db.delete(ExpenseMeta.nameTable),
      db.delete(GoalMeta.nameTable),
    ]);
  }
}
