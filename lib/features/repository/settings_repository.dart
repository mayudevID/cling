import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
// ignore: depend_on_referenced_packages

import 'database_repository.dart';

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

  Future<void> saveMonthlyBudgetAndIncome({
    required UserModel userModel,
    double? monthlyIncome,
    double? monthlyBudget,
    int? recurringDay,
  }) async {
    final userData = userModel;

    final double monIncomeNew = monthlyIncome ?? userData.monthlyIncome;
    final double monBudgetNew = monthlyBudget ?? userData.monthlyBudget;
    final int recurringNew = recurringDay ?? userData.recurringDay;

    final now = DateTime.now();

    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "monthly_income": monIncomeNew,
      "monthly_budget": monBudgetNew,
      "recurring_day": recurringNew,
      "updated_at": now.toIso8601String(),
    });

    final newUserData = userData.copyWith(
      monthlyBudget: monBudgetNew,
      monthlyIncome: monIncomeNew,
      recurringDay: recurringNew,
      updatedAt: now,
    );

    await _cache.setString(
      userCacheKey,
      userModelToMap(newUserData),
    );
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

  /// Export a consistent SQLite snapshot; copying the live DB file can omit
  /// in-flight journal/WAL changes.
  Future<void> backupData() async {
    if (_firebaseAuth.currentUser == null) {
      throw StateError('Sign in before backing up data');
    }
    final snapshot = File('${await _databaseRepository.databasePath}.snapshot');
    try {
      await _databaseRepository.createBackupSnapshot(snapshot.path);
      final ref = _firebaseStorage.ref(
        'backupDb/${_firebaseAuth.currentUser!.uid}.db',
      );
      await ref.putFile(snapshot);
    } finally {
      if (await snapshot.exists()) await snapshot.delete();
    }
  }

  /// Download first, validate, then replace the closed database with rollback.
  /// A network failure must never remove the existing local database.
  Future<void> getBackup() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw StateError('Not authenticated');
    final databaseFile = File(await _databaseRepository.databasePath);
    final staging = File('${databaseFile.path}.restore');
    final rollback = File('${databaseFile.path}.rollback');
    var originalMoved = false;
    var newMoved = false;
    try {
      if (await staging.exists()) await staging.delete();
      final ref = _firebaseStorage.ref('backupDb/${user.uid}.db');
      await ref.writeToFile(staging);
      final validation = await openDatabase(staging.path, readOnly: true);
      try {
        final integrity = await validation.rawQuery('PRAGMA integrity_check');
        if (integrity.isEmpty || integrity.first.values.first != 'ok') {
          throw const FormatException('Corrupted backup');
        }
        final tables = await validation.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'",
        );
        final names = tables.map((e) => e['name']).toSet();
        if (!names.contains('income_table') ||
            !names.contains('expense_table') ||
            !names.contains('goal_meta') ||
            !names.contains('recurring_table')) {
          throw const FormatException('Invalid Cling database backup');
        }
      } finally {
        await validation.close();
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
