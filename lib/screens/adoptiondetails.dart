import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AdoptionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> animal;

  AdoptionDetailsPage({Key key, this.animal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
 String profileUrl = animal['attachement1'];
    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);

 String profileUrl2 = animal['attachement2'];
    profileUrl2 = profileUrl2.substring(23, profileUrl2.length);
    Uint8List bytes2 = base64.decode(profileUrl2);

     String profileUrl3 = animal['attachement3'];
    profileUrl3 = profileUrl3.substring(23, profileUrl3.length);
    Uint8List bytes3 = base64.decode(profileUrl3);

     String profileUrl4 = animal['attachement4'];
    profileUrl4 = profileUrl4.substring(23, profileUrl4.length);
    Uint8List bytes4 = base64.decode(profileUrl4);

    final topContent = Stack(
      children: <Widget>[
        Container(
            
            height: 400,
            child: CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: [
               bytes,
              bytes2,
              bytes3,
             bytes4
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: 400,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(i),
                               fit: BoxFit.cover,
                            ),
                            color: Colors.amber),
                        );
                  },
                );
              }).toList(),
            )),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Container(
      child: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text(
                'Description:',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: Colors.green[300],
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Text(
                animal['text'],
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ],
        ),
      ),
    );

    /* */

    final readButton = Container(
      padding: EdgeInsets.only(top: 25),
      child: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text(
                'Informations:',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: Colors.green[300],
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Animal type: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['animaltype'] + "\n\n"),
                        new TextSpan(
                            text: 'Race: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['race'] + "\n\n"),
                        new TextSpan(
                            text: 'Birth: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['birth'] + "\n\n"),
                        new TextSpan(
                            text: 'Status: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(
                          children: [
                            TextSpan(
                                text: animal['adopted'] == true
                                    ? 'Adopted'
                                    : 'Not Adopted '),
                            WidgetSpan(
                                child: animal['adopted'] == true
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : const Icon(Icons.cancel,
                                        color: Colors.red)),
                          ],
                        ),
                        new TextSpan(
                          text: '\n\n',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              child: Text(
                'Contacts:',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: Colors.green[300],
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Email: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['email'] + "\n\n"),
                        new TextSpan(
                            text: 'Phone number: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['phonenumber'] + "\n\n"),
                        new TextSpan(
                            text: 'City: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: animal['city'] + "\n\n"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[topContent, bottomContent],
        ),
      ),
    );
  }
}
