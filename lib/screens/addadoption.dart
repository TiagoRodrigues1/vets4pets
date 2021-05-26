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
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

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
    print(response.body);
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
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: _animaltypeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.pets,
                          color: Color(0xFF52B788),
                        ),
                        hintText: 'Pet Type',
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

                       addAdoption("name", "xd","animaltype", "race","base64img","2021","kkkkk""XD","xddd",base64img,base64img2,base64img3,base64img4,context);
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
