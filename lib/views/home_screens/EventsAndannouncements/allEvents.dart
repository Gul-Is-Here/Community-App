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

  // GlobalKey to access CalendarWidget state
  final GlobalKey<_CalendarWidgetState> _calendarWidgetKey =
      GlobalKey<_CalendarWidgetState>();

  void _updateSelectedEvents(List<Event> updatedEvents) {
    eventTypeController.selectedEvents!.value = updatedEvents;
  }

  void _clearFilters() {
    setState(() {
      selectedEventType.value = 0; // Reset to "All" events
      eventTypeController.selectedEvents!.value =
          eventsController.events.value?.data.events ?? [];
    });

    // Reset the selected date in CalendarWidget using GlobalKey
    _calendarWidgetKey.currentState?.resetSelectedDate();
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
                  selectedEventType.value == 0 ||
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
                GestureDetector(
                  onTap: _clearFilters,
                  child: Row(
                    children: [
                      Card(
                        color: selectedEventType.value == 0
                            ? primaryColor
                            : const Color(0xFFB9EED2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(4),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16),
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
                                          selectedEventType.value =
                                              eventType.eventtypeId;
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
                                        margin: const EdgeInsets.all(4),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 16),
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
                                  : const SizedBox();
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
                    key: _calendarWidgetKey,
                    selectedEvents: eventTypeController.selectedEvents,
                    initialDate: DateTime.now(),
                    eventDates: eventDates,
                    selectedEventType: selectedEventType,
                    onEventsUpdated: _updateSelectedEvents,
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
  final Function(List<Event>) onEventsUpdated;

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
  DateTime? selectedDate;
  late List<Event> _displayedEvents;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _initializeSelectedDateAndEvents();

    _pageController = PageController(
      initialPage: _calculatePageIndex(_currentDate),
    );
  }

  void resetSelectedDate() {
    setState(() {
      selectedDate = null;
      _updateDisplayedEvents();
    });
  }

  void _initializeSelectedDateAndEvents() {
    selectedDate = null;
    _updateDisplayedEvents();
  }

  void _updateDisplayedEvents() {
    setState(() {
      if (selectedDate != null) {
        // Show only events for the selected date
        _displayedEvents = widget.eventDates[selectedDate!] ?? [];
      } else {
        // Show only events for the current month and year
        _displayedEvents = widget.eventDates.entries
            .where((entry) =>
                entry.key.year == _currentDate.year &&
                entry.key.month == _currentDate.month)
            .expand((entry) => entry.value)
            .toList();
      }
    });

    // Notify the parent widget with the updated list of events
    widget.onEventsUpdated(_displayedEvents);
  }

  int _calculatePageIndex(DateTime date) {
    int currentYear = DateTime.now().year;
    return (date.year - currentYear + 1) * 12 + date.month - 1;
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      // Calculate the year and month based on the page index
      int year = DateTime.now().year + ((pageIndex ~/ 12) - 1);
      int month = (pageIndex % 12) + 1;

      _currentDate = DateTime(year, month, 1);
      selectedDate = null; // Reset selected date on month navigation
    });

    // Refresh events for the newly navigated month
    _updateDisplayedEvents();
  }

  // int _calculatePageIndex(DateTime date) {
  //   int currentYear = DateTime.now().year;
  //   return (date.year - currentYear + 1) * 12 + date.month - 1;
  // }

  @override
  Widget build(BuildContext context) {
    print('${EventTypeController().selectedEvents}');
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
                    children: _generateCalendar(daysInMonth, _displayedEvents),
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
                      child: selectedDate == null
                          ? ListView.builder(
                              itemCount: widget.eventDates.keys
                                  .length, // Grouped by unique dates
                              itemBuilder: (context, index) {
                                DateTime date = widget.eventDates.keys
                                    .elementAt(index); // Get the date
                                List<Event> eventsForDate = widget
                                    .eventDates[date]!; // Events for the date

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display date header
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        AppClass().formatDate2(
                                            date.toString()), // Format the date
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Display events for that date
                                    for (var event in eventsForDate)
                                      GestureDetector(
                                        onTap: () {
                                          AppClass()
                                              .EventDetailsShowModelBottomSheet(
                                            context,
                                            event.eventId,
                                            event.eventTitle,
                                            event.eventStarttime.toString(),
                                            event.eventEndtime.toString(),
                                            event.eventhastype.eventtypeName,
                                            event.paid == '0'
                                                ? 'Free Event'
                                                : 'Paid',
                                            event.eventDate.toString(),
                                            event.eventDetail,
                                            event.eventImage,
                                            event.venueName,
                                            event.eventLink,
                                          );
                                        },
                                        child: Container(
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
                                                    : 'Paid Event',
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
                                      ),
                                  ],
                                );
                              },
                            )
                          : _displayedEvents.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _displayedEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = _displayedEvents[index];
                                    DateTime date = widget.eventDates.keys
                                        .elementAt(index); // Get the date
                                    // List<Event> eventsForDate =
                                    //     widget.eventDates[date]!;
                                    return GestureDetector(
                                      onTap: () {
                                        AppClass()
                                            .EventDetailsShowModelBottomSheet(
                                          context,
                                          event.eventId,
                                          event.eventTitle,
                                          event.eventStarttime.toString(),
                                          event.eventEndtime.toString(),
                                          event.eventhastype.eventtypeName,
                                          event.paid == '0'
                                              ? 'Free Event'
                                              : 'Paid Event',
                                          event.eventDate.toString(),
                                          event.eventDetail,
                                          event.eventImage,
                                          event.venueName,
                                          event.eventLink,
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              AppClass().formatDate2(date
                                                  .toString()), // Format the date
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: AppClass().hexToColor(event
                                                  .eventhastype
                                                  .eventtypeBgcolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        fontFamily:
                                                            popinsMedium,
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
                                                      : 'Paid Event',
                                                  style: TextStyle(
                                                    fontFamily: popinsMedium,
                                                    fontSize: 14,
                                                    color: event.paid == '0'
                                                        ? const Color(
                                                            0xFF169EFF)
                                                        : const Color(
                                                            0xFF755EF2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const Center(
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

  List<TableRow> _generateCalendar(
      int daysInMonth, final List<Event> selectedEvent) {
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
      bool isSelected = date == selectedDate; // Check if it's selected
      bool isCurrentDate =
          date2 == DateTime.now(); // Check if it's current date

      dayCells.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedDate = date; // Set the selected date
            _updateDisplayedEvents(); // Refresh displayed events
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
                    : LinearGradient(colors: [whiteColor, whiteColor]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontFamily: popinsMedium,
                  ),
                ),
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
                        color: AppClass()
                            .hexToColor(event.eventhastype.eventtypeBgcolor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
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
