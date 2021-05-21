import 'dart:collection';

import '../utils.dart';
import 'package:flutter/material.dart';
import '../jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:typed_data';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

Map<DateTime, List<Event>> appointments_aux;
List appointments = [];

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

class AppointmentPage extends StatefulWidget {
  final Map<String, dynamic> clinic;

  AppointmentPage({Key key, this.clinic, this.title}) : super(key: key);

  final String title;

  @override
  _AppointmentPageState createState() => new _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();

  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  List pets = [];
  List vets = [];

  Map<String, dynamic> selectedPet = null;
  Map<String, dynamic> selectedVet = null;

  bool isLoading = false;
  bool isLoading2 = false;
  void initState() {
    super.initState();
    this.getPets();
    this.getVets();
    selectedEvents = {};

    //
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  getPets() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/userAnimals/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        pets = items;
        isLoading = false;
      });
    } else {
      pets = [];
      isLoading = false;
    }
  }

  getAppointements(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/appointment/vet/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    sleep(Duration(seconds: 1));
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        appointments = items;

        appointments.forEach((element) {
          DateTime parseDated = new DateFormat("yyyy-MM-dd")
              .parse(element['date'].toString()); //Sacar o dia
          parseDated = parseDated.add(Duration(hours: 1));
          DateTime parseDate = parseDated.toUtc();
          print(parseDate);
          if (selectedEvents[parseDate] != null) {
            selectedEvents[parseDate].add(
              Event(title: "Evento"),
            );
          } else {
            selectedEvents[parseDate] = [Event(title: "Evento")];
          }
        });
        print(selectedEvents);
      });
    } else {
      appointments = [];
    }
  }

  getVets() async {
    var jwt = await storage.read(key: "jwt");
    int id = widget.clinic['ID'];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/vetsClinic/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        vets = items;
        isLoading = false;
      });
    } else {
      vets = [];
      isLoading = false;
    }
  }

  Widget getCardPet(item, flag) {
    print("Animal" + item['ID'].toString());
    var name = item['name'];
    var animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];
    profileUrl = profileUrl.substring(23, profileUrl.length);

    Uint8List bytes = base64.decode(profileUrl);
    return Card(
        color: item == selectedPet ? Colors.green[100] : Colors.white,
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            setState(() {
              selectedPet = item;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60 / 2),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(bytes),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 220,
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 17),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        animaltype.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget getCardVet(item, flag) {
    print("Vet" + item['ID'].toString());
    var name = item['name'];
    var animaltype = item['contact'];
    String profileUrl = item['profilePicture'];
    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);
    return Card(
        color: item == selectedVet ? Colors.green[100] : Colors.white,
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            setState(() {
              getAppointements(item['ID']);

              selectedVet = item;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60 / 2),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(bytes),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 220,
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 17),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        animaltype.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: new Text(
          "New Appointment",
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
                  child: _buildStepBar(),
                  height: height + 200,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (pets.contains(null) || pets.length == 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: pets.length,
          itemBuilder: (context, index) {
            return getCardPet(pets[index], context);
          });
    }
  }

  Widget _buildContent2() {
    if (vets.contains(null) || vets.length == 0 || isLoading2) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: vets.length,
          itemBuilder: (context, index) {
            return getCardVet(vets[index], context);
          });
    }
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
          firstDay: DateTime.now(),
          lastDay: DateTime(2050),
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
        ..._getEventsfromDay(selectedDay).map(
          (Event event) => ListTile(
            title: Text(
              event.title,
            ),
          ),
        ),
        FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add Event"),
              content: TextFormField(
                controller: _eventController,
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) {
                    } else {
                      if (selectedEvents[selectedDay] != null) {
                        selectedEvents[selectedDay].add(
                          Event(title: _eventController.text),
                        );
                      } else {
                        selectedEvents[selectedDay] = [
                          Event(title: _eventController.text)
                        ];
                      }
                    }
                    Navigator.pop(context);
                    _eventController.clear();
                    setState(() {});
                    return;
                  },
                ),
              ],
            ),
          ),
          label: Text("Add Event"),
          icon: Icon(Icons.add),
        )
      ],
    );
  }

  Widget _buildStepBar() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stepper(
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: new Text(
                            "Back",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: onStepCancel),
                      SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: new Text(
                            "Next",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: onStepContinue),
                    ],
                  ),
                );
              },
              type: stepperType,
              physics: ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                Step(
                  title: new Text('Pet'),
                  content: Column(
                    children: <Widget>[
                      _buildContent(),
                    ],
                  ),
                  isActive: _currentStep >= -1,
                  state: _currentStep >= 1 ? StepState.complete : StepState.pet,
                ),
                Step(
                  title: new Text('Vet'),
                  content: Column(
                    children: <Widget>[
                      _buildContent2(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2 ? StepState.complete : StepState.vet,
                ),
                Step(
                  title: new Text('Date'),
                  content: Column(
                    children: <Widget>[
                      getCalender(),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep >= 3 ? StepState.complete : StepState.date,
                ),
                Step(
                    title: new Text('Date'),
                    content: Column(
                      children: <Widget>[Text("FODA SE")],
                    ),
                    isActive: _currentStep >= 3,
                    state: StepState.complete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
