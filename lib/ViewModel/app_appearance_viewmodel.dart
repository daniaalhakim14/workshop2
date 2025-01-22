import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppAppearanceViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _matchSystemTheme = false;
  String? _userId;
  bool _isLoading = false;

  final GetStorage _storage = GetStorage();

  bool get isDarkMode => _isDarkMode;
  bool get matchSystemTheme => _matchSystemTheme;
  bool get isLoading => _isLoading;

  Future<void> initialize(String userId) async {
    if (_userId == userId && !_isLoading) {
      debugPrint('AppAppearanceViewModel already initialized for user: $userId');
      return;
    }

    if (_userId != null && _userId != userId) {
      debugPrint('Switching users. Saving preferences for previous user: $_userId');
      await _savePreferencesForUser();
      resetState();
    }

    _isLoading = true;
    _userId = userId;

    try {
      debugPrint('Initializing AppAppearanceViewModel for user: $userId');
      _loadPreferencesForUser();
      _applyPreferences();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> _savePreferencesForUser() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot save preferences.');
      return;
    }

    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    debugPrint(
        'Saving preferences for user $_userId: darkMode = $_isDarkMode, matchSystemTheme = $_matchSystemTheme');
    _storage.write(darkModeKey, _isDarkMode);
    _storage.write(matchThemeKey, _matchSystemTheme);

    debugPrint('Preferences saved for user: $_userId');
  }

  void _loadPreferencesForUser() {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot load preferences.');
      return;
    }

    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    _isDarkMode = _storage.read<bool>(darkModeKey) ?? false;
    _matchSystemTheme = _storage.read<bool>(matchThemeKey) ?? false;

    debugPrint(
        'Loaded preferences for user $_userId: darkMode = $_isDarkMode, matchSystemTheme = $_matchSystemTheme');
  }

  void _applyPreferences() {
    if (_matchSystemTheme) {
      final systemBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = systemBrightness == Brightness.dark;
    }

    debugPrint('Preferences applied for user: $_userId');
  }

  void resetState() {
    _isDarkMode = false;
    _matchSystemTheme = false;
    _userId = null;
    debugPrint('State reset for AppAppearanceViewModel');
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_userId == null) return;

    _isDarkMode = value;
    _matchSystemTheme = false;

    await _savePreferencesForUser();
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

    await _savePreferencesForUser();
    notifyListeners();
  }

  Future<void> resetPreferences() async {
    if (_userId == null) {
      debugPrint('User ID is null. Cannot reset preferences.');
      return;
    }

    final darkModeKey = '$_userId-isDarkMode';
    final matchThemeKey = '$_userId-matchSystemTheme';

    _storage.remove(darkModeKey);
    _storage.remove(matchThemeKey);

    resetState();
  }
}
