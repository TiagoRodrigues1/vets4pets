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
  bool _validate_name = false,_validate_username = false,_validate_password = false,_validate_password2 = false,_validate_email = false,_validate_contact = false;


 @override
  void initState() {
    super.initState();
  }


  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  attemptSignIn(String email, String username, String password, String name,
      String contact) async {
    var response = await http.post(
        Uri.parse('http://52.47.179.213:8081/api/v1/auth/register'),
        body: convert.jsonEncode(<String, dynamic>{
          "email": email,
          "password": password,
          "name": name,
          "contact": contact,
          "gender": false,
          "username": username
        }));
  
    print(response.body);
    if (response.statusCode == 200) {
     
     return 0;
    } else if(response.statusCode == 400 ) {
        if(response.body.contains("Email")){
          return 1;
        }
        if(response.body.contains("Username")){
          return 2;
        }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 32),
              child: Column(
                children: <Widget>[
                   Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_name ? 55 : 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                         hintText: _validate_name ? null : 'Name',
                        errorText: _validate_name ? validateName(_nameController.text) : null,
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.pets_sharp,
                          color: Color(0xFF52B788),
                        ),
                        
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_email ? 55 : 45,
                    margin: EdgeInsets.only(top: 16),
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
                    height: 45,
                    margin: EdgeInsets.only(top: 16),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                    height: _validate_password ? 55 : 45,
                    margin: EdgeInsets.only(top: 16),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                        hintText: _validate_password ? null : 'Password',
                        errorText: _validate_password
                            ? validatePassword(_password1Controller.text,_password2Controller.text)
                            : null,
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Color(0xFF52B788),
                        ),
                        
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_password2 ? 55 : 45,
                    margin: EdgeInsets.only(top: 16),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
                        hintText: _validate_password2 ? null : 'Confirm Password',
                        errorText: _validate_password2
                            ? validatePassword(_password2Controller.text,_password1Controller.text)
                            : null,
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Color(0xFF52B788),
                        ),
                       
                      ),
                    ),
                  ),
                   Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: _validate_contact ? 55 : 45,
                    margin: EdgeInsets.only(top:16),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _contactController,
                        decoration: InputDecoration(
                           hintText: _validate_contact ? null : 'Contact',
                        errorText: _validate_contact ? validateContact(_contactController.text) : null,
                     
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.phone,
                          color: Color(0xFF52B788),
                        ),
                      
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
                    
                             setState(() {
                        _nameController.text.isEmpty ||  _nameController.text.length>50 || _nameController.text.length<10
                            ? _validate_name = true
                            : _validate_name = false;
                     
                         _password1Controller.text.isEmpty ||_password1Controller.text!=_password2Controller.text ||  _password1Controller.text.length<6
                            ? _validate_password = true
                            : _validate_password = false;
                             _password2Controller.text.isEmpty ||_password2Controller.text!=_password1Controller.text ||  _password2Controller.text.length<6
                            ? _validate_password2 = true
                            : _validate_password2 = false;
                        _emailController.text.isEmpty || (checkEmail(_emailController.text)==false)
                              ? _validate_email = true 
                            : _validate_email= false;
                           _contactController.text.length!=9 || (checkNumber( _contactController.text)==false)
                              ? _validate_contact = true 
                            : _validate_contact= false;
                      });

                     

                    if (_validate_email != true &&_validate_name != true && _validate_contact != true){

                        var state=await attemptSignIn(
                          email, username, password1, name, contact);
                         if (state == 0) {
                           Navigator.pop(context);
                        } else {
                          print("xd");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _showDialog(context,state),
                          );
                         
                        }
                    }
                      

             
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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


  String validateName(String value) {
  
  if(value.isEmpty){
    return "Name can't be empty";
  }
  if (value.length < 10)  {
    return "Name is to small ";
  }
  if (value.length > 50)  {
    return "Name is to big ";
  }
  
  return null;
}

 String validateBirth(String value) {
  final numericRegex = 
    RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
 if(value.isEmpty){
   return null;
 }
  if (value.length != 4 )  {
    return "Invalid year";
  }
  if (numericRegex.hasMatch(value)==false)  {
    return "Not a number";
  }
  
  return null;
}

 String validateEmail(String value) {
  
 
  if (value.isEmpty)  {
    return "Email can't be empty";
  }
  if (checkEmail(value)==false)  {
    return "Not a valid email";
  }
  return null;
}

String validateContact(String value) {
  
 if(value.isEmpty){
  return "Contact can't be empty";
 }
  if (value.length!=9)  {
    return "Not a valid contact";
  }
  if (checkNumber(value)==false)  {
    return "Not a valid contact";
  }
  return null;
}

String validatePassword(String value,String value2) {
  
 if(value.isEmpty){
  return "Password can't be empty";
 }
  if (value!=value2)  {
    return "Passwords doesn't match";
  }
if(value.length<6){
   return "Passwords is too small";
}
  return null;
}

bool checkNumber(String string) {
  
  final numericRegex = 
    RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}

bool checkEmail(String string) {
  final emailRegex = 
    RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
print(emailRegex.hasMatch(string));
  return emailRegex.hasMatch(string);
}

Widget _showDialog(context, var flag) {

  String text;
  if(flag==1){
text="Email already registed!";
  }  if(flag==2){
    text="Username already registed!";

  }  if(flag==3){
     text="Email and Username already registed!";
  }
  if(flag==4){
     text="Password does not match!!";
  }
    return AlertDialog(
      title: new Text(
        "Error",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content:
          new Text(text, textAlign: TextAlign.center),
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
}
