import 'dart:io';
import 'package:hello_world/models/animaltypes.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;
import '../jwt.dart';
import 'clinicdetail.dart';
import 'leftside_menu.dart';

class ClinicPage extends StatefulWidget {
  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 65;
}

class _ClinicPageState extends State<ClinicPage> {
  List pets = [];
  List<Map<String, dynamic>> petsType = animalTypes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getPets();
  }

  getPets() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/userAnimals/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        pets = items;
        isLoading = false;
      });
    } else {
      pets = [];
      isLoading = false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinics"),
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClinicDetailPage()),
        );
      },
      child: new Container(
        height: 140.0,
        margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ),
      ),
    );
  }

  final planetThumbnail = new Container(
    alignment: new FractionalOffset(0.0, 0.5),
    margin: const EdgeInsets.only(left: 13.0),
    child: new Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(right: 100),
        child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(Constants.avatarRadius)),
            child: Image.network(
              "https://breed.pt/wp-content/uploads/2019/07/IMG_6297.jpg",
              fit: BoxFit.fill,
              width: 100,
            )),
      ),
    ),
  );

  final planetCard = new Container(
    margin: const EdgeInsets.only(left: 62.0, right: 34.0),
    decoration: new BoxDecoration(
      border: Border.all(
        color: Colors.green[300],
        width: 2,
      ),
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
            color: Colors.black, blurRadius: 8.0, offset: new Offset(0.0, 1.0))
      ],
    ),
    child: new Padding(
      padding: const EdgeInsets.only(top: 17.0),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Nome, "),
            new Text("Rua"),
            new Container(
                color: const Color(0xFF00C6FF),
                width: 24.0,
                height: 1.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0)),
            new Row(
              children: <Widget>[
                new Icon(Icons.location_on,
                    size: 14.0, color: Colors.green[300]),
                new Text("Location"),
                new Container(width: 24.0),
                new Icon(Icons.access_time,
                    size: 14.0, color: Colors.green[300]),
                new Text("Open/Not"),
              ],
            )
          ],
        ),
      ),
    ),
  );

  Widget _showDialog(int id) {
    return AlertDialog(
      title: new Text(
        "Delete pet",
        textAlign: TextAlign.center,
      ),
      content: new Text("Are you sure that you want to delete this pet?",
          textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
          child: new Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 178),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: new Text("Yes"),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
