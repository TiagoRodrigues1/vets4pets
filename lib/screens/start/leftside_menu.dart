import 'dart:core';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:Vets4Pets/main.dart';
import 'package:Vets4Pets/screens/pets/pets.dart';
import 'package:Vets4Pets/screens/adoptions/adoptions.dart';
import 'package:Vets4Pets/screens/adoptions/myadoptions.dart';
import 'package:Vets4Pets/screens/clinic/clinics.dart';
import 'package:Vets4Pets/screens/user/userprofile.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../extras/jwt.dart';
import '../../main.dart';
import '../pets/addpet.dart';
import '../forum/forum.dart';
import 'login_screen.dart';
import '../maps/maps.dart';
import '../forum/myanswers.dart';
import '../forum/myquestions.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';



class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String picture, username, contact, email, name;
  bool gender;
  List appointments = [], appointments_aux = [];
  List pets = [], pets_aux;
  bool isLoading1 = true, isLoading2 = true;
  Map<String, dynamic> pet = null;
  Map<String, dynamic> vet = null;
  @override
  void initState() {
    super.initState();
    this.getData();
    this.getPets();
    this.getAppointements();
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
        pets_aux = items;
        isLoading1 = false;
        int i = 0;
        pets_aux.forEach((element) {
          if (i < 3) {
            pets.add(element);
            i++;
          }
        });
      });
    } else {
      pets = [];
      isLoading1 = false;
    }
  }

   getVet(int id) async {
    var jwt = await storage.read(key: "jwt");
    
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/user/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    vet=null;
    
    if (response.statusCode == 200) {
      var item = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        vet = item;
     //  log(vet.toString());
      });
    } 
  }

   getPet(int id) async {
    var jwt = await storage.read(key: "jwt");
   

   
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/animal/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    pet=null;
    
    if (response.statusCode == 200) {
      var item = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        pet = item;
        log(pet.toString());
      });
    }
  }

 getAppointements() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);

    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/appointmentOfuser/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        appointments_aux = items;
        isLoading2 = false;
        DateTime now= DateTime.now();
        appointments_aux.forEach((element) {
           DateTime parseDated = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(element['date']);
         
              if(parseDated.compareTo(now)>0){
                
                appointments.add(element);
              }
        });


      });
    } else {
      isLoading2 = false;
      appointments = [];
    }
  }




