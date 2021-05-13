import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show ascii, base64, base64Encode, json;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import 'dart:convert' as convert;
import '../jwt.dart';

class AddPetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPetPageState();
  }
}

class _AddPetPageState extends State<AddPetPage> {
  File _image = null;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animaltypeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  String animalTypeValue;
  List animalTypeList = ["Dog", "Cat", "Turtle", "Horse"];
  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  addPet(String name, String animaltype, String race, String picture,
      BuildContext context) async {
    //print(picture);
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    var response = await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/animal/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "name": name,
          "userID": id,
          "race": race,
          "animaltype": animaltype,
          "profilePicture": picture,
          "picture": picture,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Pet"),
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
                              child: InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: _image == null
                                    ? CircleAvatar(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 12.0,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 15.0,
                                              color: Color(0xFF404040),
                                            ),
                                          ),
                                        ),
                                        radius: 50.0,
                                        backgroundImage: AssetImage(
                                            "assets/images/petdefault.png"),
                                      )
                                    : CircleAvatar(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 12.0,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 15.0,
                                              color: Color(0xFF404040),
                                            ),
                                          ),
                                        ),
                                        radius: 50.0,
                                        backgroundImage:
                                            FileImage(File(_image.path)),
                                      ),
                              )),
                        )),
                  ])),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'New Pet',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
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
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.pets_sharp,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Pet name',
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                             
                             
                              child: Icon(
                                Icons.pets,
                                color: Color(0xFF52B788),
                                size: 25.0,
                              )),
                          Expanded(child:Padding(
                            padding: EdgeInsets.only(left:15),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                            focusColor: Colors.green,
                            hint: Text("Animal Type"),
                            value: animalTypeValue,
                            onChanged: (newValue) {
                              setState(() {
                                animalTypeValue = newValue;
                              });
                            },
                            items: animalTypeList.map((valueType) {
                              return DropdownMenuItem(
                                value: valueType,
                                child: Text(valueType),
                              );
                            }).toList(),
                          ))) ,)
                         
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _raceController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.pets_outlined,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Pet Race',
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      var name = _nameController.text;
                      var animaltype = _animaltypeController.text;
                      var race = _raceController.text;
                      List<int> imgBytes = await _image.readAsBytes();
                      String base64img = base64Encode(imgBytes);
                      String prefix = "data:image/jpeg;base64,";
                      base64img = prefix + base64img;
                      addPet(name, animaltype, race, base64img, context);
                      Navigator.of(context).pop();
                      /*  Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => PetsPage()),
                ); 
*/
                    },
                    child: Container(
                      height: 45,
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
                          'Create'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
