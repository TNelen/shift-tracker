import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/sync/queries/addEvent.dart';
import 'package:shifts/sync/queries/getKalenderCode.dart';
import 'package:shifts/widgets/shiftButton.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class Eventloader {
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
  late SharedPreferences _prefs;
  late String calandarCode;

  Future<bool> init() async {
    bool ready = false;
    _prefs = await SharedPreferences.getInstance();
    calandarCode = await getCalendarCode();
    await loadAllLocalEvents();
    ready = true;
    return ready;
  }

  Future<LinkedHashMap<DateTime, List<Event>>> loadAllLocalEvents() async {
    Set<String> eventDates = {};
    LinkedHashMap<DateTime, List<Event>> eventMap = LinkedHashMap();
    eventDates = _prefs.getKeys();
    print("LoadAllEvents");
    print("EventDates: $eventDates");

    eventDates.removeAll({"kalenderCode", "isHost"});

    for (String date in eventDates) {
      String? event = _prefs.getString(date);
      print("Event loaded: $event");
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
    print("Event toegevoegd: ${time.toString()}, $type");
  }

  void removeEvent(DateTime time) {
    this.events.remove(time);
    _prefs.remove(time.toString());

    print("Cached event verwijderd: ${time.toString()}");
  }
}
