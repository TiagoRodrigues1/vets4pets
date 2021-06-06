import 'package:flutter/foundation.dart';

/// Example event class.
class AppEvent {
  final String title;
  final Map<String, dynamic> info;
  AppEvent({@required this.title,this.info});

  String toString() => this.title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppEvent &&
          runtimeType == other.runtimeType &&
          title == other.title;

  @override
  int get hashCode => title.hashCode;
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
