
import 'package:flutter/material.dart';
import 'package:Vets4Pets/screens/forum/forumdetail.dart';
import 'package:image_picker/image_picker.dart';
import '../extras/jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

import '../extras/colors.dart';

class MyAnswersPage extends StatefulWidget {
  
  MyAnswersPage({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _MyAnswersPageState createState() => new _MyAnswersPageState();
}

class _MyAnswersPageState extends State<MyAnswersPage> {
  Map<String, dynamic> question;
  // ignore: avoid_init_to_null
  File _image = null;
  final picker = ImagePicker();
  final TextEditingController _questiontitleController =
      TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List answers = [];
  bool isLoading = false;

  void initState() {
    this.getAnswers();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

       
      } else {
        print('No image selected.');
      }
    });
  }

getQuestion(int id) async {

  var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('$SERVER_IP/question/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   
    if (response.statusCode == 200) {
      
      var item = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        question=item;
     
      });
      return 1;
    } 
    return 0;
}




  getAnswers() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('$SERVER_IP/answersByUser/$id'),
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

  addQuestion(String title, String question, String attachament) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    await http.post(
      Uri.parse('$SERVER_IP/question/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "question": question,
          "userID": id,
          "attachement": attachament,
          "closed": false,
          "answers": 0,
          "questiontitle": title
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: new Text(
          "My responses",
          textScaleFactor: 1.3,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            tooltip: 'Post something',
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildQuestion(),
              );
            },
          ),
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget _buildQuestion() {
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
                        decoration: InputDecoration(labelText: "Title"),
                        controller: _questiontitleController,
                        validator: (value) {
                          if (value.length < 5 || value.isEmpty) {
                            return 'Title is to short';
                          } else if (value.length > 50) {
                            return 'Title is to long';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: "Question"),
                        controller: _questionController,
                        validator: (value1) {
                          if (value1.length < 75 || value1.isEmpty) {
                            return 'Question is to short';
                          }
                          return null;
                        },
                      ),
                    ),
                    ClipRRect(
                        child: InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: _image == null
                          ? CircleAvatar(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12.0,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 15.0,
                                    color: Color(0xFF404040),
                                  ),
                                ),
                              ),
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage("assets/images/defaultphoto.jpg"),
                            )
                          : CircleAvatar(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12.0,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 15.0,
                                    color: Color(0xFF404040),
                                  ),
                                ),
                              ),
                              radius: 50.0,
                              backgroundImage: FileImage(File(_image.path)),
                            ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text("Submit"),
                        style: TextButton.styleFrom(
                          primary: Colors.green[300],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {

                            var title = _questiontitleController.text;
                            var question = _questionController.text;
                            if (_image != null) {
                              List<int> imgBytes = await _image.readAsBytes();
                              String base64img = base64Encode(imgBytes);
                              String prefix = "data:image/jpeg;base64,";
                              base64img = prefix + base64img;
                              addQuestion(title, question, base64img);
                            } else {
                              addQuestion(title, question, null);
                            }

                            Navigator.of(context).pop();
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

  Widget getBody() {

    if(answers.length==0){
       return Center(child: Text("No answers :("));
    }
    if (answers.contains(null) || answers.length == 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: answers.length,
        itemBuilder: (context, index) {
          return entryItem(context, answers[index]);
        });
  }

  void _onSearchPressed() {
    Navigator.pop(context);
  }

  Widget entryItem(context, item) {
  var date = item['CreatedAt'];
  DateTime now = DateTime.now();
  var timezoneOffset1 = now.timeZoneOffset;
  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
  parseDate = parseDate.add(timezoneOffset1);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
 
  String answer = item['answer'];
  

  if ( answer.length > 25) {
     answer =  answer.substring(0, 17);
    answer =  answer + " ...";
  } else {
     answer =  answer;
  }

  return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: new BoxDecoration(
                 color: AppColorsTheme.myTheme.secondaryGradientColor,

        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
      ),
      child: new ListTile(
        title:new Text(answer),
        subtitle: Text("Answered on: " +outputDate),
      
        trailing: new Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: <Widget>[
            
            
          ]),
        ),
        onTap: () async {
         
          var flag=await getQuestion(item['QuestionID']);
          if(flag==1){
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForumDetailPage(question: question)),
          );
          }else{
            showDialog(
                    context: context,
                    builder: (BuildContext context) => _showDialog(context),
                  );
          }
        },
      ));
}

Widget _showDialog(context) {
    return AlertDialog(
      title: new Text(
        "Error",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content:
          new Text("Question was deleted!", textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}



