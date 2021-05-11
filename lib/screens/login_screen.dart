import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'leftside_menu.dart';
import 'register_screen.dart';
import '../main.dart';
import '../jwt.dart';



class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  attemptLogIn(String email, String password, BuildContext context) async {
    var response = await http.post(
        Uri.parse('http://52.47.179.213:8081/api/v1/auth/login'),
        body: convert.jsonEncode(
            <String, String>{"password": password, "email": email}));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
       
        var token=json.decode(response.body)['token'];
        await storage.write(key: 'jwt', value: token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavDrawer()),
        );
      }
    } else {
      print("Error message like email or password wrong!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextButton(
                  
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    attemptLogIn(username, password, context);
                  },
                  child: Text("Log In")),
              TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text("Sign Up"))
            ],
          ),
        ));
  }
}
