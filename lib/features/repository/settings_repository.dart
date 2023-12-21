import 'dart:io';
import 'package:cling/core/logger.dart';
import 'package:cling/features/repository/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SettingsRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final SharedPreferences _cache;

  SettingsRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage firebaseStorage,
    required SharedPreferences cache,
  })  : _cache = cache,
        _firestore = firestore,
        _firebaseStorage = firebaseStorage,
        _firebaseAuth = firebaseAuth;

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
    int? monthlyIncome,
    int? monthlyBudget,
  }) async {
    final userData = userModel;

    int monIncomeNew = monthlyIncome ?? userData.monthlyIncome.toInt();
    int monBudgetNew = monthlyBudget ?? userData.monthlyBudget.toInt();

    final now = DateTime.now();

    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "monthly_income": monIncomeNew,
      "monthly_budget": monBudgetNew,
      "updated_at": now.toIso8601String(),
    });

    final newUserData = userData.copyWith(
      monthlyBudget: monBudgetNew.toDouble(),
      monthlyIncome: monIncomeNew.toDouble(),
      updatedAt: now,
    );

    await _cache.setString(
      userCacheKey,
      userModelToMap(newUserData),
    );
  }

  Future<DateTime> editBackupUrl({
    required String url,
    required UserModel userModel,
  }) async {
    final userData = userModel;
    final now = DateTime.now();

    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "backup_url": url,
      "last_backup_time": now.toIso8601String(),
    });

    final newUserData = userData.copyWith(
      backupUrl: url,
      lastBackupTime: now,
    );

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
    await _firebaseAuth.currentUser!.updateEmail(newEmail);
    await _firebaseAuth.currentUser!.reload();
    await Future.delayed(const Duration(milliseconds: 150));
    await _firebaseAuth.currentUser!.sendEmailVerification();
    await _firebaseAuth.currentUser!.reload();
  }

  Future<String> backupData() async {
    try {
      final pathDb = await getDatabasesPath();

      File fileData = File(join(pathDb, DatabaseRepository.databaseName));
      var pathOld = fileData.path;
      var lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
      var newPath = pathOld.substring(0, lastSeparator + 1) +
          _firebaseAuth.currentUser!.uid;
      final newFileData = await fileData.copy('$newPath.db');
      Logger.White.log("Location DB: ${newFileData.path}");

      final path = basename(newFileData.path);
      final ref = _firebaseStorage.ref('backupDb/$path');

      var uploadTask = ref.putFile(newFileData);
      final snapshotData = await uploadTask.whenComplete(() {});
      final dbDownload = await snapshotData.ref.getDownloadURL();

      newFileData.delete();

      return dbDownload;
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

      File fileNew = File(join(pathDb, DatabaseRepository.databaseName));
      await fileNew.delete();

      var downloadTask = dbRef.writeToFile(fileNew);
      await downloadTask.whenComplete(() {});
    } on FirebaseException catch (e) {
      Logger.Red.log(e);
      throw Exception(e.message);
    }
  }
}
