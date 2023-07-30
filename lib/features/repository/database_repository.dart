import 'dart:async';

import 'package:cling/core/logger.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:cling/features/model/expense_categories_model.dart';
import 'package:cling/features/model/expense_model.dart';
import 'package:cling/features/model/income_source_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../../core/init_database.dart';

class DatabaseRepository {
  late Database db;
  static const databaseName = 'cling_database.db';

  DatabaseRepository() {
    open();
  }

  Future<void> open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: initDatabaseTable,
      version: 1,
    );
    Logger.Green.log("Database Created");
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
      listData.add(ExpenseModel.fromMap(element));
    }
    return listData;
  }

  Future<double> getTotalIncome() async {
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT SUM(${IncomeMeta.amount}) 
        FROM ${IncomeMeta.nameTable}
      ''');
    return maps.first['SUM(${IncomeMeta.amount})'];
  }

  Future<double> getTotalExpense() async {
    List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT SUM(${ExpenseMeta.amount}) 
        FROM ${ExpenseMeta.nameTable}
      ''');
    return maps.first['SUM(${ExpenseMeta.amount})'];
  }
}
