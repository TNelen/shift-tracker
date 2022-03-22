import 'package:flutter/material.dart';
import 'dart:collection';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/models/event.dart';
import 'package:shifts/util/util.dart';

Future<LinkedHashMap<DateTime, List<Event>>> getEventsRemoteQuery(
    String calendarId) async {
  print("Getting remote events");
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();

  FirebaseFirestore.instance
      .collection(calendarId)
      .get()
      .then((querySnapshot) => querySnapshot.docs.forEach((element) {
            print(element.id.toString());
            DateTime time =
                DateTime.fromMillisecondsSinceEpoch(int.parse(element.id));

            events.putIfAbsent(
                DateTime.fromMillisecondsSinceEpoch(int.parse(element.id))
                    .toLocal(),
                () => [Event(getShiftTypeFromString(element["shift"]))]);
          }))
      .catchError((e) => print("Error getting remote events: " + e.toString()));

  ;

  return events;
}
