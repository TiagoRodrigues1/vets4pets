import 'package:flutter/material.dart';
import 'package:hello_world/screens/leftside_menu.dart';
import 'dart:convert' show json, base64, ascii;
import 'screens/login_screen.dart';
import 'main.dart';

Map<int, Color> color =
{
50:Color.fromRGBO(82,183,136, .1),
100:Color.fromRGBO(82,183,136, .2),
200:Color.fromRGBO(82,183,136, .3),
300:Color.fromRGBO(82,183,136, .4),
400:Color.fromRGBO(82,183,136, .5),
500:Color.fromRGBO(82,183,136, .6),
600:Color.fromRGBO(82,183,136, .7),
700:Color.fromRGBO(82,183,136, .8),
800:Color.fromRGBO(82,183,136, .9),
900:Color.fromRGBO(82,183,136, 1),
};


MaterialColor colorCustom = MaterialColor(0xFF52B788, color);

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    
    if(jwt == null) return null;
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    var logged= jwtOrEmpty;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto LPI',
      theme: ThemeData(
        primarySwatch:colorCustom,
        primaryTextTheme:TextTheme(
          headline6: TextStyle(color:Colors.white),
        ),
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
         builder: (logged != null) ? ((context, snapshot) { 
          return NavDrawer();
        })
        :((context, snapshot) {
         
          return LoginPage();
        })
      ),
    );
  }
}