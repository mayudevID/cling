import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'static_name_table.dart';

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

final emotLogo = [
  "📱",
  "⛩️",
  "🎧",
  "🖥️",
  "💻",
  "🎉",
  "🌏",
];

FutureOr<void> initDatabaseTable(Database db, int version) async {
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
            ${IncomeMeta.idIncomeSource} INTEGER,
            FOREIGN KEY (${IncomeMeta.idIncomeSource}) 
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
            ${ExpenseMeta.idCategories} INTEGER,
            FOREIGN KEY (${ExpenseMeta.idCategories}) 
            REFERENCES ${ExpenseCategoriesMeta.nameTable} 
            (${ExpenseCategoriesMeta.id}) 
          )
          ''',
    ),
    db.execute(
      '''
          CREATE TABLE ${GoalMeta.nameTable}(
            ${GoalMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
            ${GoalMeta.name} TEXT, 
            ${GoalMeta.image} TEXT,
            ${GoalMeta.target} INTEGER,
            ${GoalMeta.collected} INTEGER
          )
          ''',
    ),
    db.execute('''
         CREATE TABLE ${GoalSavingMeta.nameTable}(
            ${GoalSavingMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${GoalSavingMeta.idGoal} INTEGER,
            ${GoalSavingMeta.date} TEXT,
            ${GoalSavingMeta.amount} INTEGER,
            FOREIGN KEY (${GoalSavingMeta.idGoal}) 
            REFERENCES ${GoalMeta.nameTable} 
            (${GoalMeta.id}) 
         ) 
      '''),
    db.execute('''
         CREATE TABLE ${NotificationMeta.nameTable}(
            ${NotificationMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${NotificationMeta.title} TEXT,
            ${NotificationMeta.desc} TEXT,
            ${NotificationMeta.type} INTEGER,
            ${NotificationMeta.date} TEXT,
            ${NotificationMeta.isRead} INTEGER
         ) 
      '''),
    db.execute('''
         CREATE TABLE ${RecurringMeta.nameTable}(
            ${RecurringMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${RecurringMeta.idModel} INTEGER,
            ${RecurringMeta.recurringDay} INTEGER,
            ${RecurringMeta.recurringLast} TEXT,
            ${RecurringMeta.amount} INTEGER,
            ${RecurringMeta.type} INTEGER
         ) 
      '''),
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
