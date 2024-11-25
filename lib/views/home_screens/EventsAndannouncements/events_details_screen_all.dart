import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/model/home_events_model.dart';

class AllEventsDatesScreen extends StatelessWidget {
  final HomeEventsController eventsController = Get.put(HomeEventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: whiteColor),
        ),
        title: Text(
          'All Events Calendar',
          style: TextStyle(color: whiteColor, fontFamily: popinsMedium),
        ),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (eventsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (eventsController.events.value == null ||
            eventsController.events.value!.data.events.isEmpty) {
          return const Center(child: Text('No Events Found'));
        } else {
          Map<DateTime, List<Event>> eventDates = {};

          for (var event in eventsController.events.value!.data.events) {
            DateTime eventDay = DateTime(
              event.eventDate.year,
              event.eventDate.month,
              event.eventDate.day,
            );

            if (eventDates.containsKey(eventDay)) {
              eventDates[eventDay]!.add(event);
            } else {
              eventDates[eventDay] = [event];
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CalendarWidget(
              initialDate: DateTime.now(),
              eventDates: eventDates,
            ),
          );
        }
      }),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final Map<DateTime, List<Event>> eventDates;

  const CalendarWidget({
    Key? key,
    required this.initialDate,
    required this.eventDates,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;
  DateTime? _selectedDate;
  List<Event>? _selectedEvents;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _initializeSelectedDateAndEvents();
  }

  void _initializeSelectedDateAndEvents() {
    // Check if today has events, otherwise use the first date with events
    if (widget.eventDates.containsKey(_currentDate)) {
      _selectedDate = _currentDate;
    } else {
      _selectedDate = widget.eventDates.keys.first;
    }
    _updateSelectedEvents(_selectedDate!);
  }

  void _updateSelectedEvents(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedEvents = widget.eventDates[date] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeEventsController eventsController =
        Get.put(HomeEventsController());
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

    return Column(
      children: [
        // Month and Year Navigation
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.arrow_back_ios),
                color: primaryColor,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentDate),
                style: const TextStyle(fontSize: 20, fontFamily: popinsMedium),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.arrow_forward_ios),
                color: primaryColor,
              ),
            ],
          ),
        ),
        // Calendar Display
        Table(
          children: _generateCalendar(daysInMonth),
        ),
        const SizedBox(height: 16.0),
        // Events List for Selected Date
        if (_selectedEvents != null && _selectedEvents!.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents!.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents![index];
                final feedImage = eventsController.feedsList.length > index
                    ? eventsController.feedsList[index].feedImage
                    : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            event.eventDetail,
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontFamily: popinsMedium,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('MMMM d, yyyy h:mm a')
                                .format(event.eventDate),
                          ),
                        ),
                        if (feedImage != null)
                          Image.network(
                            feedImage,
                            fit: BoxFit.fill,
                            height: 350,
                            width: double.infinity,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        else
          const Center(child: Text('No Events for Selected Date')),
      ],
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + delta);
    });
    _updateSelectedEvents(DateTime(_currentDate.year, _currentDate.month, 1));
  }

  List<TableRow> _generateCalendar(int daysInMonth) {
    List<TableRow> rows = [];
    List<Widget> dayCells = [];

    // Weekday Headers
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

    // Calendar Days
    dayCells = [];
    int firstWeekday =
        DateTime(_currentDate.year, _currentDate.month, 1).weekday;

    // Add Empty Cells for Alignment
    for (int i = 1; i < firstWeekday; i++) {
      dayCells.add(const SizedBox());
    }

    // Days of the Month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(_currentDate.year, _currentDate.month, day);
      bool isEventDay = widget.eventDates.containsKey(date);
      bool isSelected = date == _selectedDate;

      dayCells.add(GestureDetector(
        onTap: () {
          _updateSelectedEvents(date);
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor
                : isEventDay
                    ? Colors.red
                    : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isSelected || isEventDay ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ));

      if ((day + firstWeekday - 1) % 7 == 0) {
        rows.add(TableRow(children: dayCells));
        dayCells = [];
      }
    }

    if (dayCells.isNotEmpty) {
      while (dayCells.length < 7) {
        dayCells.add(const SizedBox());
      }
      rows.add(TableRow(children: dayCells));
    }

    return rows;
  }
}
