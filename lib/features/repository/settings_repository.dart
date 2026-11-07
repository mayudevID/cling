import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
// ignore: depend_on_referenced_packages

import 'database_repository.dart';
import 'backup_integrity.dart';

class CloudBackupRecord {
  const CloudBackupRecord({
    required this.storagePath,
    required this.manifest,
    this.uploadedAt,
  });
  final String storagePath;
  final BackupManifest? manifest;
  final DateTime? uploadedAt;

  DateTime get sortAt =>
      manifest?.dataLastModifiedAt ??
      manifest?.snapshotAt ??
      uploadedAt ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

class LocalRecoverySnapshot {
  const LocalRecoverySnapshot({
    required this.path,
    required this.createdAt,
    required this.sizeBytes,
  });
  final String path;
  final DateTime createdAt;
  final int sizeBytes;
}

class SettingsRepository {
  SettingsRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage firebaseStorage,
    required SharedPreferences cache,
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        _cache = cache,
        _firestore = firestore,
        _firebaseStorage = firebaseStorage,
        _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final SharedPreferences _cache;
  final DatabaseRepository _databaseRepository;

  static const userCacheKey = '__user_cache_key__';
  static const languagePrefsKey = '__language_prefs__';
  static const currencyPrefsKey = '__currency_prefs__';

  // UserModel? get currentUserModel {
  //   final getData = _cache.getString(userCacheKey);
  //   if (getData != null) {
  //     return userModelFromMap(getData);
  //   }
  //   return null;
  // }

  Future<void> saveLangSettings(String langCode) async {
    await _cache.setString(languagePrefsKey, langCode);
  }

  String? getCurrentLang() {
    return _cache.getString(languagePrefsKey);
  }

  Future<void> saveCurrencySettings(String countryCode) async {
    await _cache.setString(currencyPrefsKey, countryCode);
  }

  String? getCurrentCurrency() {
    return _cache.getString(currencyPrefsKey);
  }

  static String _pendingMonthlyKey(String uid) =>
      '__pending_monthly_settings_$uid';

