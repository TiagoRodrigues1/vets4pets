import 'package:flutter/material.dart';
import 'package:Vets4Pets/screens/start/leftside_menu.dart';
import 'screens/start/login_screen.dart';
import 'screens/start/leftside_menu.dart';
import 'main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(82, 183, 136, .1),
  100: Color.fromRGBO(82, 183, 136, .2),
  200: Color.fromRGBO(82, 183, 136, .3),
  300: Color.fromRGBO(82, 183, 136, .4),
  400: Color.fromRGBO(82, 183, 136, .5),
  500: Color.fromRGBO(82, 183, 136, .6),
  600: Color.fromRGBO(82, 183, 136, .7),
  700: Color.fromRGBO(82, 183, 136, .8),
  800: Color.fromRGBO(82, 183, 136, .9),
  900: Color.fromRGBO(82, 183, 136, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF52B788, color);

class MyApp extends StatelessWidget {
 




  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto LPI',
      theme: ThemeData(
        primarySwatch: colorCustom,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == "") {
              return LoginPage();
            } else {
              return NavDrawer();
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
