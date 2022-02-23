import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/sync/queries/addEvent.dart';
import 'package:shifts/sync/queries/removeEvent.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/sync/eventLoader.dart';
import 'package:shifts/widgets/settingsPopup.dart';
import 'package:shifts/widgets/shiftButton.dart';
import 'package:shifts/widgets/shiftEvent.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';
import 'package:shifts/widgets/syncPopup.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Eventloader eventLoader = Eventloader();
  late final ValueNotifier<List<Event>> _selectedEvents;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<bool> isEventloaderInitialized;

  List<Event> _getEventsForDay(DateTime day) {
    return eventLoader.loadEventForDay(day);
  }

  @override
  void initState() {
    super.initState();

    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    initializeDateFormatting('nl_BE', null);

    isEventloaderInitialized = eventLoader.init();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.month != focusedDay.month) {
      return;
    }
    setState(() {
      _focusedDay = focusedDay;
      print("selectedDaty" + selectedDay.toString());
      _selectedDay = selectedDay;
    });

    _selectedEvents.value = _getEventsForDay(_focusedDay);
  }

  void addEvent(ShiftType type) async {
    if (_selectedEvents.value.isEmpty) {
      eventLoader.addEvent(_selectedDay ?? _focusedDay, type);
      _selectedEvents.value = _getEventsForDay(_focusedDay);
      await addRemoteEvent(eventLoader.calendarCode, Event(type), _focusedDay);
      setState(() {});
    }
  }

  void _onRefresh() async {
    //refetching remote events
    await eventLoader.getEventsRemote();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.child_care,
        color: Colors.white,
        size: 20,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        'Kalender gesynchroniseerd',
        style: TextStyle(color: Colors.white),
      ),
    ])));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.child_care,
                color: Colors.black87,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Kaatjes Kalender',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SettingsPopup(eventLoader);
                  },
                );
              },
            )
          ],
        ),
        body: FutureBuilder<bool>(
            future: isEventloaderInitialized,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == true) {
                return SmartRefresher(
                    controller: _refreshController,
                    //only enable refresh if you are subscribed to ther calendar
                    enablePullDown: !eventLoader.isHostDevice,
                    onRefresh: _onRefresh,
                    child: Column(children: [
                      TableCalendar(
                        locale: 'nl_BE',
                        firstDay: kFirstDay,
                        lastDay: kLastDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        focusedDay: _focusedDay,
                        availableCalendarFormats: {
                          CalendarFormat.month: "Maand",
                        },
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, day, event) {
                            return Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.grey,
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                          outsideBuilder: (context, day, focusedDay) {
                            final text = day.day.toString();
                            return Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey.withOpacity(0.05)),
                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            final text = day.day.toString();
                            return Center(
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    color: Colors.grey.withOpacity(0.2)),
                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                          markerBuilder: (context, day, events) {
                            ShiftType shift = ShiftType.VRIJ;
                            for (var e in events) {
                              String event = e.toString().toUpperCase();
                              if (event.contains("VROEGE")) {
                                shift = ShiftType.VROEGE;
                              } else if (event.contains("LATE")) {
                                shift = ShiftType.LATE;
                              } else if (event.contains("NACHT")) {
                                shift = ShiftType.NACHT;
                              } else {
                                shift = ShiftType.VRIJ;
                              }
                            }
                            if (shift != ShiftType.VRIJ) {
                              return Container(
                                width: 40,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: getColorForShift(shift)),
                              );
                            } else if (shift == ShiftType.VRIJ) {
                              return SizedBox();
                            }
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            final text = day.day.toString();

                            return Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey.withOpacity(0.2)),
                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsForDay,
                        selectedDayPredicate: (day) {
                          // Use `selectedDayPredicate` to determine which day is currently selected.
                          // If this returns true, then `day` will be marked as selected.

                          // Using `isSameDay` is recommended to disregard
                          // the time-part of compared DateTime objects.
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          _onDaySelected(selectedDay, focusedDay);
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            // Call `setState()` when updating calendar format
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          // No need to call `setState()` here
                          _focusedDay = focusedDay;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: _selectedDay != null
                                      ? Text(
                                          DateFormat.MMMMEEEEd("nl_BE")

                                              // displaying formatted date
                                              .format(_selectedDay!),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          DateFormat.MMMMEEEEd("nl_BE")

                                              // displaying formatted date
                                              .format(_focusedDay),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    "Geplande shift",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 4),
                                  child: Container(
                                    height: 81,
                                    child: Center(
                                      child:
                                          ValueListenableBuilder<List<Event>>(
                                        valueListenable: _selectedEvents,
                                        builder: (context, events, _) {
                                          if (events.length != 0) {
                                            return Dismissible(
                                              key: UniqueKey(),
                                              child:
                                                  ShiftEvent(events[0].shift),
                                              background: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Constants.delete,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Icon(Icons.delete,
                                                    color: Colors.white),
                                              ),
                                              secondaryBackground: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Constants.delete,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Icon(Icons.delete,
                                                    color: Colors.white),
                                              ),
                                              onDismissed: (direction) {
                                                eventLoader.removeEvent(
                                                    _selectedDay ??
                                                        _focusedDay);
                                                removeRemoteEvent(
                                                    eventLoader.calendarCode,
                                                    Event(events[0].shift),
                                                    _focusedDay);
                                                setState(() {
                                                  _selectedEvents.value =
                                                      _getEventsForDay(
                                                          _focusedDay);
                                                });
                                              },
                                            );
                                          } else {
                                            return SizedBox(
                                              height: 41,
                                              child: Text(
                                                "Geen shift",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                eventLoader.isHostDevice
                                    ? Column(children: [
                                        Center(
                                          child: Text(
                                            "Plan shift",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 45, vertical: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () async => addEvent(
                                                      ShiftType.VROEGE),
                                                  child: ShiftButton(
                                                      ShiftType.VROEGE,
                                                      _selectedEvents
                                                          .value.isEmpty),
                                                ),
                                                InkWell(
                                                  onTap: () async =>
                                                      addEvent(ShiftType.LATE),
                                                  child: ShiftButton(
                                                      ShiftType.LATE,
                                                      _selectedEvents
                                                          .value.isEmpty),
                                                ),
                                                InkWell(
                                                  onTap: () async =>
                                                      addEvent(ShiftType.NACHT),
                                                  child: ShiftButton(
                                                      ShiftType.NACHT,
                                                      _selectedEvents
                                                          .value.isEmpty),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                      ])
                                    : SizedBox(),
                              ],
                            ),
                          )),
                    ]));
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlowingProgressIndicator(
                        child: Icon(
                          Icons.child_care,
                          color: Colors.black45,
                          size: 100,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Shiften aan het laden...",
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
