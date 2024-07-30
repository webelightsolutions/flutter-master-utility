// Dart imports:
import 'dart:convert';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:master_utility/master_utility.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart';

class EncryptionService {
  EncryptionService._();

  static String publicKey = '';

  /// Use same key for set and get value **'publicKey'**
  static Future<void> loadPublicKey() async {
    publicKey = PreferenceHelper.getStringPrefValue(key: 'publicKey');
  }

  static String encryptSecretKeyToRSA(String secretKey) {
    final parser = RSAKeyParser();
    final rsapublicKey = parser.parse(publicKey);
    final encrypter = Encrypter(
      RSA(
        publicKey: RSAPublicKey(
          rsapublicKey.modulus!,
          rsapublicKey.exponent!,
        ),
      ),
    );
    final encrypted = encrypter.encrypt(secretKey);

    return encrypted.base64;
  }
}

extension MapEncryption on Map<dynamic, dynamic> {
  Map<String, dynamic> encrypted() {
    final keyString = generateRandomStringForLogin(16);
    final ivString = generateRandomStringForLogin(16);

    final secretKey = enc.Key.fromUtf8(keyString);
    final secretIv = enc.IV.fromUtf8(ivString);

    final encrypter = enc.Encrypter(
      enc.AES(secretKey, mode: enc.AESMode.cbc),
    );

    final encryptedData = encrypter.algo.encrypt(mapToUint8List(), iv: secretIv);
    final encryptedKey = EncryptionService.encryptSecretKeyToRSA(keyString);

    return {
      'encryptedData': encryptedData.base64,
      'encryptedKey': encryptedKey,
      'iv': secretIv.base64,
    };
  }

  Uint8List mapToUint8List() {
    final jsonString = json.encode(this);
    final uint8list = Uint8List.fromList(utf8.encode(jsonString));
    return uint8list;
  }

  static String generateRandomStringForLogin(int len) {
    final r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }
}
