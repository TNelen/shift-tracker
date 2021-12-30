import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/util/shiftButton.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class Eventloader {
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
  late SharedPreferences _prefs;

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    loadAllEvents();
  }

  Future<LinkedHashMap<DateTime, List<Event>>> loadAllEvents() async {
    Set<String> eventDates = {};
    LinkedHashMap<DateTime, List<Event>> eventMap = LinkedHashMap();
    eventDates = _prefs.getKeys();
    print("LoadAllEvents");
    print("EventDates: ${eventDates}");

    for (String date in eventDates) {
      String? event = _prefs.getString(date);
      print("Event loaded: ${event}");
      if (event != null) {
        eventMap.putIfAbsent(
            DateTime.parse(date), () => [Event(getShiftTypeFromString(event))]);
      }
    }

    this.events = eventMap;
    return eventMap;
  }

  List<Event> loadEventForDay(DateTime day) {
    return this.events[day] ?? [];
  }

  bool dayHasEvent(DateTime day) {
    return this.events[day] != [];
  }

  LinkedHashMap<DateTime, List<Event>> returnAllEvents() {
    return this.events;
  }

  void addEvent(DateTime time, ShiftType type) {
    _prefs.setString(time.toString(), getShiftName(type));
    this.events.putIfAbsent(time, () => [Event(type)]);
    print("Event toegevoegd: ${time.toString()}, ${type}");
  }
}