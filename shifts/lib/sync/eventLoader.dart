import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/sync/getStatus.dart';
import 'package:shifts/sync/queries/addEvent.dart';
import 'package:shifts/sync/queries/getKalenderCode.dart';
import 'package:shifts/widgets/shiftButton.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class Eventloader {
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
  late SharedPreferences _prefs;
  late String calandarCode;
  late bool isHostDevice;

  Future<bool> init() async {
    bool ready = false;
    _prefs = await SharedPreferences.getInstance();
    calandarCode = await getCalendarCode();
    isHostDevice = await ishostDevice();
    await loadAllLocalEvents();
    ready = true;
    return ready;
  }

  Future<LinkedHashMap<DateTime, List<Event>>> loadAllLocalEvents() async {
    Set<String> eventDates = {};
    LinkedHashMap<DateTime, List<Event>> eventMap = LinkedHashMap();
    eventDates = _prefs.getKeys();
    print("LoadAllEvents");

    eventDates.removeAll({"kalenderCode", "isHost"});

    for (String date in eventDates) {
      String? event = _prefs.getString(date);
      if (event != null) {
        eventMap.putIfAbsent(
            DateTime.parse(date), () => [Event(getShiftTypeFromString(event))]);
      }
    }

    print("loaded events from storage" + eventMap.toString());

    this.events = eventMap;
    return eventMap;
  }

  Future<bool> removeAllLocalEvents() async {
    Set<String> eventDates = {};
    eventDates = _prefs.getKeys();
    print("RemoveAllLocalEvents");

    eventDates.removeAll({"kalenderCode", "isHost"});

    for (String date in eventDates) {
      _prefs.remove(date);
    }
    return true;
  }

  void addRemoteEventsToLocalStorage(
      LinkedHashMap<DateTime, List<Event>> events) async {
    Set<String> currentStoredEvents = {};
    currentStoredEvents = _prefs.getKeys();
    print("Added remote events to local storage");
    currentStoredEvents.removeWhere(
        (element) => (element != "kalenderCode" || element != "isHost"));

    for (MapEntry<DateTime, List<Event>> event in events.entries) {
      DateTime timeStamp =
          DateTime(event.key.year, event.key.month, event.key.day);

      String shiftName = getShiftName(event.value[0].shift);
      _prefs.setString(timeStamp.toString(), shiftName);
      this.events.putIfAbsent(event.key, () => [Event(event.value[0].shift)]);
      print("Event toegevoegd: ${timeStamp.toString()}, $event.value[0].shift");
    }
    return;
  }

  List<Event> loadEventForDay(DateTime timeStamp) {
    print("loadeventforday" + timeStamp.toString());
    timeStamp = DateTime(timeStamp.year, timeStamp.month, timeStamp.day);
    var result = this.events[timeStamp] ?? [];
    return result;
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
