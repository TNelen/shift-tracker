import 'package:flutter/material.dart';
import 'dart:collection';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/models/event.dart';
import 'package:shifts/models/eventType.dart';
import 'package:shifts/util/util.dart';

Future<List<EventType>> getTypesRemoteQuery(String calendarId) async {
  print("Getting remote shift types");
  late List<EventType> types = [];

  FirebaseFirestore.instance.collection('calendarId').doc("config").get().then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document exists on the database');
      print(documentSnapshot.data());
    }
  }).catchError((e) => print("Error getting remote events: " + e.toString()));

  return [];
}
