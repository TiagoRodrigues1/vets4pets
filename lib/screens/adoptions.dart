import 'dart:io';
import 'package:hello_world/models/animaltypes.dart';
import '../models/animal.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart';
import 'dart:convert' as convert;

import '../jwt.dart';

class AdoptionsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<AdoptionsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animaltypeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  List pets = [];
  List<Map<String,dynamic>> petsType = animalTypes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getAdoptions();
  }

  getAdoptions() async {
  
  }

  addAdoption(String name, String animaltype, String race, BuildContext context) async {
   
  }


    deleteAdoption(int id) async {
   
  }


 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latest Adoptions"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'My Adoptions',
            onPressed: () {
                         
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (pets.contains(null) || pets.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return getCard(pets[index]);
        });
  }

  Widget getCard(item) {
    var id = item['ID'];
    var name = item['name'];
    var animaltype = item['animaltype'];
    var profileUrl =
        'https://cdn.discordapp.com/attachments/537753005953384448/838351477395292210/f_00001b.png';
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => buildShowAdoption(item),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60 / 2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(profileUrl))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 190,
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 17),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        animaltype.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      
                    ],
                    
                  ),
                   IconButton(
        
            icon: const Icon(Icons.delete,color:Colors.red),
            onPressed: () {
            
            },
          ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildShowAdoption(item) {
    var id = item['ID'];
    var name = item['name'];
    var animaltype = item['animaltype'];
    var race = item['race'];
    return new AlertDialog(
      
      title: const Text('Pet Perfil'),
      
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(id.toString()),
          Text(name.toString()),
          Text(animaltype.toString()),
          Text(race.toString()),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
       
      ],
      
    );
  }

  Widget _buildAddAdoption() {
    
    return new AlertDialog(
      content: Stack(
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Pet Name"),
                    controller: _nameController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectFormField(
                    decoration: InputDecoration(labelText: "Animal Type"),
                    type: SelectFormFieldType.dropdown,
                     items: petsType,
                    controller: _animaltypeController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Race"),
                    controller: _raceController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text("Submit"),
                    onPressed: () {
                      var name = _nameController.text;
                      var animaltype = _animaltypeController.text;
                      var race = _raceController.text;
                      print(race+  " " + animaltype +  " "+ name);
                     //
                      Navigator.of(context).pop();
                   
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}
