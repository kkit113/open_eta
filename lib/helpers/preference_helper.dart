import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final String _kLanguagePrefs = 'Tc';

  Future<String> getLangPrefs() async {
    final SharedPreferences sharedPreference =
        await SharedPreferences.getInstance();
    return sharedPreference.getString(_kLanguagePrefs) ?? 'Tc';
  }

  Future<bool> setLangPrefs(String value) async {
    final SharedPreferences sharedPreference =
        await SharedPreferences.getInstance();
    return sharedPreference.setString(_kLanguagePrefs, value);
  }
}
