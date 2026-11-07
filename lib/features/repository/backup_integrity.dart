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
    this.dataLastModifiedAt,
  });

  final String ownerUid;
  final int schemaVersion;
  final DateTime snapshotAt;
  final String sha256Digest;

  /// Last financial change recorded inside this exact snapshot, if present.
  final DateTime? dataLastModifiedAt;

  Map<String, String> toMetadata() => {
        'owner_uid': ownerUid,
        'schema_version': schemaVersion.toString(),
        'snapshot_at': snapshotAt.toUtc().toIso8601String(),
        'sha256': sha256Digest,
        if (dataLastModifiedAt != null)
          'data_modified_at': dataLastModifiedAt!.toUtc().toIso8601String(),
      };

  /// Empty metadata is allowed only for legacy single-file backups.
  /// Incomplete modern manifests are always rejected.
  static BackupManifest? fromMetadata(Map<String, String>? metadata) {
    if (metadata == null || metadata.isEmpty) return null;
    const keys = ['owner_uid', 'schema_version', 'snapshot_at', 'sha256'];
    if (keys.every((key) => !metadata.containsKey(key))) return null;
    if (keys.any((key) => !metadata.containsKey(key))) {
      throw const FormatException('Incomplete backup manifest.');
    }
    final uid = metadata['owner_uid']!;
    final version = int.tryParse(metadata['schema_version']!);
    final captured = DateTime.tryParse(metadata['snapshot_at']!);
    final digest = metadata['sha256']!;
    final modifiedText = metadata['data_modified_at'];
    final modified =
        modifiedText == null ? null : DateTime.tryParse(modifiedText)?.toUtc();
    final validDigest =
        digest.length == 64 && !digest.contains(RegExp(r'[^0-9a-f]'));
    if (uid.isEmpty ||
        version == null ||
        captured == null ||
        !validDigest ||
        (modifiedText != null && modified == null)) {
      throw const FormatException('Invalid backup manifest.');
    }
    return BackupManifest(
      ownerUid: uid,
      schemaVersion: version,
      snapshotAt: captured.toUtc(),
      sha256Digest: digest,
      dataLastModifiedAt: modified,
    );
  }
}

Future<String> sqliteFileSha256(File file) async =>
    (await sha256.bind(file.openRead()).first).toString();

/// Validate the *application* schema, not just SQLite file integrity.
/// Legacy v1/v2 backups remain supported and migrate on successful restore.
Future<int> validateClingBackupSchema(Database database) async {
  final integrity = await database.rawQuery('PRAGMA integrity_check');
  if (integrity.isEmpty || integrity.first.values.first != 'ok') {
    throw const FormatException('SQLite backup failed integrity_check.');
  }
  final rows = await database.rawQuery('PRAGMA user_version');
  final version = (rows.first['user_version'] as num).toInt();
  if (version < 1 || version > 4) {
    throw FormatException('Unsupported Cling schema version: $version');
  }
  final columns = <String, List<String>>{
    IncomeMeta.nameTable: [
      IncomeMeta.id,
      IncomeMeta.date,
      IncomeMeta.amount,
      IncomeMeta.idIncomeSource,
      if (version >= 2) IncomeMeta.amountMinor,
      if (version >= 3) IncomeMeta.walletId,
    ],
    ExpenseMeta.nameTable: [
      ExpenseMeta.id,
      ExpenseMeta.date,
      ExpenseMeta.amount,
      ExpenseMeta.idCategories,
      if (version >= 2) ExpenseMeta.amountMinor,
      if (version >= 3) ExpenseMeta.walletId,
    ],
    GoalMeta.nameTable: [
      GoalMeta.id,
      GoalMeta.target,
      GoalMeta.collected,
      if (version >= 2) GoalMeta.targetMinor,
      if (version >= 2) GoalMeta.collectedMinor,
    ],
    GoalSavingMeta.nameTable: [
      GoalSavingMeta.id,
      GoalSavingMeta.idGoal,
      GoalSavingMeta.amount,
      if (version >= 2) GoalSavingMeta.amountMinor,
    ],
    RecurringMeta.nameTable: [
      RecurringMeta.id,
      RecurringMeta.recurringDay,
      RecurringMeta.recurringLast,
      RecurringMeta.amount,
      if (version >= 2) RecurringMeta.amountMinor,
    ],
    NotificationMeta.nameTable: [
      NotificationMeta.id,
      NotificationMeta.date,
      NotificationMeta.isRead,
    ],
    IncomeSourceMeta.nameTable: [
      IncomeSourceMeta.id,
      IncomeSourceMeta.incomeSource,
    ],
    ExpenseCategoriesMeta.nameTable: [
      ExpenseCategoriesMeta.id,
      ExpenseCategoriesMeta.expenseCategories,
    ],
  };

  if (version >= 3) {
    columns[WalletMeta.table] = [
      WalletMeta.id,
      WalletMeta.name,
      WalletMeta.type,
      WalletMeta.openingBalance,
      WalletMeta.currency,
      WalletMeta.archived,
      WalletMeta.isDefault
    ];
    columns[TransferMeta.table] = [
      TransferMeta.id,
      TransferMeta.sourceWalletId,
      TransferMeta.destinationWalletId,
      TransferMeta.amount,
      TransferMeta.date
    ];
    columns[QuickTemplateMeta.table] = [
      QuickTemplateMeta.id,
      QuickTemplateMeta.name,
      QuickTemplateMeta.type,
      QuickTemplateMeta.amount,
      QuickTemplateMeta.categoryId,
      QuickTemplateMeta.walletId
    ];
  }

  if (version >= 4) {
    final foreignKeyErrors =
        await database.rawQuery('PRAGMA foreign_key_check');
    if (foreignKeyErrors.isNotEmpty) {
      throw const FormatException(
          'SQLite backup contains broken foreign keys.');
    }
    columns[RecurringExpenseMeta.table] = [
      RecurringExpenseMeta.id,
      RecurringExpenseMeta.name,
      RecurringExpenseMeta.amount,
      RecurringExpenseMeta.categoryId,
      RecurringExpenseMeta.walletId,
      RecurringExpenseMeta.frequency,
      RecurringExpenseMeta.scheduledDay,
      RecurringExpenseMeta.startDate,
      RecurringExpenseMeta.nextDate,
      RecurringExpenseMeta.enabled,
      RecurringExpenseMeta.postingMode,
    ];
    columns[RecurringExpenseOccurrenceMeta.table] = [
      RecurringExpenseOccurrenceMeta.id,
      RecurringExpenseOccurrenceMeta.ruleId,
      RecurringExpenseOccurrenceMeta.scheduledDate,
      RecurringExpenseOccurrenceMeta.amount,
      RecurringExpenseOccurrenceMeta.status,
    ];
    columns[BillMeta.table] = [
      BillMeta.id,
      BillMeta.title,
      BillMeta.amount,
      BillMeta.categoryId,
      BillMeta.walletId,
      BillMeta.dueDate,
      BillMeta.expenseId,
    ];
    columns[PlanningMeta.table] = [PlanningMeta.key, PlanningMeta.value];
    columns[PlanningReminderMeta.table] = [
      PlanningReminderMeta.id,
      PlanningReminderMeta.reminderDays,
      PlanningReminderMeta.scheduledDate,
      PlanningReminderMeta.deliveredAt,
    ];
  }

  for (final entry in columns.entries) {
    final tableInfo =
        await database.rawQuery('PRAGMA table_info("${entry.key}")');
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
