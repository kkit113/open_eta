import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper extends ChangeNotifier {
  static const _kLanguagePrefs = 'Tc';
  final SharedPreferences _pref;

  PreferencesHelper(this._pref);

  String get getLangPrefs => _pref?.getString(_kLanguagePrefs) ?? 'Tc';

  void setLangPrefs(String value) {
    _pref?.setString(_kLanguagePrefs, value);
    notifyListeners();
  }
}
