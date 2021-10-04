import 'dart:convert' as convert;
import 'dart:convert';
import 'package:Vets4Pets/screens/start/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'leftside_menu.dart';
import '../../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LongPageState();
  }
}

class _LongPageState extends State<LoginPage> {
  int state = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _validate_email = false,_validate_password = false;

  @override
  void initState() {
    super.initState();
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<int> attemptLogIn(
      String email, String password, BuildContext context) async {
        
    var response = await http.post(
        Uri.parse('$SERVER_IP/auth/login'),
        body: convert.jsonEncode(
            <String, String>{"password": password, "email": email}));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        state = 1;
        var token = json.decode(response.body)['token'];

        var profilePicture = json.decode(response.body)['profilePicture'];

         var type = json.decode(response.body)['userType'];

        await storage.write(key: 'jwt', value: token);
        await storage.write(key: 'profilePicture', value: profilePicture);
        await storage.write(key: 'userType', value: type);
      }
      return 1;
    } else {
      state = 0;
      print("Incorrect");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF52B788), Color(0xFF52B788)],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/fundo.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                      child: Stack(children: [
                    Container(
                      margin: EdgeInsets.only(top: 48),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          child: CircleAvatar(
                            radius: 55.0,
                            child: CircleAvatar(
                              child: Align(
                                alignment: Alignment.bottomRight,
                              ),
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage("assets/images/icon.png"),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        )),
                  ])),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_email ? 55 : 45,
                    margin: EdgeInsets.only(top: 32),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: _validate_email ? null : 'Email',
                        errorText: _validate_email
                            ? validateEmail(_emailController.text)
                            : null,
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Color(0xFF52B788),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_password ? 55 : 45,
                    margin: EdgeInsets.only(top: 32),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _passwordController,
                      
                      obscureText: true,
                      decoration: InputDecoration(
                       hintText: _validate_password ? null : 'Password',
                        errorText: _validate_password
                            ? validatePassword(_passwordController.text)
                            : null,

                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Color(0xFF52B788),
                        ),
                        
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 32),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      var username = _emailController.text;
                      var password = _passwordController.text;

                      setState(() {
                        _emailController.text.isEmpty ||
                                (checkEmail(_emailController.text) == false)
                            ? _validate_email = true
                            : _validate_email = false;
                            _passwordController.text.isEmpty 
                            ? _validate_password = true
                            : _validate_password = false;
                      });

                      if (_validate_email != true) {
                        await attemptLogIn(username, password, context);

                        if (state == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _showDialog(context),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavDrawer()),
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF52B788),
                              Color(0xFF52B788),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 32),
                          child: Text(
                            '    Dont have a account?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Sign up now',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.green[300]),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showDialog(context) {
    return AlertDialog(
      title: new Text(
        "Error",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content:
          new Text("Wrong password or email!", textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    if (checkEmail(value) == false) {
      return "Not a valid email";
    }
    return null;
  }

   String validatePassword(String value) {
    
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    
    return null;
  }

  bool checkEmail(String string) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    print(emailRegex.hasMatch(string));
    return emailRegex.hasMatch(string);
  }
}
