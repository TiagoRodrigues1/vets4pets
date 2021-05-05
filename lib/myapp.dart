import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'screens/login_screen.dart';
import 'main.dart';

Map<int, Color> color =
{
50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79, 1),
};


MaterialColor colorCustom = MaterialColor(0xFF81C784, color);

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto LPI',
      theme: ThemeData(
        primarySwatch:Colors.green,
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