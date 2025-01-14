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
import '../../../app_classes/app_class.dart';

class AllEventsDatesScreen extends StatefulWidget {
  @override
  State<AllEventsDatesScreen> createState() => _AllEventsDatesScreenState();
}

class _AllEventsDatesScreenState extends State<AllEventsDatesScreen> {
  final HomeEventsController eventsController = Get.put(HomeEventsController());
  final EventTypeController eventTypeController =
      Get.put(EventTypeController());

  // Initialize selectedEventType to 0, meaning no filter by default
  RxInt selectedEventType = 0.obs; // 0 means show all events by default

  void _updateSelectedEvents(List<Event> updatedEvents) {
    eventTypeController.selectedEvents!.value = updatedEvents;
  }

  void _clearFilters() {
    setState(() {
      // Reset to 0 (no filter selected) meaning show all events by default
      selectedEventType.value = 0;
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
                  selectedEventType.value ==
                      0 || // Show all events if no category is selected
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

                // const SizedBox(height: 8),
                // Event Type Selector (for category filtering)
                GestureDetector(
                  onTap: () {
                    _clearFilters();
                  },
                  child: Row(
                    children: [
                      Card(
                        color: selectedEventType.value == 0
                            ? primaryColor
                            : const Color(0xFFB9EED2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(4),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 16), // Reduced vertical padding
                            child: Text(
                              'All',
                              style: TextStyle(
                                color: selectedEventType.value == 0
                                    ? whiteColor
                                    : Colors.black,
                                fontFamily: popinsMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: eventTypeController.eventTypes.length,
                            itemBuilder: (context, index) {
                              final eventType =
                                  eventTypeController.eventTypes[index];
                              final isMatched = eventsController
                                  .events.value!.data.events
                                  .any((event) =>
                                      event.eventhastype.eventtypeId ==
                                      eventType.eventtypeId);
                              return isMatched
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedEventType.value = eventType
                                              .eventtypeId; // Update selected category
                                        });
                                      },
                                      child: Card(
                                        color: selectedEventType.value ==
                                                eventType.eventtypeId
                                            ? primaryColor
                                            : const Color(0xFFB9EED2),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.all(4),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal:
                                                    16), // Reduced vertical padding
                                            child: Text(
                                              eventType.eventtypeName,
                                              style: TextStyle(
                                                color: selectedEventType
                                                            .value ==
                                                        eventType.eventtypeId
                                                    ? whiteColor
                                                    : Colors.black,
                                                fontFamily: popinsMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : const SizedBox(); // If no events match this category, don't display it
                            },
                          ),
                        ),
                      ),
                    ],
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

    // Initialize PageController with a starting index
    _pageController = PageController(
      initialPage: _calculatePageIndex(_currentDate),
    );
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
            .toList(); // No filtering by date, just all events
      } else {
        // Show events for the selected date
        _displayedEvents = widget.eventDates[_selectedDate!] ?? [];
      }

      // Sort events by addition time or start time (most recent last)
      _displayedEvents.sort(
          (a, b) => b.eventDate.toString().compareTo(a.eventDate.toString()));
    });

    widget
        .onEventsUpdated(_displayedEvents); // Notify parent with updated events
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      // Calculate the year and month based on the page index
      int year = DateTime.now().year + ((pageIndex ~/ 12) - 1);
      int month = (pageIndex % 12) + 1;

      _currentDate = DateTime(year, month, 1);
    });
    _updateDisplayedEvents(); // Refresh events for the new page
  }

  int _calculatePageIndex(DateTime date) {
    int currentYear = DateTime.now().year;
    return (date.year - currentYear + 1) * 12 + date.month - 1;
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
            itemCount: 12 *
                3, // Allow navigation for 3 years (previous, current, next)
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
                        itemCount: widget.eventDates.keys
                            .length, // Count the number of unique dates
                        itemBuilder: (context, index) {
                          DateTime date = widget.eventDates.keys
                              .elementAt(index); // Get the date
                          List<Event> eventsForDate = widget
                              .eventDates[date]!; // Get events for that date

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display date header
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Text(
                                  AppClass().formatDate2(
                                      date.toString()), // Format the date
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Display events for that date
                              for (var event in eventsForDate)
                                GestureDetector(
                                  onTap: () {
                                    AppClass().EventDetailsShowModelBottomSheet(
                                        context,
                                        event.eventTitle,
                                        event.eventStarttime.toString(),
                                        event.eventEndtime.toString(),
                                        event.eventhastype.eventtypeName,
                                        event.paid == '0'
                                            ? 'Free Event'
                                            : event.paid == '1'
                                                ? 'Paid'
                                                : '',
                                        event.eventDate.toString(),
                                        event.eventDetail,
                                        event.eventImage,
                                        event.venueName,
                                        event.eventLink);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: AppClass().hexToColor(event
                                              .eventhastype.eventtypeBgcolor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(
                                                  event.eventhastype
                                                      .eventtypeIcon,
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  event.eventTitle,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: popinsMedium,
                                                    color: AppClass()
                                                        .hexToColor(event
                                                            .eventhastype
                                                            .eventtypeTextcolor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              event.paid == '0'
                                                  ? 'Free Event'
                                                  : event.paid == '1'
                                                      ? 'Paid Event'
                                                      : '',
                                              style: TextStyle(
                                                fontFamily: popinsMedium,
                                                fontSize: 14,
                                                color: event.paid == '0'
                                                    ? const Color(0xFF169EFF)
                                                    : const Color(0xFF755EF2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                            ],
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
      DateTime date2 = DateTime(_currentDate.year, _currentDate.month, day);
      bool isEventDay = widget.eventDates.containsKey(date);
      bool isSelected = date == _selectedDate; // Check if it's selected
      bool isCurrentDate =
          date2 == DateTime.now(); // Check if it's current date

      dayCells.add(GestureDetector(
        onTap: () {
          setState(() {
            isCurrentDate;
            _selectedDate = date; // Update selected date
            _updateDisplayedEvents(); // Refresh events based on selected date
          });
        },
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: isSelected || isCurrentDate
                    ? const LinearGradient(colors: [
                        Color(0xFF00A559),
                        Color(0xFF006627)
                      ]) // Highlight selected/current date
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
                      color: isSelected || isCurrentDate
                          ? Colors.white
                          : Colors.black87,
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
                  widget.eventDates[date]!.length.clamp(1, 3),
                  (index) {
                    var event = widget.eventDates[date]![index];
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: AppClass().hexToColor(event
                              .eventhastype.eventtypeBgcolor), // Default color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppClass().hexToColor(
                                event.eventhastype.eventtypeBgcolor),
                          ),
                        ));
                  },
                ),
              ),
            const SizedBox(height: 5),
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
