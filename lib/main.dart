import 'package:flutter/material.dart';
import 'myapp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

const SERVER_IP = 'localhost:8081';
final storage = FlutterSecureStorage();

main(){
  runApp(MyApp());
}

