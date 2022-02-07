import 'package:flutter/material.dart';
import 'dart:collection';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/util/util.dart';

Future<LinkedHashMap<DateTime, List<Event>>> getEventsRemote(
    String calendarId) async {
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();

  await FirebaseFirestore.instance
      .collection(calendarId)
      .get()
      .then((querySnapshot) => querySnapshot.docs.forEach((element) {
            print(element);
            events.putIfAbsent(
                DateTime.fromMillisecondsSinceEpoch(int.parse(element.id)),
                () => [Event(getShiftTypeFromString(element["shift"]))]);
          }));

  return events;
}
