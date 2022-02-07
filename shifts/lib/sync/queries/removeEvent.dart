import 'package:flutter/material.dart';
import 'dart:collection';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/util/util.dart';

Future<void> removeRemoteEvent(
    String calendarId, Event event, DateTime date) async {
  print(date);
  CollectionReference events =
      await FirebaseFirestore.instance.collection(calendarId);
  return events
      .doc(date.millisecondsSinceEpoch.toString())
      .delete()
      .then((value) => print("Remove Event Deleted"))
      .catchError((error) => print("Failed to delete event: $error"));
}
