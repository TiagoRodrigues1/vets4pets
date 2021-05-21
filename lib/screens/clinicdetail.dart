import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../jwt.dart';
import 'package:table_calendar/table_calendar.dart';

import 'appointment.dart';

class ClinicDetailPage extends StatefulWidget {
  final Map<String, dynamic> clinic;

  ClinicDetailPage({Key key, this.clinic}) : super(key: key);

  _ClinicDetailPageState createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  List pets = [];
  List vets = [];
  bool isLoading = false;

  void initState() {
    super.initState();
    this.getPets();
    this.getVets();
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

      pets = items;
      isLoading = false;
    } else {
      pets = [];
      isLoading = false;
    }
  }

  getVets() async {
    var jwt = await storage.read(key: "jwt");
    int id = widget.clinic['ID'];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/vetsClinic/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      vets = items;
      isLoading = false;
    } else {
      vets = [];
      isLoading = false;
    }
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fundo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    String profileUrl = widget.clinic['profilePicture'];

    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);

    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(bytes),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Color.fromRGBO(82, 183, 136, 1),
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    final String _status = widget.clinic['name'].toString();
    return new Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.white24),
          ),
          child: Center(
            child: Text(
              _status,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          )),
    );
  }

  Widget _buildBio(BuildContext context) {
    final String _bio = widget.clinic['description'].toString() +
        "                                                                                                \n";

    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Overview:\n",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            _bio,
            textAlign: TextAlign.center,
            style: bioTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            "Morada\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.clinic['address'] + "\n",
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
          Text(
            "Telemovel\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          new InkWell(
            child: Text(
              widget.clinic['contact'] + "\n",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF799497),
              ),
            ),
            onTap: () {
              _makingPhoneCall(context);
            },
          ),
          Text(
            "Email\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.clinic['email'] + "\n",
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
        ],
      ),
    );
  }

  _makingPhoneCall(urlx) async {
    const url = '910720177';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: new Container(
                margin: const EdgeInsets.only(left: 70, right: 70),
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(82, 183, 136, 1),
                ),
                child: Center(
                  child: Text(
                    "APPOINTMENT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {

                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppointmentPage(clinic: widget.clinic)),
                  );
                /* showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildCreateAppointmentStep1(context, 1),
                );*/
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinic profile"),
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  _buildProfileImage(),
                  _buildStatus(context),
                  _buildBio(context),
                  SizedBox(height: 20.0),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  _buildGetInTouch(context),
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAppointmentStep1(context, step) {
    String stringStep;
    double percentage;
    if (step == 1) {
      stringStep = "Choose your pet";
      percentage = 0.0;
    } else if (step == 2) {
      stringStep = "Choose your vet";
      percentage = 0.33;
    } else if (step == 3) {
      stringStep = "Choose your date";
      percentage = 0.66;
    } else {
      stringStep = "Nice maite";
      percentage = 1.0;
    }
    return SimpleDialog(
      title: Text(
        stringStep,
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 50,
          margin: EdgeInsets.only(left: 30.0, right: 30),
          child: new LinearPercentIndicator(
            animation: true,
            lineHeight: 20.0,
            animationDuration: 1000,
            animateFromLastPercent: true,
            percent: percentage,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.greenAccent,
          ),
        ),
        
      ],
    );
  }

 
  Widget getCardPet(item, flag) {
    var name = item['name'];
    var animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];
    profileUrl = profileUrl.substring(23, profileUrl.length);

    Uint8List bytes = base64.decode(profileUrl);
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            if (flag == 1) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 2),
              );
            } else if (flag == 2) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 3),
              );
            } else {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 4),
              );
            }
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
                          image: MemoryImage(bytes),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 220,
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
                ],
              ),
            ),
          ),
        ));
  }

  Widget getCardVet(item, flag) {
    var name = item['name'];
    var animaltype = item['contact'];
    String profileUrl = item['profilePicture'];

    profileUrl = profileUrl.substring(23, profileUrl.length);

    Uint8List bytes = base64.decode(profileUrl);
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            if (flag == 1) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 2),
              );
            } else if (flag == 2) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 3),
              );
            } else {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildCreateAppointmentStep1(context, 4),
              );
            }
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
                          image: MemoryImage(bytes),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 220,
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
                ],
              ),
            ),
          ),
        ));
  }
}
