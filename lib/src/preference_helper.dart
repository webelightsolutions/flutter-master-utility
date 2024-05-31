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

  //!==========SET METHODS==========

  //!Set Bool
  /// Saves a boolean [value] to persistent storage in the background.
  static Future<void> setBoolPrefValue({
    required String key,
    required bool value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
  }

  //! Set String
  /// Saves a string [value] to persistent storage in the background.
  static Future<void> setStringPrefValue({
    required String key,
    required String value,
  }) async {
    await setEncryptedValue(key: key, value: value);
  }

  //! Set Int
  /// Saves an integer [value] to persistent storage in the background.
  static Future<void> setIntPrefValue({
    required String key,
    required int value,
  }) async {
    await setEncryptedValue(key: key, value: value.toString());
  }

//! Set Double
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

  //!==========GET METHODS==========

  //! Get Bool
  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  static bool? getBoolPrefValue({
    required String key,
  }) {
    final String? value = getDecryptedValue(key: key);
    if ((value?.isNotEmpty ?? false)) {
      return value?.toBoolean();
    } else {
      return null;
    }
  }

  //! Get String
  /// Reads a value from persistent storage, throwing an exception if it's not a String.
  static String getStringPrefValue({
    required String key,
  }) {
    final String? value = getDecryptedValue(key: key);
    if ((value?.isNotEmpty ?? false)) {
      return value ?? '';
    } else {
      return '';
    }
  }

  //! Get Int
  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  static int? getIntPrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);
    if (value?.isNotEmpty ?? false) {
      return int.parse(value ?? '0');
    } else {
      return null;
    }
  }

  //! Get Double
  /// Reads a value from persistent storage, throwing an exception if it's not a double.
  static double? getDoublePrefValue({
    required String key,
  }) {
    final value = getDecryptedValue(key: key);

    if (value?.isNotEmpty ?? false) {
      return double.parse(value ?? "0.0");
    } else {
      return null;
    }
  }

  //!==========REMOVE METHODS==========
  /// Removes an entry from persistent storage.
  static Future<bool> removePrefValue({
    required String key,
  }) async {
    final Future<bool> value = _prefs!.remove("v2" + key);
    return value;
  }

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clearAll() async {
    final Future<bool> value = _prefs!.clear();
    return value;
  }

//!==========HELPER METHODS==========
  static Future<void> setEncryptedValue(
      {required String key, required String value}) async {
    if (value.isNotEmpty) {
      await _prefs?.setString("v2" + key,
          EncryptionHelper.encrypt(value: value, key: _encryptionKey));
    }
  }

  static String? getDecryptedValue({required String key}) {
    final value = _prefs?.getString("v2" + key);
    if (value?.isNotEmpty ?? false) {
      return EncryptionHelper.decrypt(value: value ?? '', key: _encryptionKey);
    } else {
      return null;
    }
  }
}

extension on String {
  bool? toBoolean() {
    return (toLowerCase() == "true" || toLowerCase() == "1")
        ? true
        : (toLowerCase() == "false" || toLowerCase() == "0" ? false : null);
  }
}
