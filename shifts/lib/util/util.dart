// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class SEvent {
  final ShiftType shift;

  const SEvent(this.shift);

  @override
  String toString() => getShiftName(shift);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

ShiftType getShiftType(int index) {
  switch (index) {
    case 0:
      return ShiftType.VROEGE;
    case 1:
      return ShiftType.LATE;
    case 2:
      return ShiftType.NACHT;
    case 3:
      return ShiftType.VRIJ;
    default:
      return ShiftType.VRIJ;
  }
}

IconData getShiftIcon(ShiftType shift) {
  switch (shift) {
    case ShiftType.VROEGE:
      return Constants.vroege;
    case ShiftType.LATE:
      return Constants.latee;
    case ShiftType.NACHT:
      return Constants.nacht;
    default:
      return Constants.vrij;
  }
}

String getShiftName(ShiftType shift) {
  switch (shift) {
    case ShiftType.VROEGE:
      return "Vroege";
    case ShiftType.LATE:
      return "Late";
    case ShiftType.NACHT:
      return "Nacht";
    default:
      return "Vrij";
  }
}

String getShiftTime(ShiftType shift) {
  switch (shift) {
    case ShiftType.VROEGE:
      return Constants.tijd_vroege;
    case ShiftType.LATE:
      return Constants.tijd_late;
    case ShiftType.NACHT:
      return Constants.tijd_nacht;
    default:
      return "";
  }
}

ShiftType getShiftTypeFromString(String event) {
  switch (event) {
    case "Vroege":
      return ShiftType.VROEGE;
    case "Late":
      return ShiftType.LATE;
    case "Nacht":
      return ShiftType.NACHT;
    case "Vrij":
      return ShiftType.VRIJ;
    default:
      return ShiftType.VRIJ;
  }
}

Color getColorForShift(ShiftType type) {
  switch (type) {
    case ShiftType.VROEGE:
      return Constants.pink;
    case ShiftType.LATE:
      return Constants.green;
    case ShiftType.NACHT:
      return Constants.blue;
    default:
      return Constants.grey;
  }
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

Event buildEvent(ShiftType type) {
  return Event(
    title: type.name,
    description: 'example',
    location: 'AZ voorkempen',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(minutes: 30)),
    allDay: false,
    iosParams: IOSParams(
      reminder: Duration(minutes: 40),
    ),
    androidParams: AndroidParams(
      emailInvites: ["test@example.com"],
    ),
  );
}
