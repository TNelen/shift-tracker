// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shifts/main.dart';
import 'package:shifts/repositories/eventTimeRepository.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:table_calendar/table_calendar.dart';

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
      return ShiftType.ANDER;
    default:
      return ShiftType.ANDER;
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
      return Constants.ander;
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
    case ShiftType.ANDER:
      return "Ander";
    default:
      return "Vrij";
  }
}

String getShiftTime(ShiftType shift) {
  switch (shift) {
    case ShiftType.VROEGE:
      return getIt.get<EventTimeRepository>().getTimeVroege();
    case ShiftType.LATE:
      return getIt.get<EventTimeRepository>().getTimeLate();
    case ShiftType.NACHT:
      return getIt.get<EventTimeRepository>().getTimeNacht();
    case ShiftType.ANDER:
      return getIt.get<EventTimeRepository>().getTimeAnder();
    default:
      return "";
  }
}

ShiftType getShiftTypeFromString(String event) {
  switch (event.toUpperCase()) {
    case "VROEGE":
      return ShiftType.VROEGE;
    case "LATE":
      return ShiftType.LATE;
    case "NACHT":
      return ShiftType.NACHT;
    case "ANDER":
      return ShiftType.ANDER;
    default:
      return ShiftType.ANDER;
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
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);
