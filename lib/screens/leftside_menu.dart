import 'package:flutter/material.dart';
import 'package:hello_world/screens/pets.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vets2Pets'),
        ),
      body: Center(child: Text('HomePage')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
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
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetsPage()),
                );
                //Navigator.pop(context);
              },
            ),
            ListTile(
               leading: Icon(Icons.favorite),
              title: Text('Adoptions'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
               leading: Icon(Icons.people),
              title: Text('Forum'),
              onTap: () {
               
                Navigator.pop(context);
              },
              
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
    );
  }
}