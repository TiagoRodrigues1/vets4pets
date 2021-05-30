import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'userappointments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show base64, base64Encode;
import '../main.dart';
import 'dart:convert' as convert;
import '../jwt.dart';

class UserProfilePage extends StatefulWidget {
  final String picture, username, contact, email, name;
  final bool gender;
  UserProfilePage(
      {Key key,
      this.username,
      this.contact,
      this.gender,
      this.name,
      this.email,
      this.picture})
      : super(key: key);

  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // ignore: avoid_init_to_null
  File _image = null;
  // ignore: avoid_init_to_null
  String picture = null;

  bool button = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    this.loadPicture();
  }

  loadPicture() async {
    picture = await storage.read(key: 'profilePicture');

    setState(() {});

    print(picture);
  }

  editUserPicture(String profilePicture) async {
    //print("xd");
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    print(id);

    var response = await http.put(
      Uri.parse('http://52.47.179.213:8081/api/v1/user/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "username": widget.username,
          "name": widget.name,
          "contact": widget.contact,
          "email": widget.email,
          "gender": true,
          "profilePicture": profilePicture,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    if (response.statusCode == 200) {
      await storage.write(key: 'profilePicture', value: profilePicture);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My profile"),
        actions: button == true
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.save),
                  color: Colors.white,
                  tooltip: 'Save changes',
                  onPressed: () async {
                    List<int> imgBytes = await _image.readAsBytes();
                    String base64img = base64Encode(imgBytes);
                    String prefix = "data:image/jpeg;base64,";
                    base64img = prefix + base64img;
                    await editUserPicture(base64img);

                    setState(() {
                      //_image=null;
                      button = false;
                    });
                  },
                ),
              ]
            : <Widget>[],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    Size screenSize = MediaQuery.of(context).size;

    if (picture == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: <Widget>[
        _buildCoverImage(screenSize),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 6.4),
                _buildProfileImage(),
                _buildStatus(context),
                _buildBio(context),
                SizedBox(height: 20.0),
                _buildSeparator(screenSize),
                SizedBox(height: 10.0),
                _buildGetInTouch(context),
                SizedBox(height: 10.0),
                _buildSeparator(screenSize),
                SizedBox(height: 8.0),
                _buildButtons(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/fundo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        button = true;
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildProfileImage() {
    Uint8List bytes;
    print(picture);
    if (picture != "") {
      String profileUrl = picture;
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

    return Center(
      child: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              child: CircleAvatar(
                  backgroundColor: Colors.green[200],
                  radius: 60.0,
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
                            backgroundImage: picture != ""
                                ? MemoryImage(bytes)
                                : AssetImage("assets/images/defaultuser.jpg"),
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
                            radius: 55.0,
                            backgroundImage: FileImage(File(_image.path)),
                          ),
                  )),
            )),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.white24),
          ),
          child: Center(
            child: Text(
              widget.username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          )),
    );
  }

  Widget _buildBio(BuildContext context) {
    final String _bio = widget.name +
        "                                                                                                \n";

    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Informations:\n",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            _bio,
            textAlign: TextAlign.center,
            style: bioTextStyle,
          ),
          Text(
            widget.gender == false ? "Male" : "Female",
            textAlign: TextAlign.center,
            style: bioTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            "Contacts\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "Email: ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.email + "\n",
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
          Text(
            "PhoneNumber: ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.contact,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Ink(
            decoration: BoxDecoration(
              color: Color.fromRGBO(82, 183, 136, 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          Ink(
            decoration: BoxDecoration(
              color: Color.fromRGBO(82, 183, 136, 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.date_range),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAppointments()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
