import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert' show base64, base64Encode;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import 'dart:convert' as convert;
import '../extras/jwt.dart';

class EditPetPage extends StatefulWidget {
  final Map<String, dynamic> pet;
  EditPetPage({Key key, this.pet}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  // ignore: avoid_init_to_null
  File _image = null;
  final picker = ImagePicker();

  String animalTypeValue, raceValue, cityValue;
  bool _validate_name = false,_validate_type = false,_validate_race = false;

  List animalTypeList = [
    "Dog",
    "Cat",
    "Turtle",
    "Guinea-Pig",
    "Hamster",
    "Snake",
    "Bird",
    "Other"
  ];

  Map<String, List<String>> data = {
    'Dog': [
      'Labrador Retriever',
      'German Shepherd',
      'Golden Retriever',
      'Bulldog',
      'Beagle',
      'French Bulldog',
      'PitBull',
      'Yorkshire Terrier',
      'Poodle',
      'Rottweiler',
      'Boxer',
      'Husky',
      'Other'
    ],
    'Turtle': [
      'Chelidae',
      'Red-Eared Slider',
      'Yellow-Bellied Slider',
      'Eastern Box',
      'Other'
    ],
    'Cat': [
      'Devon Rex',
      'Abyssinian',
      'Sphynx',
      'Scottish Fold',
      'American Shorthair',
      'Maine Coon',
      'Persian',
      'British Shorthair',
      'Ragdoll Cats',
      'Exotic Shorthair',
      'Other'
    ],
    'Guinea-Pig': [
      'Abyssinian',
      'Alpaca',
      'American',
      'Baldwin',
      'Coronet',
      'Himalayan',
      'Other'
    ],
    'Hamster': [
      'Syrian',
      'Winter White',
      'Campbell’s Dwarf',
      'Roborovski',
      'Chinese',
      'Other'
    ],
    'Snake': [
      'Smooth Green',
      'Ringneck Snake',
      'Rainbow Boa',
      'Carpet Python',
      'Corn Snake',
      'California King',
      'Other'
    ],
    'Bird': [
      'Budgerigar',
      'Cockatiel',
      'Cockatoo',
      'Hyacinth Macaw',
      'Parrotlet',
      'Green-Cheeked Conure',
      'Hahn’s Macaw',
      'Other'
    ],
    'Other': ['N/A'],
  };

  @override
  void initState() {
    animalTypeValue = widget.pet['animaltype'];
    raceValue = widget.pet['race'];
       if(widget.pet['animaltype']=="N/A"){
      animalTypeValue="Other";
      raceValue=null;
    }
    if(widget.pet['race']=="N/A"){
      raceValue=null;
    }
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

  editPet(String name, String animaltype, String race, String picture,
      BuildContext context) async {
    print(name);
    int id = widget.pet['ID'];
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);

    int id_user = results["UserID"];

    var response = await http.put(
      Uri.parse('http://52.47.179.213:8081/api/v1/animal/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "name": name,
          "userID": id_user,
          "race": race,
          "animaltype": animaltype,
          "profilePicture": picture,
          "picture": picture,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController =
        TextEditingController(text: widget.pet['name']);

            String profileUrl = widget.pet['profilePicture'];
        
    Uint8List bytes=null;
    if(profileUrl!="" && profileUrl!=null  ){
   profileUrl = profileUrl.substring(23, profileUrl.length);
     bytes = base64.decode(profileUrl);
    }
 
 
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Pet"),
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
                                        backgroundImage:  bytes==null
                                            ? AssetImage(
                                                "assets/images/petdefault.jpg")
                                            : MemoryImage(bytes),
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
                        'Edit Pet',
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
                        hintText: _validate_name ? null : 'Pet name',
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
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                       border: _validate_type?Border.all(width: 2.0, color: Colors.red[300]):null,
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
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  isExpanded: true,
                                  focusColor: Colors.green,
                                  hint: Text("Animal Type"),
                                  value: animalTypeValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      animalTypeValue = newValue;
                                        _validate_type=false;
                                      raceValue = null;
                                    });
                                  },
                                  items: animalTypeList.map((valueType) {
                                    return DropdownMenuItem(
                                      value: valueType,
                                      child: Text(valueType),
                                    );
                                  }).toList(),
                                ))),
                          )
                        ],
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          border: _validate_race?Border.all(width: 2.0, color: Colors.red[300]):null,
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
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  isExpanded: true,
                                  focusColor: Colors.green,
                                  hint: Text("Race"),
                                  value: raceValue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      raceValue = newValue;
                                      _validate_race=false;

                                    });
                                  },
                                  items:  animalTypeValue != null && animalTypeValue != "Other"
                                      ? data[animalTypeValue].map((valueType) {
                                          return DropdownMenuItem(
                                            value: valueType,
                                            child: Text(valueType),
                                          );
                                        }).toList()
                                      : null,
                                ))),
                          )
                        ],
                      )),
                  Spacer(),
                  InkWell(
                    onTap: () async {

                    setState(() {
                        _nameController.text.isEmpty ||  _nameController.text.length>20 ||_nameController.text.length<3
                            ? _validate_name = true
                            : _validate_name = false;
                        animalTypeValue==null
                             ? _validate_type = true 
                            : _validate_type = false;
                        raceValue==null
                             ? _validate_race = true 
                            : _validate_race = false;
                      });
                    if (_validate_name != true && _validate_type!= true && _validate_race != true) {
                      var name = _nameController.text;

                             String type= animalTypeValue;
                          String race= raceValue;
                
                      if (animalTypeValue!= "Other" && raceValue=="Other") {
                        
                        race = "N/A";
                      }
                      if (animalTypeValue== "Other") {
                        type="N/A";
                        race = "N/A";
                      }


                      if (_image != null) {
                        List<int> imgBytes = await _image.readAsBytes();
                        String base64img = base64Encode(imgBytes);
                        String prefix = "data:image/jpeg;base64,";
                        base64img = prefix + base64img;

                        editPet(name, type, race, base64img,
                            context);
                      } else {
                        editPet(name, type, race,
                            widget.pet['picture'], context);
                      }
                      Navigator.of(context).pop();
                    }
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
                          'Save'.toUpperCase(),
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

    String validateName(String value) {
  
  if(value.isEmpty){
    return "Name can't be empty";
  }
  if (value.length < 3)  {
    return "Name is to small ";
  }
  if (value.length > 20)  {
    return "Name is to big ";
  }
  
  return null;
}
}
