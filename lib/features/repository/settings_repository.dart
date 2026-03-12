import 'dart:io';
import '../../core/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'database_repository.dart';

class SettingsRepository {

  SettingsRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage firebaseStorage,
    required SharedPreferences cache,
  })  : _cache = cache,
        _firestore = firestore,
        _firebaseStorage = firebaseStorage,
        _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final SharedPreferences _cache;

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

  Future<void> backupData() async {
    try {
      final pathDb = await getDatabasesPath();

      final File fileData = File(join(pathDb, DatabaseRepository.databaseName));
      final pathOld = fileData.path;
      final lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
      final newPath = pathOld.substring(0, lastSeparator + 1) +
          _firebaseAuth.currentUser!.uid;
      final newFileData = await fileData.copy('$newPath.db');
      Logger.White.log("Location DB: ${newFileData.path}");

      final path = basename(newFileData.path);
      final ref = _firebaseStorage.ref('backupDb/$path');

      final uploadTask = ref.putFile(newFileData);
      await uploadTask.whenComplete(() {});
      await newFileData.delete(recursive: true);
    } on FirebaseException catch (e) {
      Logger.Red.log(e);
      throw Exception();
    }
  }

  Future<void> getBackup() async {
    try {
      final pathDb = await getDatabasesPath();

      final dbRef =
          _firebaseStorage.ref('backupDb/${_firebaseAuth.currentUser!.uid}.db');

      final File fileNew = File(join(pathDb, DatabaseRepository.databaseName));
      await fileNew.delete();

      final downloadTask = dbRef.writeToFile(fileNew);
      await downloadTask.whenComplete(() {});
    } on FirebaseException catch (e) {
      Logger.Red.log(e);
      throw Exception(e.message);
    }
  }
}
