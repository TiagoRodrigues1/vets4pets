
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


List appointments = [];

final _kEventSource = Map.fromIterable(List.generate(appointments.length, (index) => appointments[1]),
    key: (item) => DateTime.utc(appointments[1]),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({

    DateTime.now(): [
      /*Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),*/
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);



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


  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;







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
     _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    
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
    print("Xd)");
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/appointment/vet/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(utf8.decode(response.bodyBytes))['data'];

      setState(() {
        appointments = items;
       
        appointments.forEach((element) {
          print(element['date']);
        final dateTime = DateTime.parse(element['date']);
          //_events.addEntries(element['date']);
        });

     
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
                  height: height+200,
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




 @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }



  Widget getCalender() {
    var now_date = DateTime.now();

        return Column(
        children: [
          TableCalendar<Event>(
           firstDay: DateTime.now(),
            lastDay: DateTime.utc(now_date.year + 2, now_date.month, now_date.day),           
             focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
           calendarStyle: CalendarStyle(
             
        isTodayHighlighted: true,
        todayDecoration: BoxDecoration(
            color: Color.fromRGBO(82, 183, 136, 0.7), shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            color: Color.fromRGBO(82, 183, 136, 1), shape: BoxShape.circle),
      ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
          
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
    Container(
      height:300,
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
