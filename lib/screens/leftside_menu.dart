

import 'package:flutter/material.dart';
import 'package:Vets4Pets/main.dart';
import 'package:Vets4Pets/screens/pets.dart';
import 'package:Vets4Pets/screens/adoptions.dart';
import 'package:Vets4Pets/screens/myadoptions.dart';
import 'package:Vets4Pets/screens/clinics.dart';
import 'package:Vets4Pets/screens/userappointments.dart';
import 'package:Vets4Pets/screens/userprofile.dart';
import '../jwt.dart';
import '../main.dart';
import 'forum.dart';
import 'login_screen.dart';

class NavDrawer extends StatelessWidget {

    String picture, username, contact, email, name;
  bool gender;

   void initState() {
   getData();
  }
  @override
  Widget build(BuildContext context) {
       getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Vets4Pets'),
      ),
      body: Center(child: Text('HomePage')),
      drawer: Container(
        width: 220,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                        image: AssetImage("assets/images/xd.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                leading: Icon(Icons.medical_services),
                title: Text('Vets'),
                onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClinicPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.pets),
                title: Text('Pets'),
                onTap: () {
                       Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetsPage()),
                  );
                },
              ),
              ExpansionTile(
                leading: Icon(Icons.favorite),
                title: Text("Adoptions",
                
                ),
                
                children: <Widget>[
                  ListTile(
                leading: Icon(Icons.star_border),
                title: Text('My Adoptions'),
                onTap: () {
                                     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyAdoptionsPage()), (Route<dynamic> route) => false);

                }),
                    ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Latest adoptions'),
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdoptionsPage()),
                  );
                }),
                  ],
              ),
              ExpansionTile(
                leading: Icon(Icons.people),
                title: Text("Forum"),
                children: <Widget>[
                   ExpansionTile(
                leading: Icon(Icons.people),
                title: Text("My Posts"),
                children: <Widget>[
                  ListTile(
                leading: Icon(Icons.email_rounded),
                title: Text('My Questions'),
                onTap: () {
                   print("Nice2");
                }),
                    ListTile(
                leading: Icon(Icons.forward_to_inbox_rounded ),
                title: Text('My Answers'),
                onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForumPage()),
                  );
                }),
                  ],
              ),
                    ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Latest posts'),
                onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForumPage()),
                  );
                }),
                  ],
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Near Vets'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
               SizedBox(height: 170.0),
                ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                onTap: () {
                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage(username: username, gender: gender, picture: picture,name: name, email: email, contact: contact,)),
                  );
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                 showDialog(
                        context: context,
                        builder: (BuildContext context) => _showDialog(context),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );




    
  }


  getData() async {
    var jwt = await storage.read(key: "jwt");
    picture = await storage.read(key: "profilePicture");
    var results = parseJwtPayLoad(jwt);
    username = results['username'];
    email = results['email'];
    name = results['name'];
    contact = results['contact'];
    gender = results['gender'];
  
    
  }


  Widget _showDialog(context) {
    return AlertDialog(
      title: new Text("Logout",textAlign: TextAlign.center,),
      content: new Text("Are you sure that you want to terminate session?",textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
          child: new Text("No"),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
        Padding(
          padding:const EdgeInsets.only(left:178),
          child: TextButton(
             style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
            child: new Text("Yes"),
            onPressed: () {
            storage.delete(key: "jwt");
            Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()),
                (Route<dynamic> route) => false); 
            },
          ),
        ),
      ],
    );
  }
}
