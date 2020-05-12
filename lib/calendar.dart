import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_2/firstscreen.dart';

import 'daily.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2020, 5, 7): ['Easter Monday'],
};

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  AnimationController _animationController;
  // final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  // HomePage([this._selectedEvents]);

  @override
  void initState() {
    super.initState();

    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0xff050A30),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xff050A30), Color(0xff050A10)])),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // _buildTable(),
                        _buildTableCalendarWithBuilders(),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // RaisedButton(
                            //   child: Text('Month'),
                            //   color: Colors.deepPurpleAccent,
                            //   onPressed: () {
                            //     setState(() {
                            //       _controller
                            //           .setCalendarFormat(CalendarFormat.month);
                            //     });
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'add',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.green,
                                onPressed: () {
                                  showAddDialog();
                                  // setState(() {
                                  //   _controller
                                  //       .setCalendarFormat(CalendarFormat.week);
                                  // }
                                  // );
                                },
                              ),
                            ),
                            // RaisedButton(
                            //   child: Text('2 weeks'),
                            //   color: Colors.deepPurpleAccent,
                            //   onPressed: () {
                            //     setState(() {
                            //       _controller.setCalendarFormat(
                            //           CalendarFormat.twoWeeks);
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        //_buildButtons(),
                        const SizedBox(height: 15.0),
                        ..._selectedEvents.map(
                          (event) => Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              border: Border.all(width: 0.8),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: ListTile(
                              title: Text(event),
                            ),
                          ),
                        ),
                        // _buildEventList(),
                      ],
                    ),
                  ),
                ),
                // floatingActionButton: FloatingActionButton(
                //   child: Icon(Icons.add),
                //   onPressed: _showAddDialog,
                // ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Today',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20),
                      daily(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Weekly Target',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    if (_events[_controller.selectedDay] != null) {
                      _events[_controller.selectedDay]
                          .add(_eventController.text);
                    } else {
                      _events[_controller.selectedDay] = [
                        _eventController.text
                      ];
                    }
                    prefs.setString("events", json.encode(encodeMap(_events)));
                    _eventController.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
    // setState(() {
    //   _selectedEvents = _events[_controller.selectedDay];
    // });
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // locale: 'pl_PL',
      calendarController: _controller,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      // availableCalendarFormats: const {
      //   CalendarFormat.month: '',
      //   CalendarFormat.week: '',
      // },
      calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
          holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
          weekdayStyle:
              TextStyle().copyWith(color: Colors.lightGreenAccent[200]),
          // outsideHolidayStyle: TextStyle(color: Colors.blue),
          outsideWeekendStyle: TextStyle().copyWith(color: Colors.white)),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.deepPurpleAccent),
          weekdayStyle:
              TextStyle().copyWith(color: Colors.lightGreenAccent[400])),
      headerStyle: HeaderStyle(
          formatButtonTextStyle: TextStyle().copyWith(color: Colors.white),
          centerHeaderTitle: true,
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: TextStyle()
              .copyWith(color: Colors.green, fontWeight: FontWeight.w900)),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Color(0xff33FF33),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style:
                    TextStyle().copyWith(fontSize: 16.0, color: Colors.black),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.purple,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _controller.isSelected(date)
            ? Colors.green
            : _controller.isToday(date) ? Colors.green : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
