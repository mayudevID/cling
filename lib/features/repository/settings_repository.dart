import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences _cache;

  SettingsRepository({
    required SharedPreferences cache,
  }) : _cache = cache;

  static const languagePrefsKey = '__language_prefs__';

  Future<void> saveLangSettings(String langCode) async {
    await _cache.setString(languagePrefsKey, langCode);
  }

  String? getCurrentLang() {
    return _cache.getString(languagePrefsKey);
  }
}
