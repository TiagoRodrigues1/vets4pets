import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'screens/login_screen.dart';
import 'main.dart';



class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
        builder: (context, snapshot) {
          return LoginPage();
        }
      ),
    );
  }
}