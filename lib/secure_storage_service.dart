import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
const String accessTokenKey = 'accessToken';

Future<void> storeAccessToken(String token) async {
  await secureStorage.write(key: accessTokenKey, value: token);
}

Future<String?> getAccessToken() async {
  return await secureStorage.read(key: accessTokenKey);
}

Future<void> clearAccessToken() async {
  await secureStorage.delete(key: accessTokenKey);
}