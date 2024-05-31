// Package imports:
import 'package:master_utility/src/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

///This class provides helper methods to access and store data in the device's shared preferences storage. The data is encrypted before storing it in the shared preferences
class PreferenceHelper {
  PreferenceHelper._();
  static SharedPreferences? _prefs;
  static String _encryptionKey = '';

  /// Loads and parses the [SharedPreferences] for this app from disk.
  static Future<void> init({required String encryptionKey}) async {
    _prefs = await SharedPreferences.getInstance();
    _encryptionKey = encryptionKey;
  }

  /// Saves a boolean [value] to persistent storage in the background.
  static Future<void> setBoolPrefValue({
    required String key,
    required bool value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
    // await _prefs?.setBool(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  static bool? getBoolPrefValue({
    required String key,
  }) {
    return getDecryptedValue(key: key).toBoolean();
    // return _prefs?.getBool(key);
  }

  /// Saves a string [value] to persistent storage in the background.
  static Future<void> setStringPrefValue({
    required String key,
    required String value,
  }) async {
    await setEncryptedValue(key: key, value: value);
    // await _prefs?.setString(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a String.
  static String getStringPrefValue({
    required String key,
  }) {
    return getDecryptedValue(key: key);
    // return _prefs?.getString(key) ?? "";
  }

  /// Saves an integer [value] to persistent storage in the background.
  static Future<void> setIntPrefValue({
    required String key,
    required int value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
    // await _prefs?.setInt(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  static int? getIntPrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);
    return value.isNotEmpty ? int.parse(value) : null;
    // return _prefs?.getInt(key) ?? 0;
  }

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  static Future<void> setDoublePrefValue({
    required String key,
    required double value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
    // await _prefs?.setDouble(key, value);
  }

  /// Reads a value from persistent storage, throwing an exception if it's not a double.
  static double? getDoublePrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);
    return value.isNotEmpty ? double.parse(value) : null;
    // return _prefs?.getDouble(key) ?? 0.0;
  }

  /// Removes an entry from persistent storage.
  static Future<bool> removePrefValue({
    required String key,
  }) async {
    final Future<bool> value = _prefs!.remove(key);
    return value;
  }

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clearAll() async {
    final Future<bool> value = _prefs!.clear();
    return value;
  }

  static Future<void> setEncryptedValue({required String key, required String value}) async {
    await _prefs?.setString(key, EncryptionHelper.encrypt(value: value, key: _encryptionKey));
  }

  static String getDecryptedValue({required String key}) {
    return EncryptionHelper.decrypt(value: _prefs?.getString(key) ?? '', key: _encryptionKey);
  }
}

extension on String {
  bool? toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0" ? false : null);
  }
}
