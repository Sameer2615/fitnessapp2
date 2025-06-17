import 'dart:convert'; // For JSON encoding and decoding
import 'package:fitnessapp/screens/login_signup/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _eventcontroller = TextEditingController();
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _normalizeDate(_focusedDay);
    _selectedEvents = ValueNotifier(_getsEventsForDay(_selectedDay!));
    _loadEventsFromPreferences(); // Load events from SharedPreferences
  }

  /// Normalize DateTime (remove time portion)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _saveEventsToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = events.map((key, value) {
      final formattedKey = key.toIso8601String(); // Convert DateTime to String
      final eventList = value.map((event) => event.toJson()).toList();
      return MapEntry(formattedKey, eventList);
    });
    await prefs.setString('events', jsonEncode(encodedEvents));
  }

  Future<void> _loadEventsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEvents = prefs.getString('events');
    if (savedEvents != null) {
      final decodedEvents = jsonDecode(savedEvents) as Map<String, dynamic>;
      events = decodedEvents.map((key, value) {
        final parsedKey = _normalizeDate(DateTime.parse(key)); // Normalize key
        final eventList =
            (value as List).map((e) => Event.fromJson(e)).toList();
        return MapEntry(parsedKey, eventList);
      });
      setState(() {
        _selectedEvents.value = _getsEventsForDay(_selectedDay!);
      });
    }
  }

  void _onselected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getsEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getsEventsForDay(DateTime day) {
    return events[_normalizeDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 40,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Event'),
                  content: TextField(
                    controller: _eventcontroller,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (_eventcontroller.text.isNotEmpty) {
                          setState(() {
                            if (events[_normalizeDate(_selectedDay!)] != null) {
                              events[_normalizeDate(_selectedDay!)]!
                                  .add(Event(_eventcontroller.text));
                            } else {
                              events[_normalizeDate(_selectedDay!)] = [
                                Event(_eventcontroller.text)
                              ];
                            }

                            _selectedEvents.value =
                                _getsEventsForDay(_selectedDay!);
                            _eventcontroller.clear();
                          });

                          _saveEventsToPreferences(); // Save to SharedPreferences
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit'),
                    )
                  ],
                );
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Text('Add Event'),
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TableCalendar(
            rowHeight: 35,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            focusedDay: _focusedDay,
            eventLoader: _getsEventsForDay,
            firstDay: DateTime.utc(2010, 12, 30),
            lastDay: DateTime.utc(2030, 10, 25),
            onDaySelected: _onselected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text('Events'),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Action"),
                            content: const Text(
                                "Are you sure you want to remove this event?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    events[_normalizeDate(_selectedDay!)]!
                                        .removeAt(index);
                                    if (events[_normalizeDate(_selectedDay!)]!
                                        .isEmpty) {
                                      events.remove(
                                          _normalizeDate(_selectedDay!));
                                    }
                                    _selectedEvents.value =
                                        _getsEventsForDay(_selectedDay!);
                                    _saveEventsToPreferences(); // Save updated events
                                  });

                                  // Close the dialog
                                  Navigator.of(context).pop();

                                  // Show a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Event removed!")),
                                  );
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 202, 186, 186), // Background color
                        borderRadius:
                            BorderRadius.circular(10), // Rounded edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(4, 4),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(-4, -4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(value[index].title),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Column(
          children: [
            Text('hello9ooooooooooooooo'),
          ],
        )
      ],
    );
  }
}
