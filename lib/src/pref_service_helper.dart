// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceServiceHelper {
  static SharedPreferences? _prefs;

  /// Loads and parses the [SharedPreferences] for this app from disk.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Saves a boolean [value] to persistent storage in the background.
  Future<void> setBoolPrefValue({
    required String key,
    required bool value,
  }) async {
    await _prefs?.setBool(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  bool? getBoolPrefValue({
    required String key,
  }) {
    return _prefs?.getBool(key);
  }

  /// Saves a string [value] to persistent storage in the background.
  Future<void> setStringPrefValue({
    required String key,
    required String value,
  }) async {
    await _prefs?.setString(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a String.
  String getStringPrefValue({
    required String key,
  }) {
    return _prefs?.getString(key) ?? "";
  }

  /// Saves a list of strings [value] to persistent storage in the background.
  Future<void> setStringListPrefValue({
    required String key,
    required List<String> value,
  }) async {
    await _prefs?.setStringList(key, value);
  }

  /// Reads a set of string values from persistent storage, throwing an exception if it's not a string set.
  List<String>? getStringListPrefValue({
    required String key,
  }) {
    return _prefs?.getStringList(key);
  }

  /// Saves an integer [value] to persistent storage in the background.
  Future<void> setIntPrefValue({
    required String key,
    required int value,
  }) async {
    await _prefs?.setInt(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  int getIntPrefValue({
    required String key,
  }) {
    return _prefs?.getInt(key) ?? 0;
  }

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  Future<void> setDoublePrefValue({
    required String key,
    required double value,
  }) async {
    await _prefs?.setDouble(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a double.
  double getDoublePrefValue({
    required String key,
  }) {
    return _prefs?.getDouble(key) ?? 0.0;
  }

  /// Removes an entry from persistent storage.
  Future<bool> removePrefValue({
    required String key,
  }) async {
    final Future<bool> value = _prefs!.remove(key);
    return value;
  }

  /// Completes with true once the user preferences for the app has been cleared.
  Future<bool> clearAll() async {
    final Future<bool> value = _prefs!.clear();
    return value;
  }
}
