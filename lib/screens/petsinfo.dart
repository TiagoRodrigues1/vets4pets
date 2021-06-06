import 'dart:io';
import 'package:Vets4Pets/screens/graph.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
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
  List consults = [];

  List meds = [];
  bool isLoading1 = true;
  bool isLoading2 = true;
  @override
  void initState() {
    super.initState();
    this.getVaccines(widget.animal['ID']);
    this.getHistory(widget.animal['ID']);
  }

  getVaccines(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/vaccine/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        vaccines = items;
        isLoading1 = false;
      });
    } else {
      vaccines = [];
      isLoading1 = false;
    }
  }

  getHistory(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/prescription/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        consults = items;
        isLoading2 = false;
      });
    } else {
      consults = [];
      isLoading2 = false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  actions: [
          IconButton(
            tooltip: "Weight transformation",
          icon: const Icon(Icons.auto_graph, color: Colors.white,),
          onPressed: () {
         Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GraphPage(data: consults,)),
                  );
          },
        ),
  ],
        title: Text("Information about " + widget.animal['name']),
      ),
      body: vaccines.length == 0 && consults.length == 0
          ? Center(
              child: Text("No info about " + widget.animal['name'] + " :("))
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: vaccines.length == 0
                  ? [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(82, 183, 136, 1),
                        child: Text(
                          "Medical History",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SingleChildScrollView(
                          child: Container(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: getBodyHistory(),
                      )),
                    ]
                  : [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(82, 183, 136, 1),
                        child: Center(
                          child: Text(
                            "Vaccines",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.9,
                          child: getBodyVaccines(),
                        ),
                      ),
                      Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          color: Color.fromRGBO(82, 183, 136, 1),
                          child: Center(
                            child: Text(
                              "Medical History",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.3,
                          child: getBodyHistory(),
                        ),
                      )
                    ],
            ),
    );
  }

  Widget getBodyVaccines() {
    if (vaccines.contains(null) || vaccines.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: vaccines.length,
          itemBuilder: (context, index) {
            return getCard1(vaccines[index]);
          });
    }
  }

  Widget getBodyHistory() {
    if (consults.contains(null) || consults.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: consults.length,
          itemBuilder: (context, index) {
            return getCard2(consults[index]);
          });
    }
  }

  Widget getCard2(item) {
    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);

    return Card(
        elevation: 10.0,
        child: new InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 175,
                    //s height: 45,
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
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
                  Spacer(),
                  IconButton(
                    tooltip: 'Detais',
                    icon: const Icon(Icons.article_outlined,
                        color: Color.fromRGBO(82, 183, 136, 1)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _showDialog(
                          item,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getMeds(String protocol) {
    
    meds = [];
    List meds_aux;
    meds_aux = protocol.split(";");
    meds_aux.remove("");
    for (int i = 0; i < meds_aux.length; i++) {
      List meds_aux_aux;
      meds_aux_aux = meds_aux[i].toString().split("/");
      var date = meds_aux_aux[1];
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      String medication_protocol_aux = meds_aux_aux[0] +
          " starting on " +
          outputDate +
          " for " +
          meds_aux_aux[2].toString() +
          " days at " +
          meds_aux_aux[3].toString();
          
      meds.add(medication_protocol_aux);
    }
  }

  Widget _showDialog(item) {
    getMeds(item['medication']);
    String profileUrl = widget.animal['profilePicture'];
    Uint8List bytes = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);
    final TextEditingController _priceController =
        TextEditingController(text: item['price'].toString() + " €");
    final TextEditingController _weightController =
        TextEditingController(text: item['weight'].toString() + " kg");
    final TextEditingController _textController =
        TextEditingController(text: item['Description'].toString());

    return AlertDialog(
      title: new Text(
        "Details",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: bytes == null
                              ? AssetImage("assets/images/petdefault.jpg")
                              : MemoryImage(bytes),
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
                  Text("\nSome Informations:\n"),
                  Container(
                    width: 200,
                    height: 35,
                    padding:
                        EdgeInsets.only(top: 4, left: 32, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 35,
                    padding:
                        EdgeInsets.only(top: 4, left: 32, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: _weightController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.how_to_vote_outlined,
                          color: Color(0xFF52B788),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 35,
                    padding:
                        EdgeInsets.only(top: 4, left: 32, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: _priceController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.paid_outlined,
                          color: Color(0xFF52B788),
                        ),
                      ),
                    ),
                  ),
                  Text("\nAbout appointment:\n"),
                  Container(
                    padding: EdgeInsets.only(
                      left: 32,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromRGBO(82, 183, 136, 1)),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      maxLines: null,
                      enabled: false,
                      controller: _textController,
                    ),
                  ),
                  Text("\nMedication:"),
                  for (var i in meds)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        enabled: false,
                        controller: TextEditingController()..text = i,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                             TablerIcons.pill,
                            color: Color(0xFF52B788),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCard1(item) {
    var date = item['dateTaken'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _nameController =
        TextEditingController(text: item['vaccineName']);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);

    var date1 = item['validity'];
    DateTime parseDate2 = new DateFormat("yyyy-MM-dd").parse(date1);
    var inputDate2 = DateTime.parse(parseDate2.toString());
    var outputFormat2 = DateFormat('dd/MM/yyyy');
    var outputDate2 = outputFormat2.format(inputDate2);
    final TextEditingController _dateController2 =
        TextEditingController(text: outputDate2);

    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Vaccine name",
                        border: InputBorder.none,
                        icon: Icon(
                          TablerIcons.vaccine,
                          color: Color(0xFF52B788),
                        ),
                      ),
                    ),
                  ),
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
                            labelText: "Date taken:",
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.date_range,
                              color: Color(0xFF52B788),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          enabled: false,
                          controller: _dateController2,
                          decoration: InputDecoration(
                            labelText: "Validity:",
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.date_range,
                              color: Color(0xFF52B788),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
