import 'dart:io';

import '../models/animal.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



final storage = FlutterSecureStorage();


  class PetsPage extends StatelessWidget{

 Future <List<Animal>> GetPets(int id) async {
    var response = await http.get(
        Uri.parse('http://52.47.179.213:8081/api/v1/animal/$id'),
         headers: {HttpHeaders.authorizationHeader: ""},
        );
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return json.decode(response.body)['data'];
      }
    } else {
      print("User $id as no pets");
    }
  }



 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: GetPets(1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(snapshot.data[index]['picture']['large'])),
                              title: Text(snapshot.data.id),
                              subtitle: Text(snapshot.data.name),
                              trailing: Text(snapshot.data.animaltype),
                            )
                          ],
                        ),
                      );
                  });
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
      ),
    );
  }

}

/*
class PetsPage extends StatefulWidget {
   PetsPage({Key key}) : super(key: key);

  @override
  _PetsPage createState() => _PetsPage();
}


class _PetsPage extends StatelessWidget {
  late Future<Animal> futurePets;

  @override
  void initState() {
    super.initState();
    futurePets = GetPets(1);
}



 


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Animal>(
            future: futurePets,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.id);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
*/
