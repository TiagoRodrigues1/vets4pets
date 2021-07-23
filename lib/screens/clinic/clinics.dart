import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'clinicdetail.dart';

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
 
  List clinics = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getClinics();
  }

  getClinics() async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/clinic'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        clinics = items;
        isLoading = false;
      });
    } else {
      clinics = [];
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
    if (clinics.contains(null) || clinics.length == 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          return getCard(clinics[index]);
        });
  }

  Widget getCard(item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClinicDetailPage(clinic: item)),
        );
      },
      child: new Container(
        height: 140.0,
        margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Stack(
          children: <Widget>[
            _buildCard(item),
            _buildphoto(item),
          ],
        ),
      ),
    );
  }

  Widget _buildphoto(item) {
    String profileUrl = item['profilePicture'];

    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);
    return new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 13.0),
      child: new Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(right: 100),
          child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Image.memory(
                bytes,
                fit: BoxFit.fill,
                width: 100,
              )),
        ),
      ),
    );
  }

  Widget _buildCard(item) {
    return new Container(
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
              color: Colors.black,
              blurRadius: 8.0,
              offset: new Offset(0.0, 1.0))
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
              new Text(item['name']),
              
              new Container(
                  color: Colors.green[300],
                  width: 24.0,
                  height: 1.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0)),
              new Row(
                children: <Widget>[
                  new Icon(Icons.location_on,
                      size: 14.0, color: Colors.green[300]),
                      Container(
                        width: 200,
                        height: 50,
                        child: FittedBox(child:Text(item['address']), fit: BoxFit.contain,),)
              
                 
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
