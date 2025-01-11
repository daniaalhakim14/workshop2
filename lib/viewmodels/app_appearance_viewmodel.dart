import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAppearanceViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _matchSystemTheme = false;
  String? _userId;
  bool _isLoading = true;

  bool get isDarkMode => _isDarkMode;
  bool get matchSystemTheme => _matchSystemTheme;
  String? get userId => _userId;
  bool get isLoading => _isLoading;

  Future<void> initialize(String userId) async {
    _isLoading = true;
    _userId = userId;
    notifyListeners();

    try {
      await _loadPreferencesForUser();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    } finally {
      if (_matchSystemTheme) {
        final systemBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDarkMode = systemBrightness == Brightness.dark;
      }

      notifyListeners();

      _isLoading = false;
    }
  }

  Future<void> _loadPreferencesForUser() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot load preferences.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    _matchSystemTheme = prefs.getBool('$_userId-matchSystemTheme') ?? false;
    _isDarkMode = prefs.getBool('$_userId-isDarkMode') ?? false;

    if (_matchSystemTheme) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = systemBrightness == Brightness.dark;
    }

    debugPrint('Preferences loaded for user: $_userId');
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    _matchSystemTheme = false;
    await _savePreferencesForUser();
    notifyListeners();
  }

  Future<void> setMatchSystemTheme(bool value) async {
    _matchSystemTheme = value;

    if (value) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = systemBrightness == Brightness.dark;
    }

    await _savePreferencesForUser();
    notifyListeners();
  }

  Future<void> _savePreferencesForUser() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot save preferences.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_userId-matchSystemTheme', _matchSystemTheme);
    await prefs.setBool('$_userId-isDarkMode', _isDarkMode);

    debugPrint('Preferences saved for user: $_userId');
  }
}
