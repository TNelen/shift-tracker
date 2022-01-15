import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/util/shiftButton.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class Eventloader {
  late LinkedHashMap<DateTime, List<SEvent>> events = LinkedHashMap();
  late SharedPreferences _prefs;

  Future<bool> init() async {
    bool ready = false;
    _prefs = await SharedPreferences.getInstance();
    await loadAllEvents();
    ready = true;
    return ready;
  }

  Future<LinkedHashMap<DateTime, List<SEvent>>> loadAllEvents() async {
    Set<String> eventDates = {};
    LinkedHashMap<DateTime, List<SEvent>> eventMap = LinkedHashMap();
    eventDates = _prefs.getKeys();
    print("LoadAllEvents");
    print("EventDates: $eventDates");

    for (String date in eventDates) {
      String? event = _prefs.getString(date);
      print("Event loaded: $event");
      if (event != null) {
        eventMap.putIfAbsent(DateTime.parse(date),
            () => [SEvent(getShiftTypeFromString(event))]);
      }
    }

    this.events = eventMap;
    return eventMap;
  }

  List<SEvent> loadEventForDay(DateTime day) {
    return this.events[day] ?? [];
  }

  bool dayHasEvent(DateTime day) {
    return this.events[day] != [];
  }

  LinkedHashMap<DateTime, List<SEvent>> returnAllEvents() {
    return this.events;
  }

  void addEvent(DateTime time, ShiftType type) {
    _prefs.setString(time.toString(), getShiftName(type));
    this.events.putIfAbsent(time, () => [SEvent(type)]);
    print("Event toegevoegd: ${time.toString()}, $type");
  }

  void removeEvent(DateTime time) {
    this.events.remove(time);
    _prefs.remove(time.toString());

    print("Cached event verwijderd: ${time.toString()}");
  }
}
