// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Helper class for working with FlutterSecureStorage
class SecureStorageHelper {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Saves a string [value] to secure storage.
  static Future<void> setStringValue({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Reads a string value from secure storage.
  static Future<String?> getStringValue({
    required String key,
  }) async {
    return await _secureStorage.read(key: key);
  }

  /// Saves a boolean [value] to secure storage.
  static Future<void> setBoolValue({
    required String key,
    required bool value,
  }) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  /// Reads a boolean value from secure storage.
  static Future<bool?> getBoolValue({
    required String key,
  }) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  /// Saves an integer [value] to secure storage.
  static Future<void> setIntValue({
    required String key,
    required int value,
  }) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  /// Reads an integer value from secure storage.
  static Future<int?> getIntValue({
    required String key,
  }) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Saves a double [value] to secure storage.
  static Future<void> setDoubleValue({
    required String key,
    required double value,
  }) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  /// Reads a double value from secure storage.
  static Future<double?> getDoubleValue({
    required String key,
  }) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  /// Checks if the key exists in secure storage.
  static Future<bool> containsKey({
    required String key,
  }) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Removes a specific value from secure storage.
  static Future<void> removeValue({
    required String key,
  }) async {
    await _secureStorage.delete(key: key);
  }

  /// Clears all values from secure storage.
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
