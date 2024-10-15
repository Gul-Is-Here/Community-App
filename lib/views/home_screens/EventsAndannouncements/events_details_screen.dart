import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package for URL launching

class EventsDetailsScreen extends StatelessWidget {
  final String eventDetails;
  final String eventLink;
  final String eventDate;

  const EventsDetailsScreen({
    super.key,
    required this.eventDate,
    required this.eventDetails,
    required this.eventLink,
  });

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime parsedEventDate = DateTime.parse(eventDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Events Details ',
          style: TextStyle(
            fontFamily: popinsSemiBold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar view with highlighted event date
            CalendarWidget(
              eventDate: parsedEventDate,
              currentDate: currentDate,
            ),
            const SizedBox(height: 20),
            // Event Details Section
            const Text(
              'Event Date:',
              style:
                  TextStyle(fontFamily: popinsSemiBold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(parsedEventDate),
                  style:
                      const TextStyle(fontSize: 16, fontFamily: popinsSemiBold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Event Details Description
            Text(
              eventDetails,
              style: const TextStyle(
                fontFamily: popinsRegulr,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // View Location Button
            ElevatedButton.icon(
              onPressed: () async {
                // Open event link
                if (await canLaunch(eventLink)) {
                  await launch(eventLink);
                } else {
                  throw 'Could not launch $eventLink';
                }
              },
              icon: Icon(
                Icons.location_on,
                color: whiteColor,
              ),
              label: Text(
                'Visit',
                style: TextStyle(
                  fontFamily: popinsMedium,
                  color: whiteColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final DateTime eventDate;
  final DateTime currentDate;

  const CalendarWidget(
      {super.key, required this.eventDate, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    // Generate days for the calendar (assuming a simple month view)
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

    return Column(
      children: [
        // Calendar Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // Handle previous month button
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: primaryColor,
              ),
              Text(
                DateFormat('MMMM yyyy').format(currentDate),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Handle next month button
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: primaryColor,
              ),
            ],
          ),
        ),
        // Calendar Days
        Table(
          children: _generateCalendar(daysInMonth, eventDate, currentDate),
        ),
      ],
    );
  }

  // Generates the rows for the calendar
  List<TableRow> _generateCalendar(
      int daysInMonth, DateTime eventDate, DateTime currentDate) {
    List<TableRow> rows = [];
    List<Widget> dayCells = [];

    // Add day names (e.g., Mon, Tue, Wed...)
    dayCells.addAll(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        .map((day) => Center(
              child: Text(
                day,
                style:
                    TextStyle(fontFamily: popinsSemiBold, color: primaryColor),
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
      bool isEventDay = date.year == eventDate.year &&
          date.month == eventDate.month &&
          date.day == eventDate.day;

      dayCells.add(Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isEventDay ? primaryColor : Colors.transparent,
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
