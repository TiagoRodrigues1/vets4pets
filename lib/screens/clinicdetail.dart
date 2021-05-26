import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'appointment.dart';

class ClinicDetailPage extends StatefulWidget {
  final Map<String, dynamic> clinic;

  ClinicDetailPage({Key key, this.clinic}) : super(key: key);

  _ClinicDetailPageState createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  List pets = [];
  List vets = [];
  bool isLoading = false;

  void initState() {
    super.initState();
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

  Widget _buildProfileImage() {
    String profileUrl = widget.clinic['profilePicture'];
    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);

    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(bytes),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Color.fromRGBO(82, 183, 136, 1),
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    final String _status = widget.clinic['name'].toString();
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
              _status,
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
    final String _bio = widget.clinic['description'].toString() +
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
            "Overview:\n",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            _bio,
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
            "Morada\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.clinic['address'] + "\n",
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
          Text(
            "Telemovel\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          new InkWell(
            child: Text(
              widget.clinic['contact'] + "\n",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF799497),
              ),
            ),
            onTap: () {
              _makingPhoneCall(context);
            },
          ),
          Text(
            "Email\n",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.clinic['email'] + "\n",
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF799497),
            ),
          ),
        ],
      ),
    );
  }

  _makingPhoneCall(urlx) async {
    const url = '910720177';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: new Container(
                margin: const EdgeInsets.only(left: 70, right: 70),
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(82, 183, 136, 1),
                ),
                child: Center(
                  child: Text(
                    "APPOINTMENT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              onTap: () {

                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppointmentPage(clinic: widget.clinic)),
                  );
               
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinic profile"),
      ),
      body: Stack(
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
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
 

}
