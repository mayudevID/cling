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
    if (uid == null || uid != _databaseRepository.activeUserId ||
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
    if (uid == null || uid != userModel.uid ||
        uid != _databaseRepository.activeUserId ||
        !_databaseRepository.isReady) {
      throw StateError('Finance database does not match signed-in user.');
    }

    final monIncomeNew = monthlyIncome ?? userModel.monthlyIncome;
    final monBudgetNew = monthlyBudget ?? userModel.monthlyBudget;
    final recurringNew = recurringDay ?? userModel.recurringDay;
    if (!monIncomeNew.isFinite || monIncomeNew < 0 ||
        !monBudgetNew.isFinite || monBudgetNew < 0 ||
        recurringNew < 0 || recurringNew > 31) {
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
    final hadPendingReconciliation = _cache.containsKey(_pendingMonthlyKey(uid));
    await _cache.setString(_pendingMonthlyKey(uid), userModelToMap(updated));
    if (monthlyIncome != null || recurringDay != null ||
        hadPendingReconciliation) {
      await _databaseRepository.syncMonthlyIncomeRule(
        recurringDay: recurringNew, amount: monIncomeNew,
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

  /// Snapshot and upload data with owner, schema and SHA-256 metadata.
  Future<void> backupData() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || !_databaseRepository.isReady ||
        _databaseRepository.activeUserId != uid) {
      throw StateError('Sign in to the correct account before backing up.');
    }
    final revision = _databaseRepository.revision;
    final snapshot = File(
      '${await _databaseRepository.databasePath}.snapshot_'
      '${DateTime.now().toUtc().microsecondsSinceEpoch}.db',
    );
    try {
      await _databaseRepository.createBackupSnapshot(snapshot.path);
      final schemaRows = await _databaseRepository.db.rawQuery(
        'PRAGMA user_version');
      final schema = (schemaRows.first['user_version'] as num).toInt();
      final manifest = BackupManifest(
        ownerUid: uid,
        schemaVersion: schema,
        snapshotAt: DateTime.now().toUtc(),
        sha256Digest: await sqliteFileSha256(snapshot),
      );
      if (_firebaseAuth.currentUser?.uid != uid ||
          _databaseRepository.activeUserId != uid ||
          revision != _databaseRepository.revision) {
        throw StateError('Account switched during snapshot creation.');
      }
      final ref = _firebaseStorage.ref('backupDb/$uid.db');
      await ref.putFile(snapshot, SettableMetadata(
        customMetadata: manifest.toMetadata(),
      ));
    } finally {
      if (await snapshot.exists()) await snapshot.delete();
    }
  }

  /// A cloud restore is rejected if an existing local database was modified
  /// after the snapshot (or its age is unknown), unless the user explicitly
  /// confirms replacement. A durable before-restore copy is always kept.
  Future<void> getBackup({bool allowOverwriteNewerLocal = false}) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || _databaseRepository.activeUserId != uid ||
        !_databaseRepository.isReady) {
      throw StateError('Account database mismatch during restore.');
    }
    final revision = _databaseRepository.revision;
    final databaseFile = File(await _databaseRepository.databasePath);
    final staging = File('${databaseFile.path}.restore');
    final rollback = File('${databaseFile.path}.rollback');
    var originalMoved = false;
    var newMoved = false;
    try {
      if (await staging.exists()) await staging.delete();
      final ref = _firebaseStorage.ref('backupDb/$uid.db');
      final storageInfo = await ref.getMetadata();
      final manifest = BackupManifest.fromMetadata(storageInfo.customMetadata);
      if (manifest != null && manifest.ownerUid != uid) {
        throw const FormatException('Backup belongs to a different account.');
      }
      await ref.writeToFile(staging);
      if (manifest != null &&
          await sqliteFileSha256(staging) != manifest.sha256Digest) {
        throw const FormatException('Backup SHA-256 does not match manifest.');
      }

      final validation = await openDatabase(
        staging.path, readOnly: true, singleInstance: false);
      late int version;
      try {
        version = await validateClingBackupSchema(validation);
      } finally {
        await validation.close();
      }
      if (manifest != null && manifest.schemaVersion != version) {
        throw const FormatException('Backup manifest schema version mismatch.');
      }

      if (_firebaseAuth.currentUser?.uid != uid ||
          _databaseRepository.activeUserId != uid ||
          revision != _databaseRepository.revision) {
        throw StateError('Account changed during cloud restore.');
      }
      final hasLocal = await _databaseRepository.hasFinancialRecords();
      final localModified = await _databaseRepository.lastFinanceChangeAt();
      if (hasLocal && !allowOverwriteNewerLocal &&
          (manifest == null || localModified == null ||
           localModified.isAfter(manifest.snapshotAt))) {
        throw const RestoreConflictException(
          'Local financial records may be newer than this backup.');
      }

      // The last good on-device state remains recoverable even after a
      // *successful* cloud restore. Never automatically delete this snapshot.
      if (hasLocal) {
        final safeCopy = '${databaseFile.path}.before_restore_'
          '${DateTime.now().toUtc().microsecondsSinceEpoch}.db';
        await _databaseRepository.createBackupSnapshot(safeCopy);
      }

      if (_firebaseAuth.currentUser?.uid != uid ||
          _databaseRepository.activeUserId != uid ||
          revision != _databaseRepository.revision) {
        throw StateError('Account changed before database replacement.');
      }
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
    } finally {
      if (await staging.exists()) await staging.delete();
    }
  }

}
