import 'package:master_utility/master_utility.dart';

/// A singleton implementation of TokenStorage that securely stores JWT tokens
class SecureTokenStorageHelper implements TokenStorage {
  // Private constructor
  SecureTokenStorageHelper._({
    required this.accessTokenKey,
    required this.refreshTokenKey,
  });

  /// The key used to store the access token
  final String accessTokenKey;

  /// The key used to store the refresh token
  final String refreshTokenKey;

  /// Singleton instance
  static SecureTokenStorageHelper? _instance;

  /// Initializes the singleton instance with the required keys.
  /// Must be called once before using getInstance().
  static void initialize({
    required String accessTokenKey,
    required String refreshTokenKey,
  }) {
    _instance = SecureTokenStorageHelper._(
      accessTokenKey: accessTokenKey,
      refreshTokenKey: refreshTokenKey,
    );
  }

  /// Returns the singleton instance
  /// Throws an exception if not initialized
  static SecureTokenStorageHelper getInstance() {
    if (_instance == null) {
      throw StateError('SecureTokenStorageHelper not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  @override
  Future<JwtToken?> loadToken() async {
    final accessToken = await SecureStorageHelper.getStringValue(
      key: accessTokenKey,
    );
    final refreshToken = await SecureStorageHelper.getStringValue(
      key: refreshTokenKey,
    );

    if (accessToken != null && refreshToken != null) {
      return JwtToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }

    return null;
  }

  @override
  Future<void> saveToken(JwtToken jwtToken) async {
    await Future.wait([
      SecureStorageHelper.setStringValue(
        key: accessTokenKey,
        value: jwtToken.accessToken,
      ),
      SecureStorageHelper.setStringValue(
        key: refreshTokenKey,
        value: jwtToken.refreshToken,
      )
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait(
        [SecureStorageHelper.removeValue(key: accessTokenKey), SecureStorageHelper.removeValue(key: refreshTokenKey)]);
  }

  @override
  Future<String?> get accessToken => SecureStorageHelper.getStringValue(key: accessTokenKey);

  @override
  Future<String?> get refreshToken => SecureStorageHelper.getStringValue(key: refreshTokenKey);
}
