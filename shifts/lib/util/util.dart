// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _random = new Random();

final _kEventSource = Map.fromIterable(List.generate(250, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 1),
    value: (item) =>
        List.generate(1, (index) => Event(getShiftType(_random.nextInt(4)))))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

String getShiftType(int index) {
  switch (index) {
    case 0:
      return "Vroege";
    case 1:
      return "Late";
    case 2:
      return "Nacht";
    case 3:
      return "Vrij";
    default:
      return "Vroege";
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
