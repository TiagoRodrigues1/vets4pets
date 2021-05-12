import 'package:flutter/material.dart';
import 'package:hello_world/screens/forumdetail.dart';
import 'colors.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;
import 'adoptiondetails.dart';
import '../jwt.dart';
import 'leftside_menu.dart';


class ForumPage extends StatefulWidget {
  ForumPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForumPageState createState() => new _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List questions = [];
  bool isLoading = false;

   void initState() {
    super.initState();
    this.getQuestions();
  }

    getQuestions() async {
    var jwt = await storage.read(key: "jwt");
    //var results = parseJwtPayLoad(jwt);
    

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/questions'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    //print(response.body);
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
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
        ],
      ),
      body: getBody(),
       

    );
  }


 Widget getBody() {
    if (questions.contains(null) || questions.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return entryItem(context,questions[index]);
        });
  }
  void _onSearchPressed() {
    Navigator.pop(context);
  }
}

Widget entryItem (context ,item) {
  print(item);
  var title=item['questiontitle'];
  var answers=item['answers'];
  var question=item['question'];
  var closed=item['closed'];
  var id=item['ID'];
  var username=item['UserID'];

    if (question.length > 20) {
     question = question.substring(0, 23);
     question = question + " ...";
    } else {
    question = question.description;
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
                  builder: (context) =>ForumDetailPage(question: item)),
            );
          },
        ));
  
}
