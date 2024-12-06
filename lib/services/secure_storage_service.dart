import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 創建 Secure Storage 實例
final FlutterSecureStorage secureStorage = FlutterSecureStorage();
const String accessTokenKey = 'accessToken';

/// 保存 Access Token
Future<void> storeAccessToken(String token) async {
  await secureStorage.write(key: accessTokenKey, value: token);
}

/// 獲取 Access Token
Future<String?> getAccessToken() async {
  return await secureStorage.read(key: accessTokenKey);
}

/// 清除 Access Token
Future<void> clearAccessToken() async {
  await secureStorage.delete(key: accessTokenKey);
}