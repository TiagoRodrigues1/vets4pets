import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'forum.dart';

import 'dart:io';
import 'package:hello_world/models/animaltypes.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'adoptiondetails.dart';


var ForumPostArr = [
  new ForumPostEntry("User1", "2 Days ago", 0, 0,
      "HelloHello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,Hello,"),
  new ForumPostEntry("User2", "23 Hours ago", 1, 0,
      "TEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTO"),
  new ForumPostEntry(
      "User3", "2 Days ago", 5, 0, "TEXTOTEXTOTEXTOTEXTOTEXTOTEXTOTEXTOtate."),
  new ForumPostEntry("User4", "2 Days ago", 0, 0,
      "TOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTE"),
  new ForumPostEntry("User4", "2 Days ago", 0, 0,
      "TOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTE"),
  new ForumPostEntry("User4", "2 Days ago", 0, 0,
      "TOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTE"),
  new ForumPostEntry("User4", "2 Days ago", 0, 0,
      "TOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTETOTE"),
];

class ForumDetailPage extends StatefulWidget {
  final Map<String, dynamic> question;
  
  ForumDetailPage({Key key, this.question}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {

  List answers=[];
      bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getAnswers(widget.question['ID']);
  }

  
 getAnswers(int id) async {
   var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/answer/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
  print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
       answers = items;
        isLoading = false;
      });
      print(json.decode(response.body)['data']);
    } else {
      answers = [];
      isLoading = false;
  }
  }










  Widget build(BuildContext context) {
    print(widget.question);
    var date = widget.question['CreatedAt'];
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    //print(outputDate);

    var questionSection = new Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0)),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 50.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("User" + widget.question['ID'].toString()),
                      Text(widget.question['questiontitle']),
                    ],
                  ),
                ),
                Text(outputDate),
              ],
            ),
          ),
          new Container(
            width: 400,
            margin: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0))),
            child: Text(widget.question['question']),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Forum Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[questionSection, getResponses()],
        ),
      ),
    );
  }

 Widget getResponses() {
    if (answers.contains(null) || answers.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: answers.length,
        itemBuilder: (context, index) {
          return getCard(answers[index]);
        });
  }
}

class ForumPostEntry {
  final String username;
  final String hours;
  final int likes;
  final int dislikes;
  final String text;

  ForumPostEntry(
      this.username, this.hours, this.likes, this.dislikes, this.text);
}

 Widget getCard(item){
    var date = item['CreatedAt'];
    DateTime parseDate =new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return new Container(
      margin: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        color: Colors.green[100],
        borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0)),
            ),
            child: new Row(
              children: <Widget>[
                new Icon(
                  Icons.person,
                  size: 50.0,
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(item['UserID'].toString()),
                     
                    ],
                  ),
                ),
                 new Text(outputDate),
              ],
            ),
          ),
          new Container(
            width: 400,
            margin: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
            padding: const EdgeInsets.all(8.0),
            decoration: new BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0))),
            child: new Text(item['answer']),
          ),
        ],
      ),
    );
  }

