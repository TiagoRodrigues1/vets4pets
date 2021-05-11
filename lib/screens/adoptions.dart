import 'dart:io';
import 'package:hello_world/models/animaltypes.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'adoptiondetails.dart';

class AdoptionsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<AdoptionsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animaltypeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  List adoptions = [];
  List<Map<String,dynamic>> adoptionsType = animalTypes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getAdoptions();
  }

  getAdoptions() async {
   var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/adoptionByTime'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
  
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        adoptions = items;
        isLoading = false;
      });
      print(json.decode(response.body)['data']);
    } else {
      adoptions = [];
      isLoading = false;
  }
  }

  addAdoption(String name, String animaltype, String race, BuildContext context) async {
  
  }


 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latest Adoptions"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Adoption',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAddAdoption(),
              );
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (adoptions.contains(null) || adoptions.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: adoptions.length,
        itemBuilder: (context, index) {
          return getCard(adoptions[index]);
        });
  }

  Widget getCard(item) {
    var name = item['name'];
    var animaltype = item['animaltype'];
    var race = item['race'];
    var status= item['adopted'];  
    var profileUrl =
        'https://cdn.discordapp.com/attachments/537753005953384448/838351477395292210/f_00001b.png';
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
           Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdoptionDetailsPage(animal:item)),
                    );
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
                            image: NetworkImage(profileUrl))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 190,
                          child: Text(
                            name.toString(),
                            style: TextStyle(fontSize: 15),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Type: " +
                        animaltype +" |"+ " Race: " + race,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                    // ignore: missing_required_param
                    IconButton(
                      icon: status==true?const Icon(Icons.check_circle,color:Colors.green) : const Icon(Icons.cancel ,color:Colors.red)
          ),     
                ],
              ),
            ),
          ),
        ));
  }



  Widget _buildAddAdoption() {
     return new AlertDialog(
      content: Stack(
        children: <Widget>[
        
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Title"),
                    controller: _nameController,
                  ),
                ),
                /*Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectFormField(
                    decoration: InputDecoration(labelText: "Animal Type"),
                    type: SelectFormFieldType.dropdown,
                    items: typeoptions,
                    controller: _animaltypeController,
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Race"),
                    controller: _raceController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text("Submit"),
                    style: TextButton.styleFrom(
                      primary: Colors.green[300],
                    ),
                    onPressed: () {
                      var name = _nameController.text;
                      var animaltype = _animaltypeController.text;
                      var race = _raceController.text;
                      addAdoption(race, animaltype, name, context);
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
