import 'dart:io';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'leftside_menu.dart';
import 'package:intl/intl.dart';
import 'dart:convert' show json;

class PetsInfoPage extends StatefulWidget {
  final Map<String, dynamic> animal;
  PetsInfoPage({Key key, this.animal}) : super(key: key);

  @override
  _PetsInfoState createState() => _PetsInfoState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _PetsInfoState extends State<PetsInfoPage> {
  List vaccines = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    this.getVaccines(widget.animal['ID']);
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
        isLoading = false;
      });
    } else {
      vaccines = [];
      isLoading = false;
    }
  }

    getHistory(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/history/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
       
      });
    } else {
     
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
        title: Text("Information about " + widget.animal['name']),
      ),
      body:  
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Vaccines"),
          SingleChildScrollView(
          child:Container(
             height: MediaQuery.of(context).size.height/2.9,
            child: getBody(),
          ),),
          SizedBox(height: 10,),
            Text("Medical History"),
              SingleChildScrollView(
          child:Container(
            
               height: MediaQuery.of(context).size.height/2.3,
            child: getBody(),
          ),)
        ],
      ),
    );
  }

  Widget getBody() {
    if (vaccines.contains(null) || vaccines.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
         scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: vaccines.length,
          itemBuilder: (context, index) {
            return getCard(vaccines[index]);
          });
    }
  }

  Widget getCard(item) {
    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);

    var date1 = item['date'];
    DateTime parseDate2 = new DateFormat("yyyy-MM-dd").parse(date1);
    var inputDate2 = DateTime.parse(parseDate2.toString());
    var outputFormat2 = DateFormat('dd/MM/yyyy');
    var outputDate2 = outputFormat2.format(inputDate2);

    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Row(children: [
                            Text(
                              "Vaccine: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item['vaccineName'],
                              style: TextStyle(fontSize: 15),
                            )
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Text(
                          "Date to take: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          outputDate,
                          style: TextStyle(fontSize: 15),
                        )
                      ]),
                      item['taken'] == true
                          ? Row(children: [
                              Text(
                                "Date taken: ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                outputDate2,
                                style: TextStyle(fontSize: 15),
                              )
                            ])
                          : Text(""),
                    ],
                  ),
                  IconButton(
                    icon: item['taken'] == true
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
