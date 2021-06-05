import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;
import 'addadoption.dart';
import 'adoptiondetails.dart';
import '../jwt.dart';
import 'leftside_menu.dart';

class MyAdoptionsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<MyAdoptionsPage> {

  List adoptions = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getAdoptions();
  }

  getAdoptions() async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/1'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        adoptions = items;
        isLoading = false;
      });
    } else {
      adoptions = [];
      isLoading = false;
    }
  }

  addAdoption(
      String name, String animaltype, String race, BuildContext context) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    var response = await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "name": name,
          "userID": id,
          "race": race,
          "animaltype": animaltype,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
  }

  deleteAdoption(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("Pet $id was deleted");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => NavDrawer()),
                (Route<dynamic> route) => false);
          },
        ),
        title: Text("My Adoptions"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Adoption',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AddAdoptionPage(),
              );
            },
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  Widget getBody(context) {
    if (adoptions.contains(null) || adoptions.length == 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: adoptions.length,
        itemBuilder: (context, index) {
          return getCard(adoptions[index],context);
        });
  }

  Widget getCard(item,context) {
    var id = item['ID'];
    var name = item['name'];
    var animaltype = item['animaltype'];
    var race = item['race'];
    var status = item['adopted'];
    var profileUrl =
        'https://cdn.discordapp.com/attachments/537753005953384448/838351477395292210/f_00001b.png';
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdoptionDetailsPage(animal: item)),
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
                            style: TextStyle(fontSize: 15),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Type: " + animaltype + " |" + " Race: " + race,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(children: [
IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _showDialog(id,context),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _showDialog(id, context),
                      );
                    },
                  ),


                  ],)
                  
                ],
              ),
            ),
          ),
        ));
  }

    Widget _showDialog(int id, context) {
    Widget yesButton = ElevatedButton(
        style: TextButton.styleFrom(
            primary: Colors.white, backgroundColor: Colors.red[300]),
        child: new Text(
          "Yes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          deleteAdoption(id);
          Navigator.pop(context);
        });

    Widget noButton = ElevatedButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      child: new Text(
        "No",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    return AlertDialog(
      title: new Text(
        "Delete Adoption",
        textAlign: TextAlign.center,
      ),
      content: new Text("Are you sure that you want to delete this adoption?",
          textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[yesButton, noButton])
      ],
    );
  }
}
