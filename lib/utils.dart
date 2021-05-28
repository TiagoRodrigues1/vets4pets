
import 'package:flutter/foundation.dart';


/// Example event class.
class Event {
  final String title;
  Event({@required this.title});

  String toString() => this.title;




 @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Event &&
    runtimeType == other.runtimeType &&
    title == other.title;

  @override
  int get hashCode => title.hashCode;

}



final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);



