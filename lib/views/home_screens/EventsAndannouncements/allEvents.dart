import 'package:community_islamic_app/constants/globals.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/all_event_controller.dart';
import 'package:community_islamic_app/views/azan_settings/events_notification_settinons.dart';
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

  RxInt selectedEventType = 0.obs; // Reactive: 0 means "All" events
  Rxn<DateTime> selectedDate =
      Rxn<DateTime>(); // Reactive nullable selectedDate

  // GlobalKey to access CalendarWidget state
  final GlobalKey<_CalendarWidgetState> _calendarWidgetKey =
      GlobalKey<_CalendarWidgetState>();

  void _updateSelectedEvents(List<Event> updatedEvents) {
    eventTypeController.selectedEvents!.value = updatedEvents;
  }

  void _clearFilters() {
    setState(() {
      selectedEventType.value = 0; // Reset to "All" events
      selectedDate.value = null; // Reset the selected date
      _calendarWidgetKey.currentState?.resetSelectedDate();
      _calendarWidgetKey.currentState
          ?._updateDisplayedEvents(); // Update displayed events
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          'Events',
          style: TextStyle(
              fontSize: 18, color: whiteColor, fontFamily: popinsSemiBold),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => NotificationSettingsPage()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                notificationICon, // Your notification icon
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
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
                // Filter and Clear Buttons
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
                                        selectedEventType.value =
                                            eventType.eventtypeId;
                                        selectedDate.value =
                                            null; // Clear selected date
                                        setState(() {
                                          _calendarWidgetKey.currentState
                                              ?.resetSelectedDate();
                                          _calendarWidgetKey.currentState
                                              ?._updateDisplayedEvents();
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
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Calendar Widget
                Expanded(
                  child: CalendarWidget(
                    key: _calendarWidgetKey,
                    selectedEvents: eventTypeController.selectedEvents,
                    initialDate: DateTime.now(),
                    eventDates: eventDates,
                    selectedEventType: selectedEventType,
                    onEventsUpdated: _updateSelectedEvents,
                    selectedDate: selectedDate, // Pass reactive selectedDate
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
  final Rxn<DateTime> selectedDate; // Reactive selectedDate
  final List<Event>? selectedEvents;
  final Function(List<Event>) onEventsUpdated;

  const CalendarWidget({
    Key? key,
    required this.selectedEvents,
    required this.initialDate,
    required this.eventDates,
    required this.selectedEventType,
    required this.selectedDate,
    required this.onEventsUpdated,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;
  late PageController _pageController;
  final RxList<Event> _displayedEvents =
      <Event>[].obs; // Initialize as RxList<Event>

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;

    _pageController = PageController(
      initialPage: _calculatePageIndex(_currentDate),
    );

    // React to changes in `selectedDate` and `selectedEventType`
    ever(widget.selectedDate, (_) => _updateDisplayedEvents());
    ever(widget.selectedEventType, (_) => _updateDisplayedEvents());

    // Initialize displayed events
    _initializeSelectedDateAndEvents();
  }

  void resetSelectedDate() {
    setState(() {
      widget.selectedDate.value = null; // Clear selectedDate
      _updateDisplayedEvents(); // Update displayed events
    });
  }

  void _initializeSelectedDateAndEvents() {
    widget.selectedDate.value = null; // Initialize selectedDate
    _updateDisplayedEvents();
  }

  void _updateDisplayedEvents() {
    if (widget.selectedDate.value != null) {
      // Show events for the selected date
      _displayedEvents.value =
          widget.eventDates[widget.selectedDate.value!] ?? [];
    } else {
      // Show events for the current month and selected type
      _displayedEvents.value = widget.eventDates.entries
          .where((entry) =>
              entry.key.year == _currentDate.year &&
              entry.key.month == _currentDate.month &&
              (widget.selectedEventType.value == 0 ||
                  entry.value.any((event) =>
                      event.eventhastype.eventtypeId ==
                      widget.selectedEventType.value)))
          .expand((entry) => entry.value)
          .toList();
    }

    // Notify parent about the updated events
    widget.onEventsUpdated(_displayedEvents);
  }

  int _calculatePageIndex(DateTime date) {
    int currentYear = DateTime.now().year;
    return (date.year - currentYear + 1) * 12 + date.month - 1;
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      int year = DateTime.now().year + ((pageIndex ~/ 12) - 1);
      int month = (pageIndex % 12) + 1;

      _currentDate = DateTime(year, month, 1);
      widget.selectedDate.value =
          null; // Reset selected date on month navigation
      _updateDisplayedEvents(); // Update displayed events for the new month
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

    return Column(
      children: [
        // Obx(() {
        //   return widget.selectedDate.value != null
        //       ? Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             '${DateFormat('dd MMM yyyy').format(widget.selectedDate.value!)}',
        //             style: const TextStyle(
        //               fontSize: 16,
        //               fontFamily: popinsMedium,
        //               color: Colors.black87,
        //             ),
        //           ),
        //         )
        //       : const SizedBox();
        // }),
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
                  Obx(
                    () => Table(
                      children: generateCalendar(daysInMonth, _displayedEvents),
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFCED3DE),
                    thickness: 4,
                    endIndent: 40,
                    indent: 40,
                  ),
                  const SizedBox(height: 16.0),

                  // Display Selected Date
                  // Obx(() {
                  //   return Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text(
                  //       'Selected Date: ${DateFormat('dd MMM yyyy').format(widget.selectedDate.value!)}',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         fontFamily: popinsMedium,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   );
                  // }),

                  // Display Events
                  Obx(() {
                    if (_displayedEvents.isNotEmpty) {
                      // Group events by their dates
                      var groupedEvents =
                          _displayedEvents.fold<Map<DateTime, List<Event>>>(
                        {},
                        (map, event) {
                          final date = event.eventDate;
                          if (!map.containsKey(date)) {
                            map[date] = [];
                          }
                          map[date]!.add(event);
                          return map;
                        },
                      );

                      return Expanded(
                        child: ListView.builder(
                          itemCount: groupedEvents.keys.length,
                          itemBuilder: (context, index) {
                            Rx<DateTime> eventDate =
                                groupedEvents.keys.toList()[index].obs;
                            RxList<Event> events =
                                groupedEvents[eventDate]!.obs;

                            return Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display the event date once as a header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      DateFormat('MMM, dd yyyy')
                                          .format(eventDate.value),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: popinsMedium,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...events.map((event) {
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
                                              : event.paid == '1'
                                                  ? 'Paid Event'
                                                  : '',
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
                                                    : event.paid == '1'
                                                        ? 'Paid Event'
                                                        : '',
                                                style: TextStyle(
                                                    fontFamily: popinsMedium,
                                                    fontSize: 14,
                                                    color: AppClass()
                                                        .hexToColor(event
                                                            .eventhastype
                                                            .eventtypeTextcolor))),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Center(
                          child: Text(
                            'No Events for Selected Month',
                            style: TextStyle(fontFamily: popinsMedium),
                          ),
                        ),
                      );
                    }
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<TableRow> generateCalendar(
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

    DateTime today = DateTime.now();

    // Add day cells with event indicators
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(_currentDate.year, _currentDate.month, day);
      bool isEventDay = widget.eventDates.containsKey(date);
      bool isSelected =
          date == widget.selectedDate.value; // Check if it's selected
      bool isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day; // Check if it's today

      dayCells.add(GestureDetector(
        onTap: () {
          if (widget.selectedDate.value == date) {
            // If the selected date is already today's date, unselect it

            setState(() {
              widget.selectedDate.value = null;
            });
          } else {
            // Otherwise, select the clicked date
            setState(() {
              widget.selectedDate.value = date;
            });
          }
          _updateDisplayedEvents(); // Refresh displayed events below calendar
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
                        colors: [Color(0xFF00A559), Color(0xFF006627)],
                      )
                    : null,
                color: widget.selectedDate.value == null
                    ? whiteColor
                    : isToday
                        ? whiteColor
                        : whiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? whiteColor
                        : isToday
                            ? Colors.red // Text color for today
                            : Colors.black87,
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
