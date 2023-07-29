import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'static_name_table.dart';

FutureOr<void> initDatabaseTable(Database db, int version) async {
  final exCategoriesData = [
    "🎑 Other",
    "💵 Bill",
    "💹 Business & Investment",
    "😎 Entertaiment",
    "🍽️ Food & Beverage",
    "🎁 Gift",
    "🙂 Health & Beauty",
    "🛒 Shopping",
    "💳 Subscription",
    "🚗 Transport",
  ];
  final inSourceData = [
    "🎑 Other",
    "🧑‍💼 Fulltime Job",
    "💹 Investment",
    "😎 Business",
    "🎁 Gift",
    "🙂 Health, Beauty, & Wellbeing"
  ];

  await Future.wait([
    db.execute('''
          CREATE TABLE ${IncomeSourceMeta.nameTable}(
            ${IncomeSourceMeta.id} INTEGER PRIMARY KEY,
            ${IncomeSourceMeta.incomeSource} TEXT
          ) 
          '''),
    db.execute('''
          CREATE TABLE ${ExpenseCategoriesMeta.nameTable}(
            ${ExpenseCategoriesMeta.id} INTEGER PRIMARY KEY,
            ${ExpenseCategoriesMeta.expenseCategories} TEXT
          ) 
          '''),
    db.execute(
      '''
          CREATE TABLE ${IncomeMeta.nameTable}(
            ${IncomeMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
            ${IncomeMeta.date} TEXT, 
            ${IncomeMeta.desc} TEXT,
            ${IncomeMeta.amount} INTEGER,
            ${IncomeSourceMeta.id} INTEGER,
            FOREIGN KEY (${IncomeSourceMeta.id}) 
            REFERENCES ${IncomeSourceMeta.nameTable} 
            (${IncomeSourceMeta.id}) 
          )
          ''',
    ),
    db.execute(
      '''
          CREATE TABLE ${ExpenseMeta.nameTable}(
            ${ExpenseMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
            ${ExpenseMeta.date} TEXT, 
            ${ExpenseMeta.item} TEXT,
            ${ExpenseMeta.amount} INTEGER,
            ${ExpenseCategoriesMeta.id} INTEGER,
            FOREIGN KEY (${ExpenseCategoriesMeta.id}) 
            REFERENCES ${ExpenseCategoriesMeta.nameTable} 
            (${ExpenseCategoriesMeta.id}) 
          )
          ''',
    ),
  ]);

  for (var i = 0; i < inSourceData.length; i++) {
    await db.insert(
      IncomeSourceMeta.nameTable,
      {
        IncomeSourceMeta.id: i,
        IncomeSourceMeta.incomeSource: inSourceData[i],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  for (var i = 0; i < exCategoriesData.length; i++) {
    await db.insert(
      ExpenseCategoriesMeta.nameTable,
      {
        ExpenseCategoriesMeta.id: i,
        ExpenseCategoriesMeta.expenseCategories: exCategoriesData[i],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
