import 'package:flutter/material.dart';
import 'package:hello_world/screens/pets.dart';
import 'package:hello_world/screens/adoptions.dart';
import 'package:hello_world/screens/myadoptions.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vets2Pets'),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.pets),
                title: Text('Pets'),
                onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PetsPage()), (Route<dynamic> route) => false);

                },
              ),
              ExpansionTile(
                leading: Icon(Icons.favorite),
                title: Text("Adoptions"),
                children: <Widget>[
                  ListTile(
                leading: Icon(Icons.star_border),
                title: Text('My Adoptions'),
                onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAdoptionsPage()),
                  );
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
                  ListTile(
                leading: Icon(Icons.person),
                title: Text('My Posts'),
                onTap: () {
                   print("Nice2");
                }),
                    ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Latest posts'),
                onTap: () {
                  print("Nice1");
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
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
