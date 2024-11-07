import 'package:blinking_text/blinking_text.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../services/notification_service.dart';
import '../model/prayer_times_static_model.dart';

import 'announcements_widgets.dart';
import 'eventsWidgets.dart';
import 'home_static_background.dart';
import 'isha_prayer_widget.dart';

// ignore: must_be_immutable
class CustomizedMobileLayout extends StatelessWidget {
  final double screenHeight;
  CustomizedMobileLayout({super.key, required this.screenHeight});

  final HomeController homeController = Get.put(HomeController());
  final NotificationServices notificationServices = NotificationServices();
  var eventsController = Get.put(HomeEventsController());

  // String? currentIqamaTime;

  // @override
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    var iqamatimes = getAllIqamaTimes();
    var currentPrayer = homeController.getCurrentPrayer();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            HomeStaticBackground(
                // screenHeight: screenHeight,
                // dateTime: homeController.prayerTimes.value.data!.date.readable,
                ),
            20.heightBox,
            // homeController.prayerTime.value.data != null
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => homeController.prayerTime.value.data == null
                      ? Center(child: Text(''))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.baseline,
                                  children: [
                                    PrayerTimeWidget(
                                      // azanIcon: azanlogo,
                                      // iqamaIcon: iqamalogo,
                                      namazName: 'Fajr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.fajr,
                                      iqamatimes: iqamatimes,
                                      name: 'FAJR',
                                      currentPrayer:
                                          getCurrentPrayer(), // Pass the current prayer name
                                      imageIcon: sunriseIcon, // Your icon asset
                                    ),
                                    5.widthBox,
                                    PrayerTimeWidget(
                                      // azanIcon: azanlogo,
                                      // iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: sunriseIcon,
                                      namazName: 'Dhuhr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.dhuhr,
                                      iqamatimes: iqamatimes,
                                      name: 'DHUHR',
                                    ),
                                    5.widthBox,
                                    PrayerTimeWidget(
                                      // azanIcon: azanlogo,
                                      // iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: sunriseIcon,
                                      namazName: 'Asr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.asr,
                                      iqamatimes: iqamatimes,
                                      name: 'ASR',
                                    ),
                                  ],
                                ),
                                5.heightBox,
                                Row(
                                  children: [
                                    PrayerTimeWidget(
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: sunsetIcon,
                                      namazName: 'Maghrib',
                                      timings: homeController.prayerTime.value
                                          .data!.timings.maghrib,
                                      iqamatimes: {
                                        // Ensure this is a Map<String, String>
                                        'Maghrib': addMinutesToPrayerTime(
                                            homeController.prayerTime.value
                                                .data!.timings.dhuhr,
                                            5), // Add 5 minutes to Maghrib Azan time
                                      },
                                      name: 'MAGHRIB',
                                    ),
                                    5.widthBox,
                                    Obx(
                                      () => PrayerTimeWidget(
                                        currentPrayer: getCurrentPrayer(),
                                        imageIcon: sunriseIcon,
                                        namazName: 'Isha',
                                        timings: homeController.prayerTime.value
                                            .data!.timings.isha,
                                        iqamatimes: iqamatimes,
                                        name: 'ISHA',
                                      ),
                                    ),
                                    5.widthBox,
                                    Obx(
                                      () => PrayerTimeWidget2(
                                        currentPrayer: getCurrentPrayer(),
                                        imageIcon: sunriseIcon,
                                        namazName: 'Jumuah',
                                        timings: homeController.jummaTimes.value
                                            .data!.jumah.prayerTiming,
                                        iqamatimes: homeController.jummaTimes
                                            .value.data!.jumah.iqamahTiming,
                                        name: 'JUMUAH',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    10.heightBox,
                    Column(
                      children: [
                        AnnouncementWidget(
                            eventsController: eventsController,
                            homeController: homeController),
                        EventsWidget(
                            eventsController: eventsController,
                            homeController: homeController),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getCurrentPrayer() {
    final now = DateTime.now();
    final timeNow =
        DateFormat("HH:mm").format(now); // Formatting the current time
    var newTime = DateFormat("HH:mm").parse(timeNow);

    // Check if prayer times data is available
    if (homeController.prayerTime.value.data?.timings != null) {
      final timings = homeController.prayerTime.value.data!.timings;

      // Parse prayer times from the API data
      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      // Compare the current time with prayer times
      if (newTime.isBefore(fajrTime)) {
        return 'Fajr';
      } else if (newTime.isBefore(dhuhrTime)) {
        return 'Dhuhr';
      } else if (newTime.isBefore(asrTime)) {
        return 'Asr';
      } else if (newTime.isBefore(maghribTime)) {
        return 'Maghrib';
      } else if (newTime.isBefore(ishaTime)) {
        return 'Isha';
      } else {
        // If current time is after all prayer times, default to Fajr of the next day
        return 'Fajr';
      }
    }

    // Return a default prayer time if prayer times are not available
    return 'Isha';
  }

  // Function to find the current Iqama timings based on the current prayer time
  Map<String, String> getAllIqamaTimes() {
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('d/M').format(now);
    DateTime currentDate = parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = parseDate(timing.startDate);
      DateTime endDate = parseDate(timing.endDate);

      // Ensure the date range includes the current date
      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        return {
          'Fajr': timing.fjar,
          'Dhuhr': timing.zuhr,
          'Asr': timing.asr,
          'Maghrib':
              DateFormat("hh:mm a").format(now.add(const Duration(minutes: 5))),
          'Isha': timing.isha,
        };
      }
    }

    // Return default values if no timing is found
    return {
      'Fajr': 'Not available',
      'Dhuhr': 'Not available',
      'Asr': 'Not available',
      'Maghrib': 'Not available',
      'Isha': 'Not available',
    };
  }

// Function to find and return Azan names for all prayers based on the date range
  Map<String, String> getAllAzanNamesForCurrentDate() {
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('d/M').format(now);
    DateTime currentDate = parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = parseDate(timing.startDate);
      DateTime endDate = parseDate(timing.endDate);

      // Ensure the date range includes the current date
      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        return {
          'Fajr': 'Fajr',
          'Dhuhr': 'Dhuhr',
          'Asr': 'Asr',
          'Maghrib': 'Maghrib',
          'Isha': 'Isha',
        };
      }
    }

    // Return default values if no date range is found
    return {
      'Fajr': 'Fajr',
      'Dhuhr': 'Dhuhr',
      'Asr': 'Asr',
      'Maghrib': 'Maghrib',
      'Isha': 'Isha',
    };
  }

// Function to parse a date string in "d/M" format to DateTime
  DateTime parseDate(String dateStr) {
    return DateFormat('d/M').parse(dateStr);
  }

  Object? getPrayerTimes() {
    if (homeController.currentPrayerTime == 'Fajr') {
      return homeController.prayerTime.value.data?.timings.fajr;
    } else if (homeController.currentPrayerTime == 'Dhuhr') {
      return homeController.prayerTime.value.data?.timings.dhuhr;
    } else if (homeController.currentPrayerTime == 'Asr') {
      return homeController.prayerTime.value.data?.timings.asr;
    } else if (homeController.currentPrayerTime == 'Maghrib') {
      return homeController.prayerTime.value.data?.timings.maghrib;
    } else {
      return homeController.prayerTime.value.data?.timings.isha;
    }
  }

  // Function to format prayer time
  String formatPrayerTime(String time) {
    try {
      final dateTime = DateFormat("HH:mm").parse(time);
      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      return time;
    }
  }
}

class PrayerTimeWidget extends StatelessWidget {
  const PrayerTimeWidget({
    super.key,
    // required this.azanIcon,
    // required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
    required this.imageIcon,
  });

  final String imageIcon;
  // final String azanIcon;
  // final String iqamaIcon;
  final String currentPrayer; // Current prayer time passed to compare
  final String name; // Prayer name (e.g., Fajr, Dhuhr)
  final String namazName; // Specific namaz name for Iqama lookup
  final String timings; // Azan time (in "HH:mm" format)
  final Map<String, String> iqamatimes; // Iqama times

  @override
  Widget build(BuildContext context) {
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Default Iqama time
    String iqamaTime = iqamatimes[namazName] ?? 'Not available';

    // Check if the prayer is Maghrib and adjust the Iqama time accordingly
    if (namazName == 'Maghrib') {
      iqamaTime = formatPrayerTimeToAmPm(
        addMinutesToPrayerTime(timings, 5), // Add and format
      );
    }

    // Set background color based on current prayer
    Color backgroundColor = (currentPrayer == namazName)
            ? const Color(0xFF5B7B79)
            : const Color(0xFF042838) // Highlight color for current prayer
        ; // Default color for other prayers

    return Stack(
      clipBehavior: Clip.none, // Allow the icon to overflow
      children: [
        SizedBox(
          width: screenWidth * .3,
          height: screenHeight1 * .07,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors: [Color(0xFF042838), Color(0xFF0F6467)])),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        imageIcon,
                        fit: BoxFit.cover,
                        height: 20,
                        width: 19,
                        color: whiteColor,
                      ),
                      2.widthBox,
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsMedium,
                          color: whiteColor,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          currentPrayer == namazName
                              ? Center(
                                  child: BlinkText(
                                    formatPrayerTimeToAmPm(timings),
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    endColor: primaryColor,
                                    duration: const Duration(seconds: 4),
                                  ),
                                )
                              : Text(
                                  formatPrayerTimeToAmPm(
                                      timings), // Format Azan time
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: popinsMedium,
                                    color: whiteColor,
                                  ),
                                ),
                          5.heightBox,
                          currentPrayer == namazName
                              ? Center(
                                  child: BlinkText(
                                    iqamaTime,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    endColor: primaryColor,
                                    duration: const Duration(seconds: 4),
                                  ),
                                )
                              : Text(
                                  iqamaTime, // Already formatted Iqama time
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: popinsMedium,
                                    color: whiteColor,
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                  // const SizedBox(height: 10), // Use SizedBox for spacing

                  // const SizedBox(height: 2),
                  // Row(
                  //   children: [
                  //     // Image.asset(
                  //     //   azanIcon,
                  //     //   width: 15,
                  //     //   height: 10,
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Prayer Widget 2

// Function to format prayer time
String formatPrayerTime(String time) {
  try {
    final dateTime = DateFormat("HH:mm").parse(time);
    return DateFormat("h:mm a")
        .format(dateTime); // This line formats to h:mm a (12-hour format)
  } catch (e) {
    return 'Invalid time';
  }
}

// Function to add minutes to a prayer time
String addMinutesToPrayerTime(String prayerTime, int minutesToAdd) {
  try {
    final dateTime = DateFormat("HH:mm").parse(prayerTime);
    DateTime updatedTime = dateTime.add(Duration(minutes: minutesToAdd));
    return DateFormat('HH:mm') // Keep returning in HH:mm format for processing
        .format(updatedTime);
  } catch (e) {
    return 'Invalid time'; // Return a default message for invalid input
  }
}

String formatPrayerTimeToAmPm(String time) {
  try {
    // Parse the input time from "HH:mm" format
    final dateTime = DateFormat("HH:mm").parse(time);
    // Format it to "hh:mm a" format
    return DateFormat("hh:mm a").format(dateTime);
  } catch (e) {
    print('Error parsing time: $e');
    return 'Invalid time'; // Return a default message for invalid input
  }
}
