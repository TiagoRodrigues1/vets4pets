import 'package:flutter/material.dart';
import 'myapp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_IP = 'http://52.47.179.213:8081/api/v1';
final storage = FlutterSecureStorage();

main() {
  runApp(MyApp());
}
