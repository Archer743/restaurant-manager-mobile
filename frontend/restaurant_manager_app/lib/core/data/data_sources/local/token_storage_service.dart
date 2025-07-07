import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/core/data/models/auth_model.dart';

class TokenStorageService {
  final FlutterSecureStorage _storage;

  TokenStorageService(this._storage);

  Future<void> saveTokens(AuthModel auth) async {
    await _storage.write(key: 'accessToken', value: auth.accessToken);
    await _storage.write(key: 'refreshToken', value: auth.refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: 'accessToken');

  Future<String?> getRefreshToken() => _storage.read(key: 'refreshToken');

  Future<void> clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  Future<bool> isAccessTokenExpired() async {
    final String? accessToken = await getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw AuthTokenException();
    }

    try {
      return JwtDecoder.isExpired(accessToken);
    } on FormatException {
      throw AuthTokenException();
    }
  }
}
