import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStorage = FlutterSecureStorage();

  try {
    await dotenv.load(fileName: ".env");

    final accessToken = dotenv.env['ACCESS_TOKEN'];
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("Access Token 不存在於 .env 文件中");
    }

    await secureStorage.write(key: 'ACCESS_TOKEN', value: accessToken);
    print("Access Token saved securely: $accessToken");
  } catch (e) {
    print("Error loading .env or saving access token: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Source Hunter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchPage(),
    );
  }
}