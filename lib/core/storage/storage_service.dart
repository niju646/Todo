import 'package:hive_flutter/hive_flutter.dart';

class ThemeStorageService {
  ThemeStorageService._();
  static final ThemeStorageService instance = ThemeStorageService._();

  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';
  // static const _loginKey = 'login';
  static const _accessTokenKey = 'access_token';
  static const _userDataKey = 'user_data';
  static const _refreshTokenKey = 'refresh_token';

  //offline todo
  static const _todoCacheKey = 'cached_todos';

  Box get _box => Hive.box(_boxName);

  /// Save theme
  Future<void> saveThemeMode(String mode) async {
    await _box.put(_themeKey, mode);
  }

  /// Get theme
  String? getThemeMode() {
    return _box.get(_themeKey);
  }

  ///  Save auth token
  Future<void> saveToken(String token) async {
    await _box.put(_accessTokenKey, token);
  }

  /// Get auth token
  String? getAccessToken() {
    return _box.get(_accessTokenKey);
  }

  /// Save user data
  Future<void> saveUserData(String userData) async {
    await _box.put(_userDataKey, userData);
  }

  /// Get user data
  String? getUserData() {
    return _box.get(_userDataKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _box.put(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _box.get(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _box.delete(_accessTokenKey);
    await _box.delete(_refreshTokenKey);
    await _box.delete(_userDataKey);
  }

  /// OFFLINE todo

  /// Save todos
  Future<void> saveTodos(String todosJson) async {
    await _box.put(_todoCacheKey, todosJson);
  }

  /// Get cached todos
  String? getTodos() {
    return _box.get(_todoCacheKey);
  }

  /// Clear todos
  Future<void> clearTodos() async {
    await _box.delete(_todoCacheKey);
  }
}
