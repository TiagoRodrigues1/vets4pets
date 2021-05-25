// TODO Implement this library.// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'package:equatable/equatable.dart';

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';

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



