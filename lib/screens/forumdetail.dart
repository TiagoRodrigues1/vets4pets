import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' show json;
import 'dart:convert' as convert;
import 'showpic.dart';

class ForumDetailPage extends StatefulWidget {
  final Map<String, dynamic> question;

  ForumDetailPage({Key key, this.question}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _answerController = TextEditingController();
bool _switchValue;
  final _formKey = GlobalKey<FormState>();
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
    var jwt = await storage.read(key: "jwt");
    var type = await storage.read(key: "userType");
    var results = parseJwtPayLoad(jwt);
    
    int id = results["UserID"];
    String username = results["username"];
    var response = await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/answer/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "answer": answer,
          "userID": id,
          "questionID": questionid,
          "attachement": null,
          "username": username,
          "userType": type
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    sleep(Duration(seconds:1));
   
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
  
    if (response.statusCode == 200) {
      print("Answer $id was deleted");
    }
  }

  editQuestion(
    
    int id,
    bool value,
      String question,
      String attachement,
      int answers,
      String title,
    ) async {
       
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id_user = results["UserID"];
    String username = results["username"];

    var response = await http.put(
      Uri.parse('http://52.47.179.213:8081/api/v1/question/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
         "question": question,
        "userID": id_user,
        "attachement": attachement,
        "closed": value,
        "answers":  answers,
        "questiontitle": title,
        "username": username
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
  
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
      onPressed: () async {
        if (flag == 1) {
          deleteQuestion(id);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          deleteAnswer(id);
          Navigator.of(context).pop();
          final result = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ForumDetailPage(
                      question: widget.question,
                    )),
          );
          if (result) {
            setState(() {});
          }
        }
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
     var date = widget.question['CreatedAt'];

      DateTime now = DateTime.now();
var timezoneOffset1 = now.timeZoneOffset;
 
 //
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
     parseDate = parseDate.add(timezoneOffset1);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss ');
    var outputDate = outputFormat.format(inputDate);

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
                      Text(widget.question['username'].toString()),
                      Text(widget.question['questiontitle']),
                    ],
                  ),
                ),
                Container(
                  child: id_user == widget.question['UserID']
                      ? Row(children: <Widget>[
                          IconButton(
                              tooltip: 'Edit this question',
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _showDialogStatus(context,widget.question),
                                );
                              }),
                          IconButton(
                              tooltip: 'Delete this question',
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
                      : Text(""),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  child: Column(children: <Widget>[
                Text(widget.question['question']),
                widget.question['attachement'] != ""
                    ? Row(children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoPage(
                                      image: widget.question['attachement'])),
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Photo",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ])
                    : Text(""),
                Row(children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text("Posted on: " + outputDate),
                  ),
                  Spacer(),
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.question_answer_outlined),
                      color: Colors.green[300],
                      tooltip: 'Answer this question',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildAnswer(),
                        );
                      },
                    ),
                  ),
                ])
              ])),
            ),
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

      DateTime now = DateTime.now();
var timezoneOffset1 = now.timeZoneOffset;
 
 //
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
     parseDate = parseDate.add(timezoneOffset1);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm:ss ');
    var outputDate = outputFormat.format(inputDate);
    return new Container(
      margin: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        color:  item['userType'].toString()=="vet"?Colors.blue[100]
              :Colors.green[100],
        borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color:   item['userType'].toString()=="vet"?Colors.blue[100]
              :Colors.green[100],
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
                      item['userType'].toString()=="vet"?Row(children: [
                          new Text(item['username'].toString()),
                          Icon(Icons.verified_outlined,
                                  color: Colors.blue),
                      ],)
                      :Text(item['username'].toString()),
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
          Container(
            width: 400,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.length < 10 || value.isEmpty) {
                            return 'Answer is to short';
                          }
                          return null;
                        },
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            var answer = _answerController.text;

                            addAnswer(answer, widget.question['ID'], "");
                            
                            Navigator.of(context).pop();
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForumDetailPage(
                                        question: widget.question,
                                      )),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

    Widget _showDialogStatus(context,item) {
     
    bool _switchValue_aux=item['closed'];
     _switchValue=item['closed'];

    return SimpleDialog(
     
      children:[Container(
         margin: EdgeInsets.only(left: 73,right: 75),
        child: LiteRollingSwitch(
    value:  _switchValue,
    textOn: 'Closed',
    textOff: 'Not closed',
    colorOn: Colors.greenAccent[700],
    colorOff: Colors.redAccent[700],
    iconOn: Icons.done,
    iconOff: Icons.remove_circle_outline,
    textSize: 12.0,
    onChanged: (bool state) {
    
   _switchValue=state;
      print('Current State of SWITCH IS: $state');
    
 
    
    },
),
),
 new TextButton(
          child: new Text("Save",style: TextStyle(fontWeight: FontWeight.bold),),
          onPressed: () {
            if( _switchValue_aux==_switchValue){
            Navigator.of(context).pop();
            }else{
              editQuestion(item['ID'],_switchValue,item['question'],item['attachement'],item['answers'],item['questiontitle']);
             Navigator.of(context).pop();
            }
           
          },
        )
]   
    );
  }
}
