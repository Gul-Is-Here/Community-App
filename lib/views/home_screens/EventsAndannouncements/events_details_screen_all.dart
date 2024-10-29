import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllEventsDatesScreen extends StatelessWidget {
  AllEventsDatesScreen({super.key});
  final HomeEventsController eventsController = Get.put(HomeEventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: whiteColor,
              )),
          title: Text(
            'All Events Calendar',
            style: TextStyle(color: whiteColor, fontFamily: popinsMedium),
          ),
          backgroundColor: primaryColor),
      body: Obx(() {
        // Check if the events are still loading
        if (eventsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Check if there are no events
        else if (eventsController.events.value == null ||
            eventsController.events.value!.data.events.isEmpty) {
          return const Center(
            child: Text('No Events Found'),
          );
        }
        // If events are loaded, pass them to the calendar
        else {
          // Extract the event dates as a Map<DateTime, String>
          Map<DateTime, String> eventDates = {};
          for (var event in eventsController.events.value!.data.events) {
            // Convert event date string to DateTime and ignore the time part
            DateTime eventDate =
                DateTime.parse(event.eventDate.toIso8601String());
            DateTime eventDay =
                DateTime(eventDate.year, eventDate.month, eventDate.day);
            eventDates[eventDay] = event.eventDetail;
            print('Events Dates ${eventDates[eventDay]}');
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CalendarWidget(
              initialDate: DateTime.now(), // Initial month to show
              eventDates: eventDates, // Pass the event dates
            ),
          );
        }
      }),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final Map<DateTime, String> eventDates;

  const CalendarWidget({
    super.key,
    required this.initialDate,
    required this.eventDates,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    // Set the initial date as the current date or the date of the first event if applicable
    _currentDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

    return Column(
      children: [
        // Calendar Header with Previous/Next buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentDate =
                        DateTime(_currentDate.year, _currentDate.month - 1);
                  });
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: primaryColor,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentDate),
                style: const TextStyle(fontSize: 20, fontFamily: popinsMedium),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentDate =
                        DateTime(_currentDate.year, _currentDate.month + 1);
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: primaryColor,
              ),
            ],
          ),
        ),
        // Calendar Days
        Table(
          children: _generateCalendar(
              daysInMonth, widget.eventDates, _currentDate, context),
        ),
      ],
    );
  }

  // Helper function to check if two dates (without time) are the same
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Generates the rows for the calendar
  List<TableRow> _generateCalendar(
      int daysInMonth,
      Map<DateTime, String> eventDates,
      DateTime currentDate,
      BuildContext context) {
    List<TableRow> rows = [];
    List<Widget> dayCells = [];

    // Add day names (e.g., Mon, Tue, Wed...)
    dayCells.addAll(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        .map((day) => Center(
              child: Text(
                day,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ))
        .toList());
    rows.add(TableRow(children: dayCells));

    // Fill initial empty cells if the first day of the month doesn't start on Monday
    dayCells = [];
    int firstWeekday = DateTime(currentDate.year, currentDate.month, 1).weekday;
    for (int i = 1; i < firstWeekday; i++) {
      dayCells.add(const SizedBox());
    }

    // Generate day numbers
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentDate.year, currentDate.month, day);
      bool isEventDay =
          eventDates.keys.any((eventDate) => _isSameDate(date, eventDate));

      dayCells.add(Center(
        child: Tooltip(
          message: isEventDay
              ? eventDates[date]!
              : "", // Show event detail on tooltip
          child: GestureDetector(
            onTap: () {
              if (isEventDay) {
                // Show event detail dialog or any other action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Event Details',
                        style: TextStyle(
                            color: primaryColor, fontFamily: popinsSemiBold),
                      ),
                      content: Text(
                        eventDates[date]!,
                        style: TextStyle(fontFamily: popinsMedium),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: popinsSemiBold),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isEventDay
                    ? Colors.red
                    : Colors.transparent, // Highlight event day with red
                shape: BoxShape.circle,
              ),
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isEventDay ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ));

      // Add row every Sunday (7th day of the week)
      if ((day + firstWeekday - 1) % 7 == 0) {
        rows.add(TableRow(children: dayCells));
        dayCells = [];
      }
    }

    // Add any remaining day cells
    if (dayCells.isNotEmpty) {
      while (dayCells.length < 7) {
        dayCells.add(const SizedBox());
      }
      rows.add(TableRow(children: dayCells));
    }

    return rows;
  }
}
