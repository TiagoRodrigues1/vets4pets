import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  attemptSignIn(String email, String password) async {
    var response = await http.post(
        Uri.parse('http://52.47.179.213:8081/api/v1/auth/register'),
        body: convert.jsonEncode(
            <String, String>{"password": password, "email": email}));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        print(response.body);
      }
    } else {
      print("Error, please check all fields!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.green),
                  onPressed: () async {
                    var email = _emailController.text;
                    var password = _passwordController.text;
                    attemptSignIn(email, password);
                  },
                  child: Text("Sign In"))
            ],
          ),
        ));
  }
}