  /// Firestore is the desired state; SQLite is a retryable local projection.
  /// Always reconcile from a fresh server document before generating income.
  Future<UserModel> reconcileCurrentAccountSettingsFromServer() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null ||
        uid != _databaseRepository.activeUserId ||
        !_databaseRepository.isReady) {
      throw StateError('Account database is not ready for reconciliation.');
    }
    final revision = _databaseRepository.revision;
    final remote = await _firestore.collection('users').doc(uid).get(
          const GetOptions(source: Source.server),
        );
    if (_firebaseAuth.currentUser?.uid != uid ||
        _databaseRepository.activeUserId != uid ||
        revision != _databaseRepository.revision) {
      throw StateError('Account changed during settings reconciliation.');
    }
    final data = remote.data();
    if (data == null) throw StateError('Account settings were not found.');
    final user = UserModel.fromMap(data);
    if (user.uid != uid) throw StateError('Profile UID does not match.');
    await _databaseRepository.syncMonthlyIncomeRule(
      recurringDay: user.recurringDay,
      amount: user.monthlyIncome,
    );
    await _cache.setString(userCacheKey, userModelToMap(user));
    await _cache.remove(_pendingMonthlyKey(uid));
    return user;
  }

  Future<void> saveMonthlyBudgetAndIncome({
    required UserModel userModel,
    double? monthlyIncome,
    double? monthlyBudget,
    int? recurringDay,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null ||
        uid != userModel.uid ||
        uid != _databaseRepository.activeUserId ||
        !_databaseRepository.isReady) {
      throw StateError('Finance database does not match signed-in user.');
    }

    final monIncomeNew = monthlyIncome ?? userModel.monthlyIncome;
    final monBudgetNew = monthlyBudget ?? userModel.monthlyBudget;
    final recurringNew = recurringDay ?? userModel.recurringDay;
    if (!monIncomeNew.isFinite ||
        monIncomeNew < 0 ||
        !monBudgetNew.isFinite ||
        monBudgetNew < 0 ||
        recurringNew < 0 ||
        recurringNew > 31) {
      throw const FormatException('Invalid monthly income, budget or payday.');
    }

    final now = DateTime.now();
    final updated = userModel.copyWith(
      monthlyBudget: monBudgetNew,
      monthlyIncome: monIncomeNew,
      recurringDay: recurringNew,
      updatedAt: now,
    );

    // The remote write is authoritative. If the app exits immediately after
    // this succeeds, the next launch fetches the new desired state.
    final revision = _databaseRepository.revision;
    await _firestore.collection('users').doc(uid).update({
      'monthly_income': monIncomeNew,
      'monthly_budget': monBudgetNew,
      'recurring_day': recurringNew,
      'updated_at': now.toIso8601String(),
    });
    if (_firebaseAuth.currentUser?.uid != uid ||
        _databaseRepository.activeUserId != uid ||
        revision != _databaseRepository.revision) {
      throw StateError('Account changed during monthly settings save.');
    }

    // A failed local write leaves an explicit retry marker. Only clear it
    // after both local reconciliation and cache persistence succeed.
    final hadPendingReconciliation =
        _cache.containsKey(_pendingMonthlyKey(uid));
    await _cache.setString(_pendingMonthlyKey(uid), userModelToMap(updated));
    if (monthlyIncome != null ||
        recurringDay != null ||
        hadPendingReconciliation) {
      await _databaseRepository.syncMonthlyIncomeRule(
        recurringDay: recurringNew,
        amount: monIncomeNew,
      );
    }
    await _cache.setString(userCacheKey, userModelToMap(updated));
    await _cache.remove(_pendingMonthlyKey(uid));
  }

  Future<DateTime> editBackupTime({required UserModel userModel}) async {
    final userData = userModel;
    final now = DateTime.now();

    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "last_backup_time": now.toIso8601String(),
    });

    final newUserData = userData.copyWith(lastBackupTime: now);

    await _cache.setString(
      userCacheKey,
      userModelToMap(newUserData),
    );

    return now;
  }

  Future<void> editProfileName({required String newName}) async {
    await _firebaseAuth.currentUser!.updateDisplayName(newName);
    await _firebaseAuth.currentUser!.reload();
  }

  Future<void> editProfileEmail({required String newEmail}) async {
    await _firebaseAuth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    await _firebaseAuth.currentUser!.reload();
    await Future.delayed(const Duration(milliseconds: 150));
    await _firebaseAuth.currentUser!.sendEmailVerification();
    await _firebaseAuth.currentUser!.reload();
  }

  String _requireAccount() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null ||
        !_databaseRepository.isReady ||
        _databaseRepository.activeUserId != uid) {
      throw StateError('Account and local database are not synchronized.');
    }
    return uid;
  }

  void _assertAccount(String uid, int revision) {
    if (_firebaseAuth.currentUser?.uid != uid ||
        !_databaseRepository.isReady ||
        _databaseRepository.activeUserId != uid ||
        _databaseRepository.revision != revision) {
      throw StateError('Account changed while processing a backup.');
    }
  }

  /// Every upload gets a unique immutable path. A stale second device
  /// cannot replace a newer backup produced by the first device.
  Future<void> backupData() async {
    final uid = _requireAccount();
    final revision = _databaseRepository.revision;
    // This is a lower bound on the snapshot's capture time. A transaction
    // committed while VACUUM INTO runs will never be mistaken as older.
    final captureStartedAt = DateTime.now().toUtc();
    final file = File(
      '${await _databaseRepository.databasePath}.snapshot_'
      '${captureStartedAt.microsecondsSinceEpoch}.db',
    );
    try {
      await _databaseRepository.createBackupSnapshot(file.path);
      final snapshot = await openDatabase(
        file.path,
        readOnly: true,
        singleInstance: false,
      );
      late int schema;
      DateTime? dataModifiedAt;
      try {
        schema = await validateClingBackupSchema(snapshot);
        final meta = await snapshot.rawQuery(
          "SELECT value FROM finance_meta WHERE key = 'last_modified_at' LIMIT 1",
        );
        if (meta.isNotEmpty) {
          dataModifiedAt = DateTime.tryParse(
            meta.first['value'] as String,
          )?.toUtc();
        }
      } finally {
        await snapshot.close();
      }
      final manifest = BackupManifest(
        ownerUid: uid,
        schemaVersion: schema,
        snapshotAt: captureStartedAt,
        dataLastModifiedAt: dataModifiedAt,
        sha256Digest: await sqliteFileSha256(file),
      );
      _assertAccount(uid, revision);
      final id = '${captureStartedAt.microsecondsSinceEpoch}_'
          '${manifest.sha256Digest.substring(0, 12)}.db';
      final ref = _firebaseStorage.ref('backupDb/$uid/snapshots/$id');
      await ref.putFile(
        file,
        SettableMetadata(customMetadata: manifest.toMetadata()),
      );
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  Future<List<CloudBackupRecord>> listCloudBackups() async {
    final uid = _requireAccount();
    final result = <CloudBackupRecord>[];
    final root = _firebaseStorage.ref('backupDb/$uid/snapshots');
    List<Reference> snapshots = [];
    try {
      snapshots = (await root.listAll()).items;
    } on FirebaseException catch (error) {
      // Older Storage rules may permit reading backupDb/<uid>.db but not
      // listing the new path. Keep legacy restore available during rollout.
      const legacyListErrors = {
        'unauthorized',
        'permission-denied',
        'object-not-found',
      };
      if (!legacyListErrors.contains(error.code)) rethrow;
    }
    for (final entry in snapshots) {
      final meta = await entry.getMetadata();
      final manifest = BackupManifest.fromMetadata(meta.customMetadata);
      if (manifest == null || manifest.ownerUid != uid) {
        throw const FormatException('Untrusted cloud snapshot metadata.');
      }
      result.add(
        CloudBackupRecord(
          storagePath: entry.fullPath,
          manifest: manifest,
          uploadedAt: meta.timeCreated,
        ),
      );
    }

    // Read old single-file backups without allowing new writes to overwrite
    // them. The first successful versioned backup does not delete this file.
    final legacy = _firebaseStorage.ref('backupDb/$uid.db');
    try {
      final meta = await legacy.getMetadata();
      final manifest = BackupManifest.fromMetadata(meta.customMetadata);
      if (manifest != null && manifest.ownerUid != uid) {
        throw const FormatException('Legacy backup belongs to another user.');
      }
      result.add(
        CloudBackupRecord(
          storagePath: legacy.fullPath,
          manifest: manifest,
          uploadedAt: meta.timeCreated,
        ),
      );
    } on FirebaseException catch (error) {
      if (error.code != 'object-not-found') rethrow;
    }
    result.sort((a, b) => b.sortAt.compareTo(a.sortAt));
    return result;
  }

  /// Discover the account's durable, locally retained before-restore files.
  Future<List<LocalRecoverySnapshot>> listLocalRecoverySnapshots() async {
    _requireAccount();
    final path = await _databaseRepository.databasePath;
    final prefix = '$path.before_restore_';
    final entries = <LocalRecoverySnapshot>[];
    await for (final entry in File(path).parent.list()) {
      if (entry is! File ||
          !entry.path.startsWith(prefix) ||
          !entry.path.endsWith('.db')) {
        continue;
      }
      final suffix = entry.path.substring(
        prefix.length,
        entry.path.length - '.db'.length,
      );
      final microseconds = int.tryParse(suffix);
      if (microseconds == null) continue;
      entries.add(
        LocalRecoverySnapshot(
          path: entry.path,
          createdAt: DateTime.fromMicrosecondsSinceEpoch(
            microseconds,
            isUtc: true,
          ),
          sizeBytes: await entry.length(),
        ),
      );
    }
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> deleteLocalRecoverySnapshot(String path) async {
    final files = await listLocalRecoverySnapshots();
    if (!files.any((candidate) => candidate.path == path)) {
      throw ArgumentError.value(path, 'path', 'Unknown recovery snapshot');
    }
    await File(path).delete();
  }

  Future<int> _validateStagedBackup(
    File staging, {
    BackupManifest? manifest,
  }) async {
    if (manifest != null &&
        await sqliteFileSha256(staging) != manifest.sha256Digest) {
      throw const FormatException('Snapshot checksum does not match.');
    }
    final validation = await openDatabase(
      staging.path,
      readOnly: true,
      singleInstance: false,
    );
    try {
      final schema = await validateClingBackupSchema(validation);
      if (manifest != null && manifest.schemaVersion != schema) {
        throw const FormatException('Snapshot schema mismatch.');
      }
      return schema;
    } finally {
      await validation.close();
    }
  }

  /// The caller must explicitly confirm replacing a more recent local DB.
  /// The original data is always preserved in a separate recovery snapshot.
  Future<void> _applyStagedBackup(
    File staging, {
    DateTime? capturedAt,
    required bool allowOverwriteNewerLocal,
  }) async {
    final uid = _requireAccount();
    final revision = _databaseRepository.revision;
    final databaseFile = File(await _databaseRepository.databasePath);
    final rollback = File('${databaseFile.path}.rollback');
    final hasLocal = await _databaseRepository.hasFinancialRecords();
    final localModified = await _databaseRepository.lastFinanceChangeAt();
    if (hasLocal &&
        !allowOverwriteNewerLocal &&
        (capturedAt == null ||
            localModified == null ||
            localModified.isAfter(capturedAt))) {
      throw const RestoreConflictException(
        'Local finance records may be newer than the snapshot.',
      );
    }
    if (hasLocal) {
      final recoveryPath = '${databaseFile.path}.before_restore_'
          '${DateTime.now().toUtc().microsecondsSinceEpoch}.db';
      await _databaseRepository.createBackupSnapshot(recoveryPath);
    }
    _assertAccount(uid, revision);

    var originalMoved = false;
    var newMoved = false;
    try {
      await _databaseRepository.close();
      if (await rollback.exists()) await rollback.delete();
      if (await databaseFile.exists()) {
        await databaseFile.rename(rollback.path);
        originalMoved = true;
      }
      await staging.rename(databaseFile.path);
      newMoved = true;
      await _databaseRepository.open(recoverRollback: false);
      if (await rollback.exists()) await rollback.delete();
    } catch (_) {
      if (originalMoved || newMoved) {
        await _databaseRepository.close();
        if (newMoved && await databaseFile.exists()) {
          await databaseFile.delete();
        }
        if (originalMoved && await rollback.exists()) {
          await rollback.rename(databaseFile.path);
        }
        await _databaseRepository.open();
      }
      rethrow;
    }
  }

  Future<void> getBackup({
    bool allowOverwriteNewerLocal = false,
    String? storagePath,
  }) async {
    final uid = _requireAccount();
    final choices = await listCloudBackups();
    if (choices.isEmpty) throw StateError('No cloud backup found');
    final backup = storagePath == null
        ? choices.first
        : choices.firstWhere(
            (item) => item.storagePath == storagePath,
            orElse: () => throw ArgumentError.value(
              storagePath,
              'storagePath',
              'Unrecognized cloud backup',
            ),
          );
    final revision = _databaseRepository.revision;
    final dbPath = await _databaseRepository.databasePath;
    final staging = File('$dbPath.restore_'
        '${DateTime.now().toUtc().microsecondsSinceEpoch}.db');
    try {
      await _firebaseStorage.ref(backup.storagePath).writeToFile(staging);
      await _validateStagedBackup(staging, manifest: backup.manifest);
      _assertAccount(uid, revision);
      await _applyStagedBackup(
        staging,
        capturedAt: backup.manifest?.snapshotAt,
        allowOverwriteNewerLocal: allowOverwriteNewerLocal,
      );
    } finally {
      if (await staging.exists()) await staging.delete();
    }
  }

  Future<void> restoreLocalRecoverySnapshot(
    String recoveryPath, {
    bool allowOverwriteNewerLocal = false,
  }) async {
    _requireAccount();
    final snapshots = await listLocalRecoverySnapshots();
    if (!snapshots.any((record) => record.path == recoveryPath)) {
      throw ArgumentError.value(
        recoveryPath,
        'recoveryPath',
        'Snapshot does not belong to this account',
      );
    }
    final dbPath = await _databaseRepository.databasePath;
    final staging = File('$dbPath.restore_'
        '${DateTime.now().toUtc().microsecondsSinceEpoch}.db');
    try {
      await File(recoveryPath).copy(staging.path);
      await _validateStagedBackup(staging);
      await _applyStagedBackup(
        staging,
        allowOverwriteNewerLocal: allowOverwriteNewerLocal,
      );
    } finally {
      if (await staging.exists()) await staging.delete();
    }
  }
}
