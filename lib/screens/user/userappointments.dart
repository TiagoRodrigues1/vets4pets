import 'dart:typed_data';

import '../extras/utils.dart';
import 'package:flutter/material.dart';
import '../extras/jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;

List appointments = [];

class UserAppointments extends StatefulWidget {
  final String picture, username, contact, email, name;
  final bool notifications;

  UserAppointments(
      {Key key,
      this.title,
      this.notifications,
      this.username,
      this.contact,
      this.name,
      this.email,
      this.picture})
      : super(key: key);

  final String title;

  @override
  _UserAppointmentsState createState() => new _UserAppointmentsState();
}

class _UserAppointmentsState extends State<UserAppointments> {
  Map<DateTime, List<AppEvent>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  bool not;
  TextEditingController _eventController = TextEditingController();
  Map<String, dynamic> pet = null;
  Map<String, dynamic> vet = null;
  void initState() {
    super.initState();
    this.getAppointements();
    selectedEvents = {};
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  getAppointements() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);

    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('$SERVER_IP/appointmentOfuser/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        appointments = items;

        appointments.forEach((element) {
          DateTime parseDated_ = new DateFormat("yyyy-MM-dd'T'HH:mm:ss")
              .parse(element['date']); //AS horas
          DateTime now = DateTime.now();
          var timezoneOffset1 = now.timeZoneOffset;
          parseDated_ = parseDated_.add(timezoneOffset1);
          DateTime parseDated =
              new DateFormat("yyyy-MM-dd").parse(element['date']); //Sacar o dia
          String formattedTime = DateFormat.Hm().format(parseDated_);
          parseDated = parseDated.add(timezoneOffset1);
          DateTime parseDate = parseDated.toUtc();
          if (selectedEvents[parseDate] != null) {
            selectedEvents[parseDate].add(
              AppEvent(title: formattedTime, info: element),
            );
          } else {
            selectedEvents[parseDate] = [
              AppEvent(title: formattedTime, info: element)
            ];
          }
        });
      });
    } else {
      appointments = [];
    }
  }

  getVet(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('$SERVER_IP/user/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    vet = null;

    if (response.statusCode == 200) {
      var item = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        vet = item;
        //  log(vet.toString());
      });
    }
  }

  getPet(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('$SERVER_IP/animal/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    pet = null;

    if (response.statusCode == 200) {
      var item = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        pet = item;
      });
    }
  }

  editUserNotifications(bool notification) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];

    var response = await http.put(
      Uri.parse('$SERVER_IP/user/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "username": widget.username,
          "name": widget.name,
          "contact": widget.contact,
          "email": widget.email,
          "gender": notification,
          "profilePicture": widget.picture,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    if (response.statusCode == 200) {
      
      await storage.write(key: 'notifications', value: notification.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    var height = screenSize.height;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: new Text(
          "My Appointments",
          textScaleFactor: 1.3,
        ),
        actions: [
          not == true
              ? IconButton(
                  icon: const Icon(Icons.notifications_off),
                  color: Colors.white,
                  tooltip: 'Turn off notifications',
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _showDialog(),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.notifications_on),
                  color: Colors.white,
                  tooltip: 'Turn on notifications',
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _showDialog(),
                    );
                  },
                ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                SizedBox(
                  child: getCalender(),
                  height: height + 200,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEvents() {
    if (selectedEvents[selectedDay] != null) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: selectedEvents[selectedDay].length,
          itemBuilder: (context, index) {
            return getCardHour(selectedEvents[selectedDay][index],
                selectedEvents[selectedDay][index].info);
          });
    } else {
      return Container();
    }
  }

  Widget getCardHour(slots, item) {
    return Card(
      child: new InkWell(
        onTap: () async {
          await getVet(item['VetID']);

          await getPet(item['AnimalID']);
          showDialog(
            context: context,
            builder: (BuildContext context) => _showDialogInfo(item),
          );
        },
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              slots.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showDialogInfo(item) {
    String profileUrl = pet['profilePicture'];

    Uint8List bytes = null, bytes2 = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

    String profileUrl2 = vet['profilePicture'];
    if (profileUrl2 != "" && profileUrl2 != null) {
      profileUrl2 = profileUrl2.substring(23, profileUrl2.length);
      bytes2 = base64.decode(profileUrl2);
    }

    var date = item['date'];
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);
    final TextEditingController _dateController =
        TextEditingController(text: outputDate);

    return AlertDialog(
      content: Container(
          child: Column(
        children: [
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: bytes == null
                      ? AssetImage("assets/images/petdefault.jpg")
                      : MemoryImage(bytes),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Color.fromRGBO(82, 183, 136, 1),
                  width: 5.0,
                ),
              ),
            ),
          ),
          Text("\nPet Informations:\n"),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Name: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['name'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Animal Type: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['animaltype'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Race: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  pet['race'] + "\n",
                )
              ]),
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: bytes == null
                      ? AssetImage("assets/images/defaultuser.jpg")
                      : MemoryImage(bytes2),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: Color.fromRGBO(82, 183, 136, 1),
                  width: 5.0,
                ),
              ),
            ),
          ),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "\nDr/Dra \n",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "\n" + vet['name'] + "\n",
                )
              ]),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Contact: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  vet['contact'] + "\n",
                )
              ]),
               Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(
                  "Email: \n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  vet['email'] + "\n",
                )
              ]),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 45,
            padding: EdgeInsets.only(top: 4, left: 32, right: 16, bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
            child: TextField(
              enabled: false,
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.date_range,
                  color: Color(0xFF52B788),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  List<AppEvent> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  Widget getCalender() {
    // ignore: non_constant_identifier_names
    var now_date = DateTime.now();

    return Column(
      children: [
        TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime(now_date.year - 2, now_date.month, now_date.day),

          lastDay: DateTime(now_date.year + 2, now_date.month, now_date.day),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,

          //Day Changed
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            setState(() {
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },

          eventLoader: _getEventsfromDay,

          //To style the Calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Color.fromRGBO(82, 183, 136, 1),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color.fromRGBO(82, 183, 136, 0.7),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SingleChildScrollView(
            child: Container(
          height: 300,
          child: _buildEvents(),
        ))
      ],
    );
  }

  Widget _showDialog() {
    Widget yesButton = ElevatedButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
        child: new Text(
          "Yes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          setState(() {
            not = !not;
          });
          editUserNotifications(not);
          Navigator.pop(context);
        });

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
      title: not == false
          ? new Text(
              "Turn on notifications",
              textAlign: TextAlign.center,
            )
          : new Text("Turn off notifications", textAlign: TextAlign.center),
      content: not == false
          ? Text("You will not receive any notifications",
              textAlign: TextAlign.center)
          : Text(
              "You will receive notifications about the timing of medications for each of your pets",
              textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[yesButton, noButton])
      ],
    );
  }
}
