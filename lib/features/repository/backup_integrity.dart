import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/static_name_table.dart';

/// Firebase Storage custom metadata travels with the SQLite snapshot.
class BackupManifest {
  const BackupManifest({
    required this.ownerUid,
    required this.schemaVersion,
    required this.snapshotAt,
    required this.sha256Digest,
  });

  final String ownerUid;
  final int schemaVersion;
  final DateTime snapshotAt;
  final String sha256Digest;

  Map<String, String> toMetadata() => {
    'owner_uid': ownerUid,
    'schema_version': schemaVersion.toString(),
    'snapshot_at': snapshotAt.toUtc().toIso8601String(),
    'sha256': sha256Digest,
  };

  /// Null indicates a legacy backup without metadata, rather than an
  /// authenticated manifest. A partially present manifest is rejected.
  static BackupManifest? fromMetadata(Map<String, String>? metadata) {
    if (metadata == null || metadata.isEmpty) return null;
    const requiredKeys = [
      'owner_uid', 'schema_version', 'snapshot_at', 'sha256',
    ];
    if (requiredKeys.every((key) => !metadata.containsKey(key))) return null;
    if (requiredKeys.any((key) => !metadata.containsKey(key))) {
      throw const FormatException('Incomplete backup manifest.');
    }
    final owner = metadata['owner_uid']!;
    final version = int.tryParse(metadata['schema_version']!);
    final when = DateTime.tryParse(metadata['snapshot_at']!);
    final hash = metadata['sha256']!;
    if (owner.isEmpty || version == null || when == null ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(hash)) {
      throw const FormatException('Invalid backup manifest.');
    }
    return BackupManifest(
      ownerUid: owner,
      schemaVersion: version,
      snapshotAt: when.toUtc(),
      sha256Digest: hash,
    );
  }
}

Future<String> sqliteFileSha256(File file) async =>
    (await sha256.bind(file.openRead()).first).toString();

/// Validate the *application* schema, not just SQLite file integrity.
/// v1 legacy backups are allowed for migration to v2 on successful restore.
Future<int> validateClingBackupSchema(Database database) async {
  final integrity = await database.rawQuery('PRAGMA integrity_check');
  if (integrity.isEmpty || integrity.first.values.first != 'ok') {
    throw const FormatException('SQLite backup failed integrity_check.');
  }
  final rows = await database.rawQuery('PRAGMA user_version');
  final version = (rows.first['user_version'] as num).toInt();
  if (version != 1 && version != 2) {
    throw FormatException('Unsupported Cling schema version: $version');
  }
  final columns = <String, List<String>>{
    IncomeMeta.nameTable: [
      IncomeMeta.id, IncomeMeta.date, IncomeMeta.amount,
      IncomeMeta.idIncomeSource,
      if (version >= 2) IncomeMeta.amountMinor,
    ],
    ExpenseMeta.nameTable: [
      ExpenseMeta.id, ExpenseMeta.date, ExpenseMeta.amount,
      ExpenseMeta.idCategories,
      if (version >= 2) ExpenseMeta.amountMinor,
    ],
    GoalMeta.nameTable: [
      GoalMeta.id, GoalMeta.target, GoalMeta.collected,
      if (version >= 2) GoalMeta.targetMinor,
      if (version >= 2) GoalMeta.collectedMinor,
    ],
    GoalSavingMeta.nameTable: [
      GoalSavingMeta.id, GoalSavingMeta.idGoal, GoalSavingMeta.amount,
      if (version >= 2) GoalSavingMeta.amountMinor,
    ],
    RecurringMeta.nameTable: [
      RecurringMeta.id, RecurringMeta.recurringDay,
      RecurringMeta.recurringLast, RecurringMeta.amount,
      if (version >= 2) RecurringMeta.amountMinor,
    ],
    NotificationMeta.nameTable: [
      NotificationMeta.id, NotificationMeta.date, NotificationMeta.isRead,
    ],
    IncomeSourceMeta.nameTable: [
      IncomeSourceMeta.id, IncomeSourceMeta.incomeSource,
    ],
    ExpenseCategoriesMeta.nameTable: [
      ExpenseCategoriesMeta.id, ExpenseCategoriesMeta.expenseCategories,
    ],
  };

  for (final entry in columns.entries) {
    final tableInfo = await database.rawQuery('PRAGMA table_info("${entry.key}")');
    final available = tableInfo.map((row) => row['name']).toSet();
    if (tableInfo.isEmpty ||
        entry.value.any((requiredName) => !available.contains(requiredName))) {
      throw FormatException('Invalid or incomplete Cling table: ${entry.key}');
    }
  }
  return version;
}

/// Restore needs a second explicit confirmation when the cloud snapshot
/// predates local financial activity (or legacy metadata cannot establish it).
class RestoreConflictException implements Exception {
  const RestoreConflictException(this.reason);
  final String reason;
  @override
  String toString() => reason;
}
