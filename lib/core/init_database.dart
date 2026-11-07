import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'static_name_table.dart';

Future<void> migrateFinancialFoundation(DatabaseExecutor db) async {
  await db.execute('''CREATE TABLE IF NOT EXISTS ${WalletMeta.table} (
    ${WalletMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${WalletMeta.name} TEXT NOT NULL,
    ${WalletMeta.type} TEXT NOT NULL,
    ${WalletMeta.openingBalance} INTEGER NOT NULL DEFAULT 0,
    ${WalletMeta.currency} TEXT NOT NULL,
    ${WalletMeta.archived} INTEGER NOT NULL DEFAULT 0,
    ${WalletMeta.isDefault} INTEGER NOT NULL DEFAULT 0,
    ${WalletMeta.createdAt} TEXT NOT NULL,
    ${WalletMeta.updatedAt} TEXT NOT NULL
  )''');
  await db.execute('''CREATE TABLE IF NOT EXISTS ${TransferMeta.table} (
    ${TransferMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TransferMeta.sourceWalletId} INTEGER NOT NULL,
    ${TransferMeta.destinationWalletId} INTEGER NOT NULL,
    ${TransferMeta.amount} INTEGER NOT NULL CHECK (${TransferMeta.amount} > 0),
    ${TransferMeta.date} TEXT NOT NULL,
    ${TransferMeta.note} TEXT,
    FOREIGN KEY (${TransferMeta.sourceWalletId}) REFERENCES ${WalletMeta.table}(${WalletMeta.id}),
    FOREIGN KEY (${TransferMeta.destinationWalletId}) REFERENCES ${WalletMeta.table}(${WalletMeta.id}),
    CHECK (${TransferMeta.sourceWalletId} != ${TransferMeta.destinationWalletId})
  )''');
  await db.execute('''CREATE TABLE IF NOT EXISTS ${QuickTemplateMeta.table} (
    ${QuickTemplateMeta.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${QuickTemplateMeta.name} TEXT NOT NULL,
    ${QuickTemplateMeta.type} TEXT NOT NULL CHECK (${QuickTemplateMeta.type} IN ('income','expense')),
    ${QuickTemplateMeta.amount} INTEGER NOT NULL CHECK (${QuickTemplateMeta.amount} > 0),
    ${QuickTemplateMeta.categoryId} INTEGER NOT NULL,
    ${QuickTemplateMeta.walletId} INTEGER NOT NULL,
    ${QuickTemplateMeta.createdAt} TEXT NOT NULL,
    ${QuickTemplateMeta.updatedAt} TEXT NOT NULL,
    FOREIGN KEY (${QuickTemplateMeta.walletId}) REFERENCES ${WalletMeta.table}(${WalletMeta.id})
  )''');
  final columns = <String, String>{
    IncomeMeta.nameTable: IncomeMeta.walletId,
    ExpenseMeta.nameTable: ExpenseMeta.walletId,
  };
  for (final entry in columns.entries) {
    final present = (await db.rawQuery('PRAGMA table_info("${entry.key}")'))
        .any((column) => column['name'] == entry.value);
    if (!present) {
      await db.execute(
          'ALTER TABLE ${entry.key} ADD COLUMN ${entry.value} INTEGER NOT NULL DEFAULT 1');
    }
  }
  final now = DateTime.now().toUtc().toIso8601String();
  await db.insert(
      WalletMeta.table,
      {
        WalletMeta.id: 1,
        WalletMeta.name: 'Cash',
        WalletMeta.type: 'cash',
        WalletMeta.openingBalance: 0,
        WalletMeta.currency: 'IDR',
        WalletMeta.archived: 0,
        WalletMeta.isDefault: 1,
        WalletMeta.createdAt: now,
        WalletMeta.updatedAt: now,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore);
  await db.execute(
      'UPDATE ${IncomeMeta.nameTable} SET ${IncomeMeta.walletId}=1 WHERE ${IncomeMeta.walletId} IS NULL');
  await db.execute(
      'UPDATE ${ExpenseMeta.nameTable} SET ${ExpenseMeta.walletId}=1 WHERE ${ExpenseMeta.walletId} IS NULL');
}

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
  "🙂 Health, Beauty, & Wellbeing",
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

/// Schema v2: keep legacy major-unit columns for compatibility, while
/// persisting exact integer hundredths as the canonical monetary values.
Future<void> migrateMoneyColumns(Database db) async {
  final columns = <List<String>>[
    [IncomeMeta.nameTable, IncomeMeta.amount, IncomeMeta.amountMinor],
    [ExpenseMeta.nameTable, ExpenseMeta.amount, ExpenseMeta.amountMinor],
    [GoalMeta.nameTable, GoalMeta.target, GoalMeta.targetMinor],
    [GoalMeta.nameTable, GoalMeta.collected, GoalMeta.collectedMinor],
    [
      GoalSavingMeta.nameTable,
      GoalSavingMeta.amount,
      GoalSavingMeta.amountMinor,
    ],
    [RecurringMeta.nameTable, RecurringMeta.amount, RecurringMeta.amountMinor],
  ];
  for (final column in columns) {
    final table = column[0];
    final legacy = column[1];
    final minor = column[2];
    await db.execute(
      'ALTER TABLE $table ADD COLUMN $minor INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'UPDATE $table SET $minor = CAST(ROUND(COALESCE($legacy, 0) * 100) AS INTEGER)',
    );
  }
}
