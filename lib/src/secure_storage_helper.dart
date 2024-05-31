//! not in used commented out for now.
// // Package imports:
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorageHelper with _SecureStorage, _StorageHelper {
// //* for bool
//   void setBoolValue({required bool value, required String key}) {
//     setValue(key: key, value: value.toString());
//   }

//   Future<bool> getBoolValue({required String key}) async {
//     final String? _value = await getValue(key: key);
//     return convertToBool(value: _value ?? "");
//   }

// //* for String
//   void setStringValue({required String value, required String key}) {
//     setValue(key: key, value: value);
//   }

//   Future<String> getStringValue({required String key}) async {
//     return await getValue(key: key);
//   }

//   //* For any int.
//   void setIntValue({required int value, required String key}) {
//     setValue(key: key, value: value.toString());
//   }

//   Future<int?> getIntValue({required String key}) async {
//     final String _value = await getValue(key: key);
//     if (_value.isNotEmpty) {
//       return int.parse(_value);
//     } else {
//       return null;
//     }
//   }

//   //* For any double.
//   void setDoubleValue({required double value, required String key}) {
//     setValue(key: key, value: value.toString());
//   }

//   Future<double?> getDoubleValue({required String key}) async {
//     final String _value = await getValue(key: key);
//     if (_value.isNotEmpty) {
//       return double.parse(_value);
//     } else {
//       return null;
//     }
//   }
// }

// mixin _StorageHelper {
//   bool convertToBool({required String value}) {
//     if (value == "") {
//       return false;
//     } else {
//       switch (value.toLowerCase()) {
//         case "true":
//           return true;
//         case "t":
//           return true;
//         case "1":
//           return true;
//         case "0":
//           return false;
//         case "false":
//           return false;
//         case "f":
//           return false;
//         default:
//           throw Exception(
//               "You can't cast that value to a bool! : value :$value");
//       }
//     }
//   }
// }

// mixin _SecureStorage {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   AndroidOptions _secureOption() => const AndroidOptions(
//         encryptedSharedPreferences: false,
//       );

//   IOSOptions iOSOptions() =>
//       const IOSOptions(accessibility: KeychainAccessibility.unlocked);

//   Future<dynamic> setValue({required String value, required String key}) async {
//     await _storage.write(
//       key: key,
//       value: value,
//       aOptions: _secureOption(),
//       iOptions: iOSOptions(),
//     );
//   }

//   Future<dynamic> getValue({required String key}) async {
//     return await _storage.read(key: key) ?? "";
//   }

//   Future<dynamic> removeValue({required String key}) async {
//     return await _storage.delete(key: key);
//   }

//   Future<dynamic> removeAll() async {
//     return await _storage.deleteAll();
//   }
// }
