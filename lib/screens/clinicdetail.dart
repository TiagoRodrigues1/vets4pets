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


class ClinicDetailPage extends StatefulWidget {
  _ClinicDetailPageState createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  List pets = [];
  bool isLoading = false;
  final String _status = "CLINICA VETERINARIA";
  final String _bio = "DESCRIÇAODESCRIÇAODESCRIÇAODESCRIÇAODESCRIÇAO";

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

      pets = items;
      isLoading = false;
    } else {
      pets = [];
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
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://breed.pt/wp-content/uploads/2019/07/IMG_6297.jpg'),
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
            "Value Morada\n",
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
              "910720177\n",
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
            "xd@gmail.com\n",
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
                getPets();
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildCreateAppointmentStep1(context),
                );
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

  Widget _buildCreateAppointmentStep1(context) {
     
    return SimpleDialog(
      title: Text("Choose a Pet",   textAlign: TextAlign.center,),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(40.0),
            child: new LinearPercentIndicator(
              width: 250,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: 0.0,
    
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),
          ),
          Container(
            width: 400,
            height: 400,
            child: ListView.builder(
               shrinkWrap: true,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return getCard(pets[index],1);
                }),
          ),
        ],
     
    );
  }
  Widget _buildCreateAppointmentStep2(context) {
     
    return SimpleDialog(
      title: Text("Choose a Vet",   textAlign: TextAlign.center),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(40.0),
            child: new LinearPercentIndicator(
              width: 250,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 1000,
              percent: 0.33,
    
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),
          ),
          Container(
            width: 400,
            height: 400,
            child: ListView.builder(
               shrinkWrap: true,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return getCard(pets[index],2);
                }),
          ),
        ],
     
    );
  }
  Widget _buildCreateAppointmentStep3(context) {
     
    return SimpleDialog(
      title: Text("Choose a date",   textAlign: TextAlign.center,),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(40.0),
 child: new LinearPercentIndicator(
              width: 250,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 1000,
              
              percent: 0.66,
    
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),
          ),
          Container(
            width: 400,
            height: 400,
            child: ListView.builder(
               shrinkWrap: true,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return getCard(pets[index],3);
                }),
          ),
        ],
     
    );
  }

   Widget _buildCreateAppointmentStep4(context) {
     
    return SimpleDialog(
      title: Text("Appointement was marked",   textAlign: TextAlign.center,),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(40.0),
            //alignment: Alignment.center,
            child: new LinearPercentIndicator(
              width: 250,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 1000,
              percent: 1,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),
          ),
          Container(
            child: Text("Nice maite",   textAlign: TextAlign.center,),
            width: 400,
            height: 400,
          )

         
        ],
     
    );
  }

  Widget getCard(item,flag) {
    var name = item['name'];
    var animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];
    Uint8List bytes = base64.decode(profileUrl);
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {

            if (flag==1){
               Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildCreateAppointmentStep2(context),
                      
                );
                
            }else if(flag==2){
               Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildCreateAppointmentStep3(context),
                );
            }
            else{
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildCreateAppointmentStep4(context),
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
                          width: MediaQuery.of(context).size.width -220,
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
