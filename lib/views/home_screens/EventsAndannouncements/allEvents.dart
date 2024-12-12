import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/widgets/eventsWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/model/home_events_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../app_classes/app_class.dart';

class AllEventsDatesScreen extends StatelessWidget {
  final HomeEventsController eventsController = Get.put(HomeEventsController());

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
            child: Column(
              children: [
                SizedBox(
                    height: 40,
                    child: ListView.builder(
                        // itemExtent: 70,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            eventsController.events.value!.data.events.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                eventsController
                                                .events
                                                .value!
                                                .data
                                                .events[index]
                                                .eventhastype
                                                .eventtypeName ==
                                            'Boys and Girls (Under 16)' ||
                                        eventsController
                                                .events
                                                .value!
                                                .data
                                                .events[index]
                                                .eventhastype
                                                .eventtypeName ==
                                            'Sisters Only'
                                    ? Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xFFB9EED2)),
                                        height: 41,
                                        width: 80,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              eventsController
                                                  .events
                                                  .value!
                                                  .data
                                                  .events[index]
                                                  .eventhastype
                                                  .eventtypeName,
                                              style: TextStyle(
                                                  fontFamily: popinsMedium),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xFFB9EED2)),
                                        height: 41,
                                        width: 59,
                                        child: Center(
                                          child: Text(
                                            eventsController
                                                .events
                                                .value!
                                                .data
                                                .events[index]
                                                .eventhastype
                                                .eventtypeName,
                                            style: TextStyle(
                                                fontFamily: popinsMedium),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        })),
                Expanded(
                  child: CalendarWidget(
                    initialDate: DateTime.now(),
                    eventDates: eventDates,
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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _initializeSelectedDateAndEvents();
    _pageController = PageController(initialPage: _currentDate.month - 1);
  }

  void _initializeSelectedDateAndEvents() {
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

  void _onPageChanged(int pageIndex) {
    setState(() {
      _currentDate = DateTime(DateTime.now().year, pageIndex + 1, 1);
    });
    _updateSelectedEvents(DateTime(_currentDate.year, _currentDate.month, 1));
  }

  @override
  Widget build(BuildContext context) {
    final HomeEventsController eventsController =
        Get.put(HomeEventsController());
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
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  ),
                  icon: const Icon(Icons.arrow_back_ios, size: 15),
                  color: primaryColor,
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('MMMM').format(_currentDate),
                      style: const TextStyle(
                          fontSize: 20, fontFamily: popinsMedium),
                    ),
                    Text(
                      DateFormat('yyyy').format(_currentDate),
                      style: TextStyle(
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
            )),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: 12,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              DateTime currentPageDate =
                  DateTime(DateTime.now().year, index + 1, 1);

              // Group events by date
              final Map<DateTime, List<Event>> groupedEvents = {};
              for (var event in _selectedEvents ?? []) {
                final date = DateTime(
                  event.eventDate.year,
                  event.eventDate.month,
                  event.eventDate.day,
                );
                if (!groupedEvents.containsKey(date)) {
                  groupedEvents[date] = [];
                }
                groupedEvents[date]!.add(event);
              }

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
                  if (_selectedEvents != null && _selectedEvents!.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupedEvents.keys.length,
                        itemBuilder: (context, groupIndex) {
                          final date = groupedEvents.keys.elementAt(groupIndex);
                          final events = groupedEvents[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display the date only once
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  DateFormat('d MMMM yyyy').format(date),
                                  style: TextStyle(
                                    fontFamily: popinsRegulr,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Display events for the date
                              ...events.map((event) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          AppClass()
                                              .EventDetailsShowModelBottomSheet(
                                                  context);
                                          // Get.to(() => EventsDetailsScreen(
                                          //       imageUrl: event.eventImage,
                                          //       eventDate: event.eventDate
                                          //           .toString(),
                                          //       eventDetails:
                                          //           event.eventDetail,
                                          //       eventLink: event.eventLink,
                                          //     ));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 54,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD5CEFB),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            icMale,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high,
                                                            fit: BoxFit.cover),
                                                      ),
                                                      Text(
                                                        event.eventTitle,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: primaryColor,
                                                          fontFamily:
                                                              popinsMedium,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: event.paid == '0'
                                                        ? Text(
                                                            'Free Event',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  popinsMedium,
                                                              fontSize: 16,
                                                              color: event.paid ==
                                                                      '1'
                                                                  ? Color(
                                                                      0xFF735BF2)
                                                                  : const Color(
                                                                      0xFF0095FF),
                                                            ),
                                                          )
                                                        : Text('Paid Event'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
                style: TextStyle(
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
      int eventCount = isEventDay ? widget.eventDates[date]!.length : 0;

      dayCells.add(GestureDetector(
        onTap: () {
          _updateSelectedEvents(date);
        },
        child: Column(
          children: [
            Container(
              width: 38,
              height: 40,
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
                      color: isSelected ? Colors.white : Colors.black87,
                      fontFamily: popinsMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (isEventDay) ...[
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  eventCount,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: isEventDay
                          ? Border.all(color: Color(0xFF00A53C))
                          : Border.all(color: whiteColor),
                    ),
                  ),
                ),
              ),
              5.heightBox,
            ],
          ],
        ),
      ));

      if ((day + firstWeekday - 1) % 7 == 0) {
        rows.add(TableRow(children: dayCells));
        dayCells = [];
      }
    }

    // Add empty cells for remaining days of the week
    if (dayCells.isNotEmpty) {
      while (dayCells.length < 7) {
        dayCells.add(const SizedBox());
      }
      rows.add(TableRow(children: dayCells));
    }

    return rows;
  }
}
