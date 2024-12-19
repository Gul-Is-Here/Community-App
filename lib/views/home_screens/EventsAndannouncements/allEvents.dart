import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/all_event_controller.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/widgets/eventsWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/model/home_events_model.dart';
// import 'package:velocity_x/velocity_x.dart';

import '../../../app_classes/app_class.dart';

class AllEventsDatesScreen extends StatefulWidget {
  @override
  State<AllEventsDatesScreen> createState() => _AllEventsDatesScreenState();
}

class _AllEventsDatesScreenState extends State<AllEventsDatesScreen> {
  final HomeEventsController eventsController = Get.put(HomeEventsController());
  final EventTypeController eventTypeController =
      Get.put(EventTypeController());
  RxInt selectedEventType = 1.obs;

  void _updateSelectedEvents(List<Event> updatedEvents) {
    eventTypeController.selectedEvents!.value = updatedEvents;
  }

  void _clearFilters() {
    setState(() {
      selectedEventType.value = 1; // Reset to "All"
      // Ensure all events are displayed both on the calendar and below it
      eventTypeController.selectedEvents!.value =
          eventsController.events.value?.data.events ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: whiteColor),
        ),
        title: Text(
          'All Events',
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

          // Filter events based on selected event type
          List<Event> filteredEvents = eventsController
              .events.value!.data.events
              .where((event) =>
                  selectedEventType.value == 1 ||
                  event.eventhastype.eventtypeId == selectedEventType.value)
              .toList();

          for (var event in filteredEvents) {
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
            child: Column(
              children: [
                // Clear Filter Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _clearFilters, // Clear filter action
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Clear Filter',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 14,
                          fontFamily: popinsMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Event Type Selector
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: eventTypeController.eventTypes.length,
                    itemBuilder: (context, index) {
                      final eventType = eventTypeController.eventTypes[index];
                      final isMatched = eventsController
                          .events.value!.data.events
                          .any((event) =>
                              event.eventhastype.eventtypeId ==
                              eventType.eventtypeId);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEventType.value = eventType.eventtypeId;
                          });
                        },
                        child: isMatched
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: selectedEventType.value ==
                                          eventType.eventtypeId
                                      ? primaryColor
                                      : const Color(0xFFB9EED2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    eventType.eventtypeName,
                                    style: TextStyle(
                                      color: selectedEventType.value ==
                                              eventType.eventtypeId
                                          ? whiteColor
                                          : Colors.black,
                                      fontFamily: popinsMedium,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CalendarWidget(
                    selectedEvents: eventTypeController.selectedEvents,
                    initialDate: DateTime.now(),
                    eventDates: eventDates,
                    selectedEventType: selectedEventType,
                    onEventsUpdated: _updateSelectedEvents, // Callback function
                  ),
                ),
              ],
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
  final RxInt selectedEventType;
  final List<Event>? selectedEvents;
  final Function(List<Event>) onEventsUpdated; // Callback function

  const CalendarWidget({
    Key? key,
    required this.selectedEvents,
    required this.initialDate,
    required this.eventDates,
    required this.selectedEventType,
    required this.onEventsUpdated,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;
  DateTime? _selectedDate;
  late List<Event> _displayedEvents;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _initializeSelectedDateAndEvents();
    _pageController = PageController(initialPage: _currentDate.month - 1);
  }

  void _initializeSelectedDateAndEvents() {
    // Display all events by default
    _selectedDate = null; // Reset selected date for "all events"
    _updateDisplayedEvents(); // Populate _displayedEvents immediately
  }

  void _updateDisplayedEvents() {
    setState(() {
      if (_selectedDate == null) {
        // Show all events when no specific date is selected
        _displayedEvents = widget.eventDates.values
            .expand((events) => events)
            .where((event) =>
                event.eventhastype.eventtypeId ==
                widget.selectedEventType.value)
            .toList();
      } else {
        // Show events for the selected date
        _displayedEvents = widget.eventDates[_selectedDate!]
                ?.where((event) =>
                    event.eventhastype.eventtypeId ==
                    widget.selectedEventType.value)
                .toList() ??
            [];
      }
    });
    widget
        .onEventsUpdated(_displayedEvents); // Notify parent with updated events
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _currentDate = DateTime(DateTime.now().year, pageIndex + 1, 1);
    });
    // _updateDisplayedEvents(); // Refresh events for the new page
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                icon: const Icon(Icons.arrow_back_ios, size: 15),
                color: primaryColor,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('MMMM').format(_currentDate),
                    style:
                        const TextStyle(fontSize: 20, fontFamily: popinsMedium),
                  ),
                  Text(
                    DateFormat('yyyy').format(_currentDate),
                    style: const TextStyle(
                        color: Color(0xFFB9C0CF),
                        fontSize: 12,
                        fontFamily: popinsMedium),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
                icon: const Icon(Icons.arrow_forward_ios, size: 15),
                color: primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: 12,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Table(
                    children: _generateCalendar(daysInMonth),
                  ),
                  const Divider(
                    color: Color(0xFFCED3DE),
                    thickness: 4,
                    endIndent: 40,
                    indent: 40,
                  ),
                  const SizedBox(height: 16.0),
                  if (_displayedEvents.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _displayedEvents.length,
                        itemBuilder: (context, eventIndex) {
                          Event event = _displayedEvents[eventIndex];
                          return GestureDetector(
                            onTap: () {
                              AppClass().EventDetailsShowModelBottomSheet(
                                  context,
                                  event.eventTitle,
                                  event.eventStarttime.toString(),
                                  event.eventEndtime.toString(),
                                  event.eventhastype.eventtypeName,
                                  event.paid == '0' ? 'Free Event' : 'Paid',
                                  event.eventDate.toString(),
                                  event.eventDetail,
                                  event.eventImage,
                                  event.venueName);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppClass()
                                      .formatDate2(event.eventDate.toString()),
                                  style: TextStyle(
                                      fontFamily: popinsSemiBold, fontSize: 20),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD5CEFB),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        event.eventTitle,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: popinsMedium,
                                            color: primaryColor),
                                      ),
                                      Text(
                                        event.paid == '0'
                                            ? 'Free Event'
                                            : 'Paid Event',
                                        style: TextStyle(
                                          fontFamily: popinsMedium,
                                          fontSize: 14,
                                          color: event.paid == '0'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: Text('No Events for Selected Date'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<TableRow> _generateCalendar(int daysInMonth) {
    List<TableRow> rows = [];
    List<Widget> dayCells = [];

    // Add weekday headers
    dayCells.addAll(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        .map((day) => Center(
              child: Text(
                day,
                style: const TextStyle(
                    fontFamily: popinsMedium, color: Color(0xFF8F9BB3)),
              ),
            ))
        .toList());
    rows.add(TableRow(children: dayCells));

    dayCells = [];
    int firstWeekday =
        DateTime(_currentDate.year, _currentDate.month, 1).weekday;

    // Add empty cells for days before the first weekday
    for (int i = 1; i < firstWeekday; i++) {
      dayCells.add(const SizedBox());
    }

    // Add day cells with event indicators
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(_currentDate.year, _currentDate.month, day);
      bool isEventDay = widget.eventDates.containsKey(date);
      bool isSelected = date == _selectedDate;

      dayCells.add(GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
            _updateDisplayedEvents();
          });
        },
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF00A559), Color(0xFF006627)])
                    : LinearGradient(colors: [
                        whiteColor,
                        whiteColor,
                      ]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontFamily: popinsMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            if (isEventDay)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.eventDates[date]!.length
                      .clamp(1, 3), // Limit to 3 dots
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFFB9EED2),
                      ),
                    ),
                  ),
                ),
              ),
          SizedBox(height: 5,),
          ],
        ),
      ));

      if ((day + firstWeekday - 1) % 7 == 0) {
        rows.add(TableRow(children: dayCells));
        dayCells = [];
      }
    }

    // Add empty cells for remaining days
    if (dayCells.isNotEmpty) {
      while (dayCells.length < 7) {
        dayCells.add(const SizedBox());
      }
      rows.add(TableRow(children: dayCells));
    }

    return rows;
  }
}
