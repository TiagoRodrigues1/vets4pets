import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;
import 'addadoption.dart';
import 'adoptiondetails.dart';
import '../jwt.dart';
import 'leftside_menu.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';


class MyAdoptionsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<MyAdoptionsPage> {
  bool _switchValue;

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

  editAdoption(
    
    int id,
    bool value,
      String name,
      String city,
      String text,
      String email,
      String phonenumber,
      String birth,
      String animaltype,
      String race,
      String picture1,
      String picture2,
      String picture3,
      String picture4) async {
        
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id_user = results["UserID"];
    String username = results["username"];
    var response = await http.put(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "name": name,
          "animaltype": animaltype,
          "race": race,
          "userID": id_user,
          "text": text,
          "adopted": value,
          "city": city,
          "birth": birth,
          "phonenumber": phonenumber,
          "email": email,
          "username": username,
          "attachement1": picture1,
          "attachement2": picture2,
          "attachement3": picture3,
          "attachement4": picture4
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
  }

  deleteAdoption(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   
    if (response.statusCode == 200) {
      print("Pet $id was deleted");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text("My Adoptions"),
        actions: <Widget>[
           IconButton(
            icon: const Icon(
              Icons.replay_outlined,
              color: Colors.white,
            ),
            onPressed: () {
          Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));
            },
          ),
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
          return getCard(adoptions[index], context);
        });
  }

  Widget getCard(item, context) {
    var id = item['ID'];
    var name = item['name'];
    var animaltype = item['animaltype'];
    var race = item['race'];
    var status = item['adopted'];

    String profileUrl = item['attachement1'];
    Uint8List bytes = null;
    profileUrl = profileUrl.substring(23, profileUrl.length);
    bytes = base64.decode(profileUrl);

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
                            fit: BoxFit.cover, image: MemoryImage(bytes))),
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
                        "Type: " + animaltype ,
                        style: TextStyle(color: Colors.grey),
                      ),
                        Text(
                        "Race: " + race,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _showDialogStatus(context, item),
                          );
                        },
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _showDialog(id, context),
                          );
                        },
                      ),
                    ],
                  )
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
   Widget _showDialogStatus(context,item) {
     
    bool _switchValue_aux=item['adopted'];
     _switchValue=item['adopted'];

    return SimpleDialog(
     
      children:[Container(
         margin: EdgeInsets.only(left: 73,right: 75),
        child: LiteRollingSwitch(
    value:  _switchValue,
    textOn: 'Adopted',
    textOff: 'Not adopted',
    colorOn: Colors.greenAccent[700],
    colorOff: Colors.redAccent[700],
    iconOn: Icons.done,
    iconOff: Icons.remove_circle_outline,
    textSize: 12.0,
    onChanged: (bool state) {
    
   _switchValue=state;
    
    
 
    
    },
),
),
 new TextButton(
          child: new Text("Save",style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () {
            if( _switchValue_aux==_switchValue){
            Navigator.of(context).pop();
            }else{
              editAdoption(item['ID'],_switchValue,item['name'],item['city'],item['text'],item['email'],item['phonenumber'],item['birth'],item['animaltype'],item['item'],item['attachement1'],item['attachement2'],item['attachement3'],item['attachement4']);
             Navigator.of(context).pop();
            }
           
          },
        )
]   
    );
  }
}
