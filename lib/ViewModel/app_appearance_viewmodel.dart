import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAppearanceViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _matchSystemTheme = false;
  String? _userId;
  bool _isLoading = false;

  bool get isDarkMode => _isDarkMode;
  bool get matchSystemTheme => _matchSystemTheme;
  bool get isLoading => _isLoading;

  Future<void> initialize(String userId) async {
    if (_userId == userId && !_isLoading) {
      debugPrint('AppAppearanceViewModel already initialized for user: $userId');
      return; // Prevent redundant initialization
    }

    if (_userId != null && _userId != userId) {
      debugPrint('Switching users. Saving preferences for previous user: $_userId');
      await _savePreferencesForUser(); // Ensure previous user preferences are saved
    }

    _isLoading = true;
    _userId = userId;

    try {
      debugPrint('Initializing AppAppearanceViewModel for user: $userId');
      await _loadPreferencesForUser(); // Load preferences for the new user
      _applyPreferences(); // Apply preferences to the current state
    } catch (e) {
      debugPrint('Error during initialization: $e');
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners(); // Notify listeners after loading is complete
      });
    }
  }

  Future<void> _loadPreferencesForUser() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot load preferences.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    _isDarkMode = prefs.getBool(darkModeKey) ?? false;
    _matchSystemTheme = prefs.getBool(matchThemeKey) ?? false;

    debugPrint('Loaded isDarkMode: $_isDarkMode for user: $_userId');
    debugPrint('Loaded matchSystemTheme: $_matchSystemTheme for user: $_userId');
  }

  Future<void> _savePreferencesForUser() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot save preferences.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    await prefs.setBool(darkModeKey, _isDarkMode);
    await prefs.setBool(matchThemeKey, _matchSystemTheme);

    debugPrint('Preferences saved for user: $_userId');
  }

  void _applyPreferences() {
    if (_matchSystemTheme) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = systemBrightness == Brightness.dark;
    }

    debugPrint('Preferences applied for user: $_userId');
  }

  Future<void> setDarkMode(bool value) async {
    if (_userId == null) return;

    _isDarkMode = value;
    _matchSystemTheme = false; // Disable system theme matching when toggling dark mode

    await _savePreferencesForUser(); // Save changes immediately
    notifyListeners();
  }

  Future<void> setMatchSystemTheme(bool value) async {
    if (_userId == null) return;

    _matchSystemTheme = value;

    if (value) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = systemBrightness == Brightness.dark;
    }

    await _savePreferencesForUser(); // Save changes immediately
    notifyListeners();
  }

  Future<void> resetPreferences() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot reset preferences.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    await prefs.remove(darkModeKey);
    await prefs.remove(matchThemeKey);

    _isDarkMode = false;
    _matchSystemTheme = false;

    debugPrint('Preferences reset for user: $_userId');
    notifyListeners();
  }
}
