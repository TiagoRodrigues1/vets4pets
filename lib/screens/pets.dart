import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:Vets4Pets/screens/petsinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../jwt.dart';
import 'addpet.dart';
import 'editpet.dart';
import 'leftside_menu.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class PetsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class Constants {
  
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}



class _IndexPageState extends State<PetsPage> {
  
  List pets = [];
  bool isLoading = false;
  bool isLoading2 = false;
  var vaccines = <dynamic>[];
  int sortColumnIndex;
  bool isAscending = false;

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
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        pets = items;
        isLoading = false;
      });
    } else {
      pets = [];
      isLoading = false;
    }
  }

  getVaccines(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/vaccine/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        vaccines = items;
        isLoading2 = false;
      });
    } else {
      vaccines = [];
      isLoading2 = false;
    }
  }

  deletePet(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/animal/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

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
        title: Text("My Pets List"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Pet',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetPage()),
              );
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (pets.contains(null) || pets.length == 0 || isLoading) {
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
    String name = item['name'].toString();
    String animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];

    Uint8List bytes = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => buildShowPet(item),
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
                          image: bytes == null
                              ? AssetImage("assets/images/petdefault.jpg")
                              : MemoryImage(bytes),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 250,
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
                    icon: const Icon(Icons.edit_outlined, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPetPage(pet: item)),
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
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildShowPet(item) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, item),
    );
  }

  contentBox(context, item) {
    var name = item['name'];
    var animaltype = item['animaltype'];
    var race = item['race'];
    String profileUrl = item['profilePicture'];

    Uint8List bytes = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                animaltype,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Text(
                race,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                  tooltip: 'Pet Informations',
                  icon: const Icon(Icons.list_alt_outlined, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PetsInfoPage(
                                animal: item,
                              )),
                    );
                  },
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child: new Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Image(
                image: bytes == null
                    ? AssetImage("assets/images/petdefault.jpg")
                    : MemoryImage(
                        bytes,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
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
          deletePet(id);
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
        "Delete Pet",
        textAlign: TextAlign.center,
      ),
      content: new Text("Are you sure that you want to delete this pet?",
          textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[yesButton, noButton])
      ],
    );
  }
}
