import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/models/event.dart';
import 'package:shifts/sync/getStatus.dart';
import 'package:shifts/sync/queries/getEvents.dart';
import 'package:shifts/sync/queries/getKalenderCode.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';

class EventRepository {
  late LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
  late SharedPreferences _prefs;
  late String calendarCode;
  late bool isHostDevice = true;

  Future<bool> init() async {
    bool ready = false;
    _prefs = await SharedPreferences.getInstance();
    calendarCode = await getCalendarCode();

    isHostDevice = await ishostDevice();
    await loadAllLocalEvents();
    if (!isHostDevice) {
      print("No host device: Getting remote events");
    }
    //await getEventsRemote();

    ready = true;
    return ready;
  }

  Future<void> getEventsRemote() async {
    await getEventsRemoteQuery(calendarCode).then((value) => value.isEmpty ? print("no events to add") : addRemoteEventsToLocalStorage(value));
  }

  Future<LinkedHashMap<DateTime, List<Event>>> loadAllLocalEvents() async {
    Set<String> eventDates = {};
    LinkedHashMap<DateTime, List<Event>> eventMap = LinkedHashMap();
    eventDates = _prefs.getKeys();
    print("LoadAllEvents");

    eventDates.removeAll({"kalenderCode", "isHost", "timeVroege", "timeLate", "timeNacht", "timeAnder"});

    for (String date in eventDates) {
      print("date: " + date);
      String? event = _prefs.getString(date);
      print("event" + event.toString());
      if (event != null) {
        eventMap.putIfAbsent(DateTime.parse(date), () => [Event(getShiftTypeFromString(event))]);
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

  void addRemoteEventsToLocalStorage(LinkedHashMap<DateTime, List<Event>> events) async {
    for (MapEntry<DateTime, List<Event>> event in events.entries) {
      String shiftName = getShiftName(event.value[0].shift);
      DateTime UTCdate = event.key.toUtc();
      _prefs.setString(UTCdate.toString(), shiftName);
      this.events.putIfAbsent(UTCdate, () => [Event(event.value[0].shift)]);
    }
    return;
  }

  List<Event> loadEventForDay(DateTime timeStamp) {
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
    print("add event datetime " + time.toString());
    _prefs.setString(time.toUtc().toString(), getShiftName(type));
    this.events.putIfAbsent(time, () => [Event(type)]);
    print("lokaal event toegevoegd: ${time.toString()}, $type");
  }

  void removeEvent(DateTime time) {
    this.events.remove(time);
    _prefs.remove(time.toString());
    print("lokaal event verwijderd: ${time.toString()}");
  }
}
