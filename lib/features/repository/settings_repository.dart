import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class SettingsRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SharedPreferences _cache;

  SettingsRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required SharedPreferences cache,
  })  : _cache = cache,
        _firestore = firestore,
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

    final now = DateTime.now().toIso8601String();

    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "monthly_income": monIncomeNew,
      "monthly_budget": monBudgetNew,
      "updated_at": now,
    });

    final newUserData = userData.copyWith(
      monthlyBudget: monBudgetNew.toDouble(),
      monthlyIncome: monIncomeNew.toDouble(),
    );
    await _cache.setString(
      userCacheKey,
      userModelToMap(newUserData),
    );
  }

  Future<void> editProfileName({String? newName}) async {
    await _firebaseAuth.currentUser!.updateDisplayName(newName);
    await _firebaseAuth.currentUser!.reload();
  }

  Future<void> editProfileEmail({String? newEmail}) async {
    await _firebaseAuth.currentUser!.updateEmail(newEmail!);
    await _firebaseAuth.currentUser!.reload();
  }
}