Widget _showDialogInfo(item) {
   
  
     String profileUrl = pet['profilePicture'];

    Uint8List bytes = null,bytes2=null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }
     

      String profileUrl2 = vet['profilePicture'];
 if (profileUrl2 != "" && profileUrl2 != null) {
      profileUrl2 = profileUrl2.substring(23, profileUrl2.length);
      bytes2 = base64.decode(profileUrl2);
    }


    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);

      return AlertDialog(
        content:  Container(
          child: Column(
        children: [
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:bytes==null?AssetImage("assets/images/petdefault.jpg"):MemoryImage(bytes),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Color.fromRGBO(82, 183, 136, 1),
                  width: 5.0,
                ),
              ),
            ),
          ),
          Text("\nPet Informations:\n"),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Name: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['name'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Animal Type: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['animaltype'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Race: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['race'] + "\n",
                )
              ]),
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                   image:bytes==null?AssetImage("assets/images/defaultuser.jpg"):MemoryImage(bytes2),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Color.fromRGBO(82, 183, 136, 1),
                  width: 5.0,
                ),
              ),
            ),
          ),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "\nDr/Dra \n",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "\n" + vet['name'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Contact: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  vet['contact'] + "\n",
                )
              ]),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 45,
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
            child: TextField(
              enabled: false,
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.date_range,
                  color: Color(0xFF52B788),
                ),
               
              ),
            ),
          ),
          
        ],
      )),
      );

    
  }

  buildPictures(item) {
    String profileUrl = item['profilePicture'];
    Uint8List bytes = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }
    return InkWell(
      onTap:() {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetsPage()),
              );
      },
      child:Container(
      width: MediaQuery.of(context).size.width/4.5,
      height: MediaQuery.of(context).size.width/4.5,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: bytes == null
              ? AssetImage("assets/images/petdefault.jpg")
              : MemoryImage(bytes),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(45.0),
        border: Border.all(
          color: Color.fromRGBO(82, 183, 136, 1),
          width: 3.0,
        ),
      ),
    ),
    );
  }

  buildAdd() {
   return InkWell(
      onTap:() {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetPage()),
              );
      },
      child: Container(
       width: MediaQuery.of(context).size.width/4.5,
      height: MediaQuery.of(context).size.width/4.5,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image:AssetImage("assets/images/add.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(45.0),
        border: Border.all(
          color: Color.fromRGBO(82, 183, 136, 1),
          width: 3.0,
        ),
      ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Vets4Pets'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => NavDrawer()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: getBody(),
      drawer: Container(
        width: 220,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                        image: AssetImage("assets/images/xd.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                leading: Icon(Icons.medical_services),
                title: Text('Vets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClinicPage()),
                  );
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
                },
              ),
              ExpansionTile(
                leading: Icon(Icons.favorite),
                title: Text(
                  "Adoptions",
                ),
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text('My Adoptions'),
                      onTap: () {
                         Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAdoptionsPage()),
                  );
                      }),
                  ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Latest adoptions'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdoptionsPage()),
                        );
                      }),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.people),
                title: Text("Forum"),
                children: <Widget>[
                  ExpansionTile(
                    leading: Icon(Icons.people),
                    title: Text("My Posts"),
                    children: <Widget>[
                      ListTile(
                          leading: Icon(Icons.email_rounded),
                          title: Text('My Questions'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyQuestionsPage()),
                            );
                          }),
                      ListTile(
                          leading: Icon(Icons.forward_to_inbox_rounded),
                          title: Text('My Answers'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAnswersPage()),
                            );
                          }),
                    ],
                  ),
                  ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text('Latest posts'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForumPage()),
                        );
                      }),
                ],
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Near Vets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapsPage()),
                  );
                },
              ),
              SizedBox(height: 170.0),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfilePage(
                              username: username,
                              gender: gender,
                              name: name,
                              email: email,
                              contact: contact,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _showDialog(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: appointments.length == 0
            ? <Widget>[
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Pets",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  child: getBodyUp(),
                ),
              ]
            : [
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Pets",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 7,
                    child: getBodyUp(),
                  ),
                ),
                Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(82, 183, 136, 1),
                    child: Center(
                      child: Text(
                        "Future Appointements",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height /1.6,
                    child: getBodyDown(),
                  ),
                )
              ],
      ),
    );
  }

  Widget getBodyUp() {
    if (pets.contains(null) || pets.length == 0 || isLoading1) {
      return Center(child: CircularProgressIndicator());
    }
    return Row(
      children: <Widget>[
        for (var item in pets) buildPictures(item),
        buildAdd(),
      ],
    );
  }

  Widget getBodyDown() {
    if (appointments.contains(null) ||  appointments.length == 0 || isLoading2) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return getAppointmentCard( appointments[index]);
        });
  }


 Widget getAppointmentCard(item) {
    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);
    
      DateTime now = DateTime.now();
          var timezoneOffset1 = now.timeZoneOffset;
    DateTime parseDate2 = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    parseDate2=parseDate2.add(timezoneOffset1);
    var inputDate2 = DateTime.parse(parseDate2.toString());
    var outputFormat2 = DateFormat('HH:mm');
    var outputDate2 = outputFormat2.format(inputDate2);
    final TextEditingController _dateController2 =
    TextEditingController(text: outputDate2);
   

    return Card(
      elevation: 1,
      child:InkWell(
        
        onTap: () async {
             await getVet(item['VetID']);
            
              await getPet(item['AnimalID']);
              showDialog(
                    context: context,
                    builder: (BuildContext context) => _showDialogInfo(item),
                  );
        },
      
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          enabled: false,
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: "Date :",
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.date_range,
                              color: Color(0xFF52B788),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          enabled: false,
                          controller: _dateController2,
                          decoration: InputDecoration(
                            labelText: "Hour:",
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.date_range,
                              color: Color(0xFF52B788),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50,),
                       Icon(Icons.touch_app_outlined, color: Color.fromRGBO(82, 183, 136, 1),
                  
                  ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      
      ),
      
    );
  }













  getData() async {
    var jwt = await storage.read(key: "jwt");
    picture = await storage.read(key: "profilePicture");
    var results = parseJwtPayLoad(jwt);
    username = results['username'];
    email = results['email'];
    name = results['name'];
    contact = results['contact'];
    gender = results['gender'];
  }

  Widget _showDialog(context) {
    Widget yesButton = ElevatedButton(
        style: TextButton.styleFrom(
            primary: Colors.white, backgroundColor: Colors.red[300]),
        child: new Text(
          "Yes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          storage.delete(key: "jwt");
          storage.delete(key: "profilePicture");
          Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
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
        "Logout",
        textAlign: TextAlign.center,
      ),
      content: new Text("Terminate session", textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[yesButton, noButton])
      ],
    );
  }
}
