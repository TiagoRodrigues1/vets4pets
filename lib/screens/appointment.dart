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
import 'package:flutter/cupertino.dart';

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
  Duration initialtimer = new Duration(hours: 8, minutes: 00);

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<Event>> selectedDayAppointment; //Horarios daquele dia
  Map<DateTime, List<Event>> selectedSlots; //Array que vai conter todas os slots diponiveis
  List<Event> horas = [
    Event(title: "08:00"),
    Event(title: "08:30"),
    Event(title: "09:00"),
    Event(title: "09:30"),
    Event(title: "10:00"),
    Event(title: "10:30"),
    Event(title: "11:00"),
    Event(title: "11:30"),
    Event(title: "12:00"),
    Event(title: "12:30"),
    Event(title: "14:00"),
    Event(title: "14:30"),
    Event(title: "15:30"),
    Event(title: "16:00"),
    Event(title: "16:30"),
    Event(title: "17:00"),
    Event(title: "17:30"),
    Event(title: "18:00"),
    Event(title: "18:30"),
    Event(title: "19:00"),
  ];

  Map<DateTime, List<Event>> schedule; //Horario estatico completo

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
  Event selectedHour = null;

  bool isLoading = false;
  bool isLoading2 = false;
  void initState() {
    super.initState();
    this.getPets();
    this.getVets();
    selectedSlots = {};
      //getSlots(selectedDay);

    selectedDayAppointment = {};
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
      selectedDayAppointment.clear();
      setState(() {
        appointments = items;

        appointments.forEach((element) {
          DateTime parseDated_ = new DateFormat("yyyy-MM-dd'T'HH:mm:ss")
              .parse(element['date']); //AS horas
         print(parseDated_);      
          DateTime now= DateTime.now();
              var timezoneOffset1=now.timeZoneOffset;
          DateTime parseDated =new DateFormat("yyyy-MM-dd").parse(element['date']); //Sacar o dia
          
          String formattedTime = DateFormat.Hm().format(parseDated_);
          print(formattedTime);
             parseDated = parseDated.add(timezoneOffset1);
          DateTime parseDate =parseDated.toUtc();
          print(parseDated);
         
          if (selectedDayAppointment[parseDate] != null) {
            selectedDayAppointment[parseDate].add(
              Event(title: formattedTime),
            );
          } else {
            selectedDayAppointment[parseDate] = [Event(title: formattedTime)];
          }
        });

        print(selectedDayAppointment);
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

  Widget getCardHour(slots) {
    return Card(
      color: slots == selectedHour ? Colors.green[100] : Colors.white,
      child: new InkWell(
        onTap: () {
          setState(() {
            selectedHour = slots;
          });
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
                  height: height +200,
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

  Widget _buildSlots() {
    if (selectedSlots[selectedDay] == null ||
        selectedSlots[selectedDay].length == 0 ) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: selectedSlots[selectedDay].length,
          itemBuilder: (context, index) {
            return getCardHour(selectedSlots[selectedDay][index]);
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
    return selectedSlots[date] ?? [];
  }

  getSlots(DateTime date) {
print(selectedDayAppointment);
    if (selectedDayAppointment[date] != null) {
      selectedSlots[date] = null;
      List<Event> day_app = selectedDayAppointment[date];
      List<Event> day_all = horas;

      print(day_app);
      print(day_all);
      List<Event> slots = [];

      day_all.forEach((element) {
        if (!day_app.contains(element)) {
          slots.add(element);
        }
      });
      print(slots);
      selectedSlots[date] = slots;
    } else {
      print("dia vazio");
      selectedSlots[date] = horas;
    }
  }

  Widget getCalender() {
    var now_date = DateTime.now();

    return Column(
      children: [
        Text(
          "Select a day for your appointment",
          textAlign: TextAlign.center,
        ),
        Container(child: 
            TableCalendar(
          focusedDay: selectedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime(now_date.year + 2, now_date.month, now_date.day),
         // calendarFormat: format,
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
              getSlots(selectDay);
              selectedHour=null;
              _getEventsfromDay(selectedDay);
              focusedDay = focusDay;
            });
            print(focusedDay);
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },

          // eventLoader: _getEventsfromDay,

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
        ),
    
        Text(
          "Select a hour for your appointment",
          textAlign: TextAlign.center,
        ),
        SingleChildScrollView(
          child: Container(
            height: 300,
          child: _buildSlots(),
        )
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
                            _currentStep==3?"Finish":"Next",
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
                      children: <Widget>[Text("NICERS")],
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
