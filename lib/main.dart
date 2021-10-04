import 'package:flutter/material.dart';
import 'myapp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
const SERVER_IP = 'http://15.237.58.204:8081/api/v1';

final storage = FlutterSecureStorage();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
