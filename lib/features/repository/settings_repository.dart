import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';

class SettingsRepository {
  final SupabaseClient _supabaseClient;
  final SharedPreferences _cache;

  SettingsRepository({
    required SupabaseClient supabaseClient,
    required SharedPreferences cache,
  })  : _cache = cache,
        _supabaseClient = supabaseClient;

  static const userCacheKey = '__user_cache_key__';
  static const languagePrefsKey = '__language_prefs__';
  static const currencyPrefsKey = '__currency_prefs__';

  UserModel? get currentUserModel {
    final getData = _cache.getString(userCacheKey);
    if (getData != null) {
      return userModelFromMap(getData);
    }
    return null;
  }

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
    int? monthlyIncome,
    int? monthlyBudget,
  }) async {
    final userData = currentUserModel!;

    await _supabaseClient.from("profiles").upsert({
      "id": userData.id,
      "monthly_income": monthlyIncome ?? userData.monthlyIncome,
      "monthly_budget": monthlyBudget ?? userData.monthlyBudget,
      // "verified_process": true,
      "updated_at": DateTime.now().toIso8601String(),
    });
    final newUserData = userData.copyWith(
      monthlyBudget: monthlyBudget!.toDouble(),
      monthlyIncome: monthlyIncome!.toDouble(),
      //verifiedProcess: true,
    );
    await _cache.setString(
      userCacheKey,
      userModelToMap(newUserData),
    );
  }
}
