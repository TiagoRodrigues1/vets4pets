import '../utils.dart';
import 'package:flutter/material.dart';
import '../jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
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
      Uri.parse('http://52.47.179.213:8081/api/v1/appointmentOfuser/$id'),
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
         print(parseDated_);
          DateTime parseDated =
              new DateFormat("yyyy-MM-dd").parse(element['date']); //Sacar o dia
          String formattedTime = DateFormat.Hm().format(parseDated_);
          
          print(formattedTime);
          parseDated = parseDated.add(timezoneOffset1);
          print(parseDated);
          DateTime parseDate = parseDated.toUtc();
          print(parseDate);
          if (selectedEvents[parseDate] != null) {
            selectedEvents[parseDate].add(
              AppEvent(title: formattedTime),
            );
          } else {
            selectedEvents[parseDate] = [AppEvent(title: formattedTime)];
          }
        });

      });
    } else {
      appointments = [];
    }
  }

  editUserNotifications(bool notification) async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
   

    var response = await http.put(
      Uri.parse('http://52.47.179.213:8081/api/v1/user/$id'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "username": widget.username,
          "name": widget.name,
          "contact": widget.contact,
          "email": widget.email,
          "gender":notification,
          "profilePicture": widget.picture,
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    if (response.statusCode == 200) {
      //print(notification);
      //print(notification.toString());
      await storage.write(key: 'notifications', value: notification.toString());
      //print(notification.toString());
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
            return getCardHour(selectedEvents[selectedDay][index]);
          });
    } else {
      return Container();
    }
  }

  Widget getCardHour(slots) {
    return Card(
      child: new InkWell(
        onTap: () {},
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
          ? Text(
              "You will not receive any notifications",
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
