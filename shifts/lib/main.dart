import 'dart:collection';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shifts/util/constants.dart';
import 'package:shifts/util/eventLoader.dart';
import 'package:shifts/util/shiftButton.dart';
import 'package:shifts/util/shiftEvent.dart';
import 'package:shifts/util/shitfType.dart';
import 'package:shifts/util/util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  late final ValueNotifier<List<SEvent>> _selectedEvents;

  late Future<bool> isEventloaderInitialized;

  List<SEvent> _getEventsForDay(DateTime day) {
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
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = selectedDay;
    });

    _selectedEvents.value = _getEventsForDay(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Constants.blue,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            )),
        body: FutureBuilder<bool>(
            future: isEventloaderInitialized,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == true) {
                return Column(children: [
                  TableCalendar(
                    locale: 'nl_BE',
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    focusedDay: _focusedDay,
                    availableCalendarFormats: {
                      CalendarFormat.month: "Maand",
                      CalendarFormat.week: "Week"
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
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
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
                          if (e.toString().contains("Vroege")) {
                            shift = ShiftType.VROEGE;
                          } else if (e.toString().contains("Late")) {
                            shift = ShiftType.LATE;
                          } else if (e.toString().contains("Nacht")) {
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
                      child: Container(
                    color: Colors.grey.shade200,
                    child: ListView(
                      shrinkWrap: true,
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                          child: Container(
                            height: 81,
                            child: Center(
                              child: ValueListenableBuilder<List<SEvent>>(
                                valueListenable: _selectedEvents,
                                builder: (context, events, _) {
                                  if (events.length != 0) {
                                    return Dismissible(
                                      key: UniqueKey(),
                                      child: ShiftEvent(events[0].shift),
                                      background: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Constants.delete,
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Constants.delete,
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      onDismissed: (direction) {
                                        eventLoader.removeEvent(
                                            _selectedDay ?? _focusedDay);

                                        setState(() {
                                          _selectedEvents.value =
                                              _getEventsForDay(_focusedDay);
                                        });
                                      },
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 81,
                                      child: Text(
                                        "Geen shift",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_selectedEvents.value.isEmpty) {
                                      eventLoader.addEvent(
                                          _selectedDay ?? _focusedDay,
                                          ShiftType.VROEGE);
                                      _selectedEvents.value =
                                          _getEventsForDay(_focusedDay);
                                      Add2Calendar.addEvent2Cal(
                                        buildEvent(ShiftType.VROEGE),
                                      );
                                      Add2Calendar.addEvent2Cal(
                                        buildEvent(ShiftType.VROEGE),
                                      );
                                      setState(() {});
                                    }
                                  },
                                  child: ShiftButton(ShiftType.VROEGE,
                                      _selectedEvents.value.isEmpty),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_selectedEvents.value.isEmpty) {
                                      eventLoader.addEvent(
                                          _selectedDay ?? _focusedDay,
                                          ShiftType.LATE);
                                      _selectedEvents.value =
                                          _getEventsForDay(_focusedDay);
                                      setState(() {});
                                    }
                                  },
                                  child: ShiftButton(ShiftType.LATE,
                                      _selectedEvents.value.isEmpty),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_selectedEvents.value.isEmpty) {
                                      eventLoader.addEvent(
                                          _selectedDay ?? _focusedDay,
                                          ShiftType.NACHT);
                                      _selectedEvents.value =
                                          _getEventsForDay(_focusedDay);
                                      setState(() {});
                                    }
                                  },
                                  child: ShiftButton(ShiftType.NACHT,
                                      _selectedEvents.value.isEmpty),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  )),
                ]);
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
