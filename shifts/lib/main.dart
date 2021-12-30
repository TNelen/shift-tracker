import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shifts/util/constants.dart';
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
  late final ValueNotifier<List<Event>> _selectedEvents;

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  bool _dayHasEvent(DateTime day) {
    return kEvents[day] != [];
  }

  @override
  void initState() {
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    initializeDateFormatting('nl_BE', null);

    super.initState();
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
      body: Column(children: [
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
                      border: Border.all(width: 0.5, color: Colors.black),
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
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Geplande shift",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Container(
                  height: 3,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Constants.green),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, events, _) {
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        ShiftType type =
                            getShiftTypeFromString(events[index].title);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: getColorForShift(type),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                getShiftIcon(type),
                                size: 25,
                              ),
                              SizedBox(width: 20),
                              Text(
                                events[index].title,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Plan shift",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Container(
                  height: 3,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Constants.blue),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      //TODO
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: getColorForShift(ShiftType.VROEGE),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getShiftIcon(ShiftType.VROEGE),
                            size: 25,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Vroege",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //TODO
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: getColorForShift(ShiftType.LATE),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getShiftIcon(ShiftType.LATE),
                            size: 25,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Late",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //todo
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: getColorForShift(ShiftType.NACHT),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getShiftIcon(ShiftType.NACHT),
                            size: 25,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Nacht",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        )),
      ]),
    );
  }
}
