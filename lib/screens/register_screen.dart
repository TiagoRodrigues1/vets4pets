import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}





class RegisterPageState extends State<RegisterPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();



  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  attemptSignIn(String email,String username, String password, String name, String contact) async {
    var response = await http.post(
        Uri.parse('http://52.47.179.213:8081/api/v1/auth/register'),
        body: convert.jsonEncode(
            <String, dynamic>{
              "email": email, 
              "password": password,
              "name": name,
              "contact": contact,
              "gender": false,
              "username": username
              
              }));

    var jsonResponse;
    print(response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        
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
      body:Container(
      
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
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: MediaQuery.of(context).size.height -200,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 32),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Name',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _emailController,
                          
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _usernameController,
                        
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Username',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _password1Controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                   Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _password2Controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                       Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _contactController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Color(0xFF52B788),
                            ),
                            hintText: 'Contact',
                          ),
                        ),
                      ),
      
                      InkWell(
                        onTap: () async {
                          var email = _emailController.text;
                          var password1 = _password1Controller.text;
                          var username = _usernameController.text;
                          var password2 = _password2Controller.text;
                          var name = _nameController.text;
                          var contact = _contactController.text;
                          print(username);
                           await attemptSignIn(email,username, password1,name,contact);

                          /* if(state==0){
                        showDialog(
                        context: context,
                        builder: (BuildContext context) => _showDialog(context),
                      );

                    }else{
                        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavDrawer()),
        );
                    }*/
                        },
                        child: Container(
                          height: 45,
                                                  margin: EdgeInsets.only(top: 16),

                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF52B788),
                                  Color(0xFF52B788),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
     
      
        ),
      );
    
  }
}
