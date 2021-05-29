import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show  base64Encode;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import 'dart:convert' as convert;
import '../jwt.dart';

class AddAdoptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddAdoptionPageState();
  }
}

class _AddAdoptionPageState extends State<AddAdoptionPage> {
  File _image = null;
  File _image2 = null;
  File _image3 = null;
  File _image4 = null;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animaltypeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
 final TextEditingController _cityController = TextEditingController();
 String animalTypeValue,raceValue,cityValue;


  List animalTypeList = ["Dog", "Cat", "Turtle", "Guinea-Pig", "Hamster", "Snake", "Bird", "Other"];


  List cityList = ["Aveiro", "Beja", "Braga", "Bragança", "Castelo Branco", "Coimbra","Évora", "Faro", "Guarda", "Leiria", "Lisboa", "Portalegre","Porto", "Santarém", "Setúbal", "Viana do Castelo", "Vila Real", "Viseu"];
  Map<String, List<String>> data={'Dog': ['Labrador Retriever', 'German Shepherd','Golden Retriever','Bulldog','Beagle','French Bulldog','PitBull','Yorkshire Terrier','Poodle','Rottweiler','Boxer','Husky','Other'], 
  'Turtle': ['Chelidae','Red-Eared Slider','Yellow-Bellied Slider','Eastern Box','Other'],
  'Cat': ['Devon Rex', 'Abyssinian','Sphynx','Scottish Fold','American Shorthair','Maine Coon','Persian','British Shorthair','Ragdoll Cats','Exotic Shorthair','Other'], 
  'Guinea-Pig': ['Abyssinian', 'Alpaca','American','Baldwin','Coronet','Himalayan','Other'], 
  'Hamster': ['Syrian',  'Winter White','Campbell’s Dwarf','Roborovski','Chinese','Other'], 
  'Snake': ['Smooth Green', 'Ringneck Snake','Rainbow Boa','Carpet Python','Corn Snake','California King','Other'], 
  'Bird': ['Budgerigar', 'Cockatiel','Cockatoo', 'Hyacinth Macaw','Parrotlet','Green-Cheeked Conure','Hahn’s Macaw','Other'], 
  'Other': ['N/A'], 

  };




  @override
  void initState() {
    super.initState();
  }

