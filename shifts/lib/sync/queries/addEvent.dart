import 'package:flutter/material.dart';
import 'dart:collection';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/models/event.dart';
import 'package:shifts/util/util.dart';

Future<void> addRemoteEvent(
    String calendarId, Event event, DateTime date) async {
  print(date);
  CollectionReference events =
      await FirebaseFirestore.instance.collection(calendarId);
  // Call the user's CollectionReference to add a new user
  return events
      .doc(date.toUtc().millisecondsSinceEpoch.toString())
      .set({
        'shift': event.shift.name, // John Doe
      })
      .then((value) => print("Event Added"))
      .catchError((error) => print("Failed to add event: $event"));
}
