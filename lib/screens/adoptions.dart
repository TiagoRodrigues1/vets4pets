import 'dart:io';
import 'dart:typed_data';
import 'package:Vets4Pets/models/animaltypes.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Vets4Pets/screens/addadoption.dart';
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
      var items =json.decode(utf8.decode(response.bodyBytes))['data'];
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
                builder: (BuildContext context) => AddAdoptionPage(),
              );
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (adoptions.contains(null) || adoptions.length == 0 || isLoading) {
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
     String profileUrl = item['attachement1'];
    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);
    
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
                           image: MemoryImage(bytes),)),
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



 
}
