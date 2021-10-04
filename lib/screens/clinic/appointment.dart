import '../extras/utils.dart';
import 'package:flutter/material.dart';
import '../extras/jwt.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'dart:typed_data';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:add_2_calendar/add_2_calendar.dart';

List appointments = [];

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
  int finished = 0;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  String date;

  Map<DateTime, List<AppEvent>> selectedDayAppointment; //Horarios daquele dia
  Map<DateTime, List<AppEvent>>
      selectedSlots; //Array que vai conter todas os slots diponiveis
  List<AppEvent> horas = [
    AppEvent(title: "08:00"),
    AppEvent(title: "08:30"),
    AppEvent(title: "09:00"),
    AppEvent(title: "09:30"),
    AppEvent(title: "10:00"),
    AppEvent(title: "10:30"),
    AppEvent(title: "11:00"),
    AppEvent(title: "11:30"),
    AppEvent(title: "12:00"),
    AppEvent(title: "12:30"),
    AppEvent(title: "14:00"),
    AppEvent(title: "14:30"),
    AppEvent(title: "15:00"),
    AppEvent(title: "15:30"),
    AppEvent(title: "16:00"),
    AppEvent(title: "16:30"),
    AppEvent(title: "17:00"),
    AppEvent(title: "17:30"),
    AppEvent(title: "18:00"),
    AppEvent(title: "18:30"),
    AppEvent(title: "19:00"),
  ];

  Map<DateTime, List<AppEvent>> schedule; //Horario estatico completo

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

  // ignore: avoid_init_to_null
  Map<String, dynamic> selectedPet = null;
  // ignore: avoid_init_to_null
  Map<String, dynamic> selectedVet = null;
  // ignore: avoid_init_to_null
  AppEvent selectedHour = null;

  bool isLoading = false;
  bool isLoading2 = false;
  void initState() {
    super.initState();
    this.getPets();
    this.getVets();
    selectedSlots = {};

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
      Uri.parse('$SERVER_IP/userAnimals/$id'),
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

  addAppointments(DateTime date, int animalid, int idvet, String name,
      String vetname, String contact) async {
    var jwt = await storage.read(key: "jwt");
    String dates = date.toString();
    dates.replaceAll("T", " ");
    var result = await http.post(
      Uri.parse('$SERVER_IP/appointment/'),
      body: convert.jsonEncode(
        <String, dynamic>{
          "date": date.toIso8601String(),
          "showedUp": false,
          "vetID": idvet,
          "animalID": animalid
        },
      ),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
   
    if (result.statusCode == 201) {
    

      Event event = Event(
        title: 'Appointment of $name',
        description:
            'Appointment of $name with ver: $vetname | Contact: $contact',
        location: widget.clinic['address'],
        startDate: date,
        endDate: date.add(Duration(minutes: 30)),
      );
      Add2Calendar.addEvent2Cal(event);
    }
  }

  getAppointements(int id) async {
    var jwt = await storage.read(key: "jwt");

    var response = await http.get(
      Uri.parse('$SERVER_IP/appointment/vet/$id'),
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
          
          DateTime now = DateTime.now();
          var timezoneOffset1 = now.timeZoneOffset;
          DateTime parseDated =new DateFormat("yyyy-MM-dd").parse(element['date']); //Sacar o dia
            parseDated_ = parseDated_.add(timezoneOffset1);
          String formattedTime = DateFormat.Hm().format(parseDated_);
    
          parseDated = parseDated.add(timezoneOffset1);
          DateTime parseDate = parseDated.toUtc();
     

          if (selectedDayAppointment[parseDate] != null) {
            selectedDayAppointment[parseDate].add(
              AppEvent(title: formattedTime),
            );
          } else {
            selectedDayAppointment[parseDate] = [
              AppEvent(title: formattedTime)
            ];
          }
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
      Uri.parse('$SERVER_IP/vetsClinic/$id'),
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
 
    var name = item['name'];
    var animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];

    Uint8List bytes = null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }

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
                          image: bytes == null
                              ? AssetImage("assets/images/petdefault.jpg")
                              : MemoryImage(bytes),
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
   
    var name = item['name'];
    var animaltype = item['contact'];
    Uint8List bytes = null;
       String profileUrl2 = item['profilePicture'];
 if (profileUrl2 != "" && profileUrl2 != null) {
      profileUrl2 = profileUrl2.substring(23, profileUrl2.length);
      bytes = base64.decode(profileUrl2);
    }
    return Card(
        color: item == selectedVet ? Colors.green[100] : Colors.white,
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            setState(() {
              getAppointements(item['ID']);
              selectedVet = item;
              selectedHour = null;
              date = null;
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
                          image:bytes==null?AssetImage("assets/images/defaultuser.jpg")
                          :MemoryImage(bytes),
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
            DateTime finalDay = selectedDay;
            String day = selectedHour.toString();
            List parts = day.split(':');
            int hours = int.parse(parts[0]);
            int minutes = int.parse(parts[1]);
            finalDay = finalDay.add(Duration(hours: hours, minutes: minutes));
            DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(finalDay.toString());
            var inputDate = DateTime.parse(parseDate.toString());
            var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
            date = outputFormat.format(inputDate);
           
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

  Widget _buildSlots() {
    if (selectedSlots[selectedDay] == null ||
        selectedSlots[selectedDay].length == 0) {
      return Center(child: Container());
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

  Widget _buildContent3() {
    if (selectedPet != null && selectedVet != null && selectedHour != null) {
     String profileUrl = selectedPet['profilePicture'];

    Uint8List bytes = null,bytes2=null;
    if (profileUrl != "" && profileUrl != null) {
      profileUrl = profileUrl.substring(23, profileUrl.length);
      bytes = base64.decode(profileUrl);
    }
      final TextEditingController _dateController =
          TextEditingController(text: date);

      String profileUrl2 = selectedVet['profilePicture'];
 if (profileUrl2 != "" && profileUrl2 != null) {
      profileUrl2 = profileUrl2.substring(23, profileUrl2.length);
      bytes2 = base64.decode(profileUrl2);
    }

   
      return Container(
          child: Column(
        children: [
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:bytes==null?AssetImage("assets/images/petdefault.jpg"):MemoryImage(bytes),
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
                  selectedPet['name'] + "\n",
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
                  selectedPet['animaltype'] + "\n",
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
                  selectedPet['race'] + "\n",
                )
              ]),
          Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                   image:bytes==null?AssetImage("assets/images/defaultuser.jpg"):MemoryImage(bytes2),
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
                  "\n" + selectedVet['name'] + "\n",
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
                  selectedVet['contact'] + "\n",
                )
              ]),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: 45,
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
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
          SizedBox(
            height: 10,
          )
        ],
      ));
    }
    return Text(
        "\n\nInformation is complete! Go back and select the correct items!\n\n ");
  }

  List<AppEvent> _getEventsfromDay(DateTime date) {
    return selectedSlots[date] ?? [];
  }

  getSlots(DateTime date) {

    if (selectedDayAppointment[date] != null) {
      selectedSlots[date] = null;
      List<AppEvent> day_app = selectedDayAppointment[date];
      List<AppEvent> day_all = horas;
      List<AppEvent> slots = [];

      day_all.forEach((element) {
        if (!day_app.contains(element)) {
          slots.add(element);
        }
      });

      selectedSlots[date] = slots;
    } else {
      selectedSlots[date] = horas;
    }
  }

  Widget getCalender() {
    // ignore: non_constant_identifier_names
    var now_date = DateTime.now();

    return Column(
      children: [
        Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Select a day for you appointment",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
        Container(
          child: TableCalendar(
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
                selectedHour = null;
                _getEventsfromDay(selectedDay);
                focusedDay = focusDay;
              });
       
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
        Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Select a hour for you appointment",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
        SingleChildScrollView(
            child: Container(
          height: 300,
          child: _buildSlots(),
        ))
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
                          _currentStep == 3 ? "Finish" : "Next",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _currentStep == 3
                            ? () {
                                DateTime finalDay = selectedDay;
                                String day = selectedHour.toString();
                                List parts = day.split(':');
                                int hours = int.parse(parts[0]);
                                int minutes = int.parse(parts[1]);
                                finalDay = finalDay.add(
                                    Duration(hours: hours, minutes: minutes));
                                     DateTime now = DateTime.now();
                          var timezoneOffset1 = now.timeZoneOffset;
                                    finalDay= finalDay.subtract(timezoneOffset1);

                                addAppointments(
                                    finalDay,
                                    selectedPet['ID'],
                                    selectedVet['ID'],
                                    selectedPet['name'],
                                    selectedVet['name'],
                                    selectedVet['contact']);
                                Navigator.of(context).pop();
                              }
                            : onStepContinue,
                      ),
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
                  Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Select a Pet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                      
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
                      Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(82, 183, 136, 1),
                  child: Center(
                    child: Text(
                      "Select a Vet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
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
                    title: new Text('Done'),
                    content: Column(
                      children: <Widget>[
                        Text(
                          "Informations about your appointment\n",
                          textAlign: TextAlign.center,
                        ),
                        _buildContent3()
                      ],
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
