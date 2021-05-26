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

List appointments = [];



class UserAppointments extends StatefulWidget {

  UserAppointments({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  _UserAppointmentsState createState() => new _UserAppointmentsState();
}

class _UserAppointmentsState extends State<UserAppointments> {
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

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
    print("Wtf");
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);

    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/appointmentOfuser/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        appointments = items;

        appointments.forEach((element) {
          DateTime parseDated_ = new DateFormat("yyyy-MM-dd'T'HH:mm:ss")
              .parse(element['date']); //AS horas
          DateTime now = DateTime.now();
          var timezoneOffset1 = now.timeZoneOffset;
          print(timezoneOffset1);
          DateTime parseDated =
              new DateFormat("yyyy-MM-dd").parse(element['date']); //Sacar o dia
          String formattedTime = DateFormat.Hm().format(parseDated_);
          print(formattedTime);
          parseDated = parseDated.add(timezoneOffset1);
          DateTime parseDate = parseDated.toUtc();
          print(parseDate);
          if (selectedEvents[parseDate] != null) {
            selectedEvents[parseDate].add(
              Event(title: formattedTime),
            );
          } else {
            selectedEvents[parseDate] = [Event(title: formattedTime)];
          }
        });

        print(selectedEvents);
      });
    } else {
      appointments = [];
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

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  Widget getCalender() {
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

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
            print(focusedDay);
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
}