  Future getImage(int number) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if(number==1)
        _image = File(pickedFile.path);
         if(number==2)
        _image2 = File(pickedFile.path);
         if(number==3)
        _image3 = File(pickedFile.path);
         if(number==4)
        _image4 = File(pickedFile.path);
        
        
      } else {
        print('No image selected.');
      }
    });
  }

  addAdoption(
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
      String picture4,
      BuildContext context) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    String username = results["username"];
    var response = await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoption/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "name": name,
          "animaltype": animaltype,
          "race": race,
          "userID": id,
          "text": text,
          "adopted": false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Adoption"),
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
                  Container(
                   width:MediaQuery.of(context).size.width ,
                      child: Stack(children: [
                    Container(
                      margin: EdgeInsets.only(top: 48),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Row(
                          children: [
                            Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.green[200],
                                        radius: 45.0,
                                        child: InkWell(
                                          onTap: () {
                                            getImage(1);
                                          },
                                    child: _image == null
                                              ? CircleAvatar(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 12.0,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        size: 15.0,
                                                        color:
                                                            Color(0xFF404040),
                                                      ),
                                                    ),
                                                  ),
                                                  radius: 40.0,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/petdefault.jpg"),
                                                )
                                              : CircleAvatar(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 12.0,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        size: 15.0,
                                                        color:
                                                            Color(0xFF404040),
                                                      ),
                                                    ),
                                                  ),
                                                  radius: 40.0,
                                                  backgroundImage: FileImage(
                                                      File(_image.path)),
                                                ),
                                        )),
                                  )),
                                  Padding(
                          padding: EdgeInsets.only(left:10),
                          child:     Align(
                        
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor: Colors.green[200],
                              radius: 45.0,
                              child: InkWell(
                                onTap: () {
                                  getImage(2);
                                },
                                child: _image2 == null
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
                                        radius: 40.0,
                                        backgroundImage: AssetImage(
                                            "assets/images/petdefault.jpg"),
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
                                        radius: 40.0,
                                        backgroundImage:
                                            FileImage(File(_image2.path)),
                                      ),
                              )),
                        )),),
                        Padding(
                          padding: EdgeInsets.only(left:10),
                          child:     Align(
                        
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor: Colors.green[200],
                              radius: 45.0,
                              child: InkWell(
                                onTap: () {
                                  getImage(3);
                                },
                                child: _image3 == null
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
                                        radius: 40.0,
                                        backgroundImage: AssetImage(
                                            "assets/images/petdefault.jpg"),
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
                                        radius: 40.0,
                                        backgroundImage:
                                            FileImage(File(_image3.path)),
                                      ),
                              )),
                        )),),
                        Padding(
                          padding: EdgeInsets.only(left:10),
                          child:     Align(
                        
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor: Colors.green[200],
                              radius: 45.0,
                              child: InkWell(
                                onTap: () {
                                  getImage(4);
                                },
                                child: _image4 == null
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
                                        radius: 40.0,
                                        backgroundImage: AssetImage(
                                            "assets/images/petdefault.jpg"),
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
                                        radius: 40.0,
                                        backgroundImage:
                                            FileImage(File(_image4.path)),
                                      ),
                              )),
                        )),),
                          
                          ],
                        )),
                  ])),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'New Adoption',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height +200,
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
                        hintText: 'Title',
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
                                raceValue=null;
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
                            hint: Text("Race"),
                            value: raceValue,
                            onChanged: (newValue) {
                              setState(() {
                                raceValue = newValue;
                              });
                            },
                            items:animalTypeValue!=null? data[animalTypeValue].map((valueType) {
                              return DropdownMenuItem(
                                value: valueType,
                                child: Text(valueType),
                              );
                            }).toList():null,
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
                      controller: _birthController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.date_range,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Birth',
                      ),
                    ),
                  ),
                       Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 200,
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
                      maxLines: null,
                      controller:  _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.edit,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Description',
                      ),
                    ),
                  ),
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Email',
                      ),
                    ),
                  ),
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
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.phone,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Contact',
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
                            value: cityValue,
                            onChanged: (newValue) {
                              setState(() {
                                cityValue = newValue;
                              });
                            },
                            items: cityList.map((valueType) {
                              return DropdownMenuItem(
                                value: valueType,
                                child: Text(valueType),
                              );
                            }).toList(),
                          ))) ,)
                         
                        ],
                      )),
                  
                
                  InkWell(
                    onTap: () async {
                      

                      List<int> imgBytes = await _image.readAsBytes();
                      String base64img = base64Encode(imgBytes);
                      String prefix = "data:image/jpeg;base64,";
                      base64img = prefix + base64img;

                      List<int> imgBytes2 = await _image2.readAsBytes();
                      String base64img2 = base64Encode(imgBytes2);
                      base64img2 = prefix + base64img2;

                      List<int> imgBytes3 = await _image3.readAsBytes();
                      String base64img3 = base64Encode(imgBytes3);
                      base64img3 = prefix + base64img3;

                      List<int> imgBytes4 = await _image4.readAsBytes();
                      String base64img4 = base64Encode(imgBytes4);
                      base64img4 = prefix + base64img4;

                      if( raceValue=="Other"){
                        raceValue="N/A";
                      }
                      if(animalTypeValue=="Other"){
                        animalTypeValue="N/A";
                        raceValue="N/A";
                      }

                       addAdoption(_nameController.text, cityValue,_textController.text,_emailController.text,_phoneController.text,_birthController.text,animalTypeValue, raceValue,base64img,base64img2,base64img3,base64img4,context);
                      Navigator.of(context).pop();


 
                    },
                    child: Container(
                      height: 45,
                                          margin: EdgeInsets.only(top: 32),

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
