import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' show ascii, base64, base64Encode, json;
import 'dart:convert' as convert;



class ForumDetailPage extends StatefulWidget {
  final Map<String, dynamic> question;

  ForumDetailPage({Key key, this.question}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {


  final TextEditingController _answerController = TextEditingController();
 
 
  int id_user;
  List answers = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getAnswers(widget.question['ID']);
    this.getid();
  }

 addAnswer(String answer, int questionid, String attachament) async {
    print(questionid);
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    var response = await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/answer/'),
      body: convert.jsonEncode(
        <String, dynamic>{
           "answer": answer,
            "userID": id,
            "questionID": questionid,
          "attachement": "string"
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   print(response.body);
  }


  getAnswers(int id) async {
    
    var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/answer/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        answers = items;
        isLoading = false;
      });
    } else {
      answers = [];
      isLoading = false;
    }
  }

  deleteQuestion(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/question/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("Question $id was deleted");
    }
  }

  deleteAnswer(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/answer/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("Answer $id was deleted");
    }
  }

  getid() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    id_user = results["UserID"];
  }

  Widget _showDialog(int id, context, int flag) {
    String text;
    String description;
    if (flag == 1) {
      text = "Delete Question";
      description = "Are you sure that you want to delete this question?";
    } else {
      text = "Delete Answer";
      description = "Are you sure that you want to delete this Answer?";
    }
    Widget yesButton = ElevatedButton(
      style: TextButton.styleFrom(
          primary: Colors.white, backgroundColor: Colors.red[300]),
      child: new Text(
        "Yes",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        if (flag == 1) {
          deleteQuestion(id);
        } else {
          deleteAnswer(id);
        }

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    Widget noButton = ElevatedButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      child: new Text(
        "No",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    return AlertDialog(
      title: new Text(
        text,
        textAlign: TextAlign.center,
      ),
      content: new Text(description, textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[yesButton, noButton])
      ],
    );
  }

  Widget build(BuildContext context) {
    //print(widget.question);

    var date = widget.question['CreatedAt'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss ');
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
              color: Colors.green[400],
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
                      Text("User " + widget.question['UserID'].toString()),
                      Text(widget.question['questiontitle']),
                    ],
                  ),
                ),
                Container(
                  child: id_user == widget.question['UserID']
                      ? Row(children: <Widget>[
                          Text(outputDate),
                          IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _showDialog(
                                          widget.question['ID'], context, 1),
                                );
                              }),
                        ])
                      : Text(outputDate),
                ),
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
           actions: <Widget>[
              IconButton(
            icon: const Icon(Icons.question_answer_outlined),
            color: Colors.white,
            tooltip: 'Answer this question',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAnswer(),
              );
            },
          ),
        ],
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

  Widget getCard(item) {
    var date = item['CreatedAt'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss ');
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
                      new Text("User " + item['UserID'].toString()),
                    ],
                  ),
                ),
                Container(
                  child: id_user == item['UserID']
                      ? Row(children: <Widget>[
                          Text(outputDate),
                          IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _showDialog(item['ID'], context, 2),
                                );
                              }),
                        ])
                      : Text(outputDate),
                ),
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



   Widget _buildAnswer() {
     return new AlertDialog(
      content: Stack(
        children: <Widget>[
        
          Form(
             child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: null,
    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(labelText: "Answer"),
                    controller: _answerController,
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
                      var answer = _answerController.text;
                   
                      addAnswer(answer,widget.question['ID'],"");
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
             ),
          ),
        ],
      ),
    );
  }
}
