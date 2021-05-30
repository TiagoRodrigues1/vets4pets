import 'package:flutter/material.dart';
import 'package:Vets4Pets/screens/forumdetail.dart';
import 'package:image_picker/image_picker.dart';
import '../jwt.dart';
import 'colors.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;

class ForumPage extends StatefulWidget {
  ForumPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForumPageState createState() => new _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  // ignore: avoid_init_to_null
  File _image = null;
  final picker = ImagePicker();
  final TextEditingController _questiontitleController =
      TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List questions = [];
  bool isLoading = false;

  void initState() {
    this.getQuestions();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        // print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getQuestions() async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/questions'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        questions = items;
        isLoading = false;
      });
    } else {
      questions = [];
      isLoading = false;
    }
  }

  addQuestion(String title, String question, String attachament) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    await http.post(
      Uri.parse('http://52.47.179.213:8081/api/v1/question/'),
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
          "Forum",
          textScaleFactor: 1.3,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            tooltip: 'Answer this question',
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
                          } else if (value.length > 20) {
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
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

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
    if (questions.contains(null) || questions.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return entryItem(context, questions[index]);
        });
  }

  void _onSearchPressed() {
    Navigator.pop(context);
  }
}

Widget entryItem(context, item) {
  var title = item['questiontitle'];
  var answers = item['answers'];
  String question = item['question'];
  var closed = item['closed'];

  if (question.length > 20) {
    question = question.substring(0, 23);
    question = question + " ...";
  } else {
    question = question;
  }

  return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: new BoxDecoration(
        color: AppColorsTheme.myTheme.secondaryGradientColor,
        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
      ),
      child: new ListTile(
        title: new Text(title),
        subtitle: new Text(question),
        leading: IconButton(
          icon: closed == true
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {},
        ),
        trailing: new Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: <Widget>[
            new Icon(
              Icons.comment,
              color: Colors.black,
            ),
            new Text(answers.toString()),
          ]),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForumDetailPage(question: item)),
          );
        },
      ));
}
