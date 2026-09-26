import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provedor global de idioma, no mesmo padrão do ThemeProvider.
// Português é o idioma padrão do app.
class LocaleProvider extends ChangeNotifier {
  static const _prefsKey = "idioma";

  Locale _locale = const Locale('pt');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString(_prefsKey);
    if (codigo == 'en') {
      _locale = const Locale('en');
    }
  }

  Future<void> setPortuguese() async {
    if (_locale.languageCode == 'pt') return;
    _locale = const Locale('pt');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, 'pt');
  }

  Future<void> setEnglish() async {
    if (_locale.languageCode == 'en') return;
    _locale = const Locale('en');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, 'en');
  }
}
