import 'dart:io';

import 'package:cling/core/init_database.dart';
import 'package:cling/core/static_name_table.dart';
import 'package:cling/features/repository/backup_integrity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('manifest round-trip preserves owner, timestamp and checksum', () {
    final when = DateTime.utc(2026, 11, 7, 7);
    const hash = 'ba7816bf8f01cfea414140de5dae2223b00361'
        'a396177a9cb410ff61f20015ad';
    final manifest = BackupManifest(
      ownerUid: 'user-A',
      schemaVersion: 2,
      snapshotAt: when,
      sha256Digest: hash,
    );
    final decoded = BackupManifest.fromMetadata(manifest.toMetadata());
    expect(decoded!.ownerUid, 'user-A');
    expect(decoded.schemaVersion, 2);
    expect(decoded.snapshotAt, when);
    expect(decoded.sha256Digest, hash);
    final withRevision = BackupManifest(
      ownerUid: 'user-A',
      schemaVersion: 2,
      snapshotAt: when,
      dataLastModifiedAt: when.subtract(const Duration(minutes: 5)),
      sha256Digest: hash,
    );
    final restored = BackupManifest.fromMetadata(withRevision.toMetadata());
    expect(
      restored!.dataLastModifiedAt,
      when.subtract(const Duration(minutes: 5)),
    );
    expect(BackupManifest.fromMetadata(null), isNull);
    expect(
      () => BackupManifest.fromMetadata({'owner_uid': 'user-A'}),
      throwsFormatException,
    );
  });

  test('streamed file checksum matches known SHA-256 digest', () async {
    final dir = await Directory.systemTemp.createTemp('cling_digest_');
    try {
      final file = File('${dir.path}/data.bin');
      await file.writeAsString('abc');
      expect(
          await sqliteFileSha256(file),
          'ba7816bf8f01cfea414140de5dae2223b00361'
          'a396177a9cb410ff61f20015ad');
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('both v1 and v2 Cling backups validate for safe migration', () async {
    final dir = await Directory.systemTemp.createTemp('cling_schema_');
    final path = '${dir.path}/backup.db';
    try {
      var database = await openDatabase(
        path,
        version: 1,
        onCreate: initDatabaseTable,
      );
      expect(await validateClingBackupSchema(database), 1);
      await database.close();
      database = await openDatabase(
        path,
        version: 2,
        onUpgrade: (db, old, next) async {
          await migrateMoneyColumns(db);
        },
      );
      expect(await validateClingBackupSchema(database), 2);
      await database.close();
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('schema v3 upgrades to v4 with planning tables and intact ledger',
      () async {
    final dir = await Directory.systemTemp.createTemp('cling_schema_v4_');
    final path = '${dir.path}/backup.db';
    try {
      var database = await openDatabase(
        path,
        version: 3,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys=ON');
        },
        onCreate: (db, version) async {
          await initDatabaseTable(db, version);
          await migrateMoneyColumns(db);
          await migrateFinancialFoundation(db);
        },
      );
      await database.insert(IncomeMeta.nameTable, {
        IncomeMeta.date: '2026-10-01T00:00:00.000',
        IncomeMeta.amount: 123.45,
        IncomeMeta.amountMinor: 12345,
        IncomeMeta.idIncomeSource: 0,
        IncomeMeta.walletId: 1,
      });
      await database.close();
      database = await openDatabase(
        path,
        version: 4,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys=ON');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 4) await migrateFinancialPlanning(db);
        },
      );
      expect(await validateClingBackupSchema(database), 4);
      final income = await database.query(IncomeMeta.nameTable);
      expect(income.single[IncomeMeta.amountMinor], 12345);
      expect(income.single[IncomeMeta.walletId], 1);
      expect(await database.query(RecurringExpenseMeta.table), isEmpty);
      expect(await database.query(BillMeta.table), isEmpty);
      expect(await database.rawQuery('PRAGMA foreign_key_check'), isEmpty);
      await database.close();
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('schema v2 upgrade preserves income and recurring income settings',
      () async {
    final dir =
        await Directory.systemTemp.createTemp('cling_schema_v2_upgrade_');
    final path = '${dir.path}/legacy.db';
    try {
      var database =
          await openDatabase(path, version: 2, onCreate: (db, version) async {
        await initDatabaseTable(db, version);
        await migrateMoneyColumns(db);
      });
      await database.insert(IncomeMeta.nameTable, {
        IncomeMeta.date: '2026-04-01T00:00:00.000',
        IncomeMeta.amount: 4500,
        IncomeMeta.amountMinor: 450000,
        IncomeMeta.idIncomeSource: 0,
      });
      await database.insert(RecurringMeta.nameTable, {
        RecurringMeta.idModel: 0,
        RecurringMeta.type: 0,
        RecurringMeta.recurringDay: 25,
        RecurringMeta.recurringLast: '2026-03-25',
        RecurringMeta.amount: 4500,
        RecurringMeta.amountMinor: 450000,
      });
      await database.close();
      database = await openDatabase(path, version: 4, onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys=ON');
      }, onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) await migrateFinancialFoundation(db);
        if (oldVersion < 4) await migrateFinancialPlanning(db);
      });
      expect(await validateClingBackupSchema(database), 4);
      final income = await database.query(IncomeMeta.nameTable);
      expect(income.single[IncomeMeta.amountMinor], 450000);
      expect(income.single[IncomeMeta.walletId], 1);
      final recurring = await database.query(RecurringMeta.nameTable);
      expect(recurring.single[RecurringMeta.amountMinor], 450000);
      expect(await database.query(BillMeta.table), isEmpty);
      expect(
          await database.query(RecurringExpenseOccurrenceMeta.table), isEmpty);
      await database.close();
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('backup with missing core tables is rejected', () async {
    final dir = await Directory.systemTemp.createTemp('cling_invalid_');
    try {
      final database = await openDatabase(
        '${dir.path}/invalid.db',
        version: 2,
        onCreate: (db, version) async {
          await db.execute('CREATE TABLE unrelated (id INTEGER)');
        },
      );
      await expectLater(
        validateClingBackupSchema(database),
        throwsFormatException,
      );
      await database.close();
    } finally {
      await dir.delete(recursive: true);
    }
  });
}
