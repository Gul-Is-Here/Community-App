import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../controllers/login_controller.dart';
import '../model/prayer_times_static_model.dart';
import '../services/notification_service.dart';
import 'announcements_widgets.dart';
import 'customized_asr_widget.dart';
import 'eventsWidgets.dart';

// ignore: must_be_immutable
class CustomizedMobileLayout extends StatelessWidget {
  final double screenHeight;

  CustomizedMobileLayout({super.key, required this.screenHeight});

  final HomeController homeController = Get.put(HomeController());
  final NotificationServices notificationServices = NotificationServices();
  var eventsController = Get.put(HomeEventsController());

  // String? currentIqamaTime;

  String? currentIqamaTime;

  @override
  Widget build(BuildContext context) {
    homeController.jummaTimes.value;
    final LoginController loginController = Get.put(LoginController());
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var iqamatimes = getAllIqamaTimes();
    var currentPrayer = homeController.getCurrentPrayer();

    return Container(
      decoration: const BoxDecoration(
        // color: primaryColor,
        image: DecorationImage(
          opacity: 1,
          image: AssetImage(homeNewBg),
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Flexible(
                      child: Text(
                        'Rosenberg Community Centre',
                        style: TextStyle(
                            fontFamily: popinsSemiBold,
                            color: whiteColor,
                            fontSize: 12),
                      ),
                    ),
                  ),
                  // 10.widthBox,
                  TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      'Donate Us',
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: popinsRegulr,
                          fontSize: 14),
                    ),
                    icon: Image.asset(
                      donateUs,
                      height: 30,
                      width: 30,
                    ),
                  )
                ],
              ),
              // 10.heightBox,
              Center(
                child: SizedBox(
                    height: 150,
                    width: 350,
                    child: Card(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 hour 50 min left (2:00PM)',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontFamily: popinsRegulr,
                                      fontSize: 10),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Suhur : 6:54 AM',
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontFamily: popinsRegulr,
                                          fontSize: 10),
                                    ),
                                    // 5.heightBox,
                                    Text(
                                      'Iftar : 5:24 PM',
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontFamily: popinsRegulr,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Now : Dhuhr',
                                  style: TextStyle(
                                      fontFamily: popinsBold,
                                      color: whiteColor,
                                      fontSize: 28),
                                ),
                                10.widthBox,
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF6CFD74),
                                      borderRadius: BorderRadius.circular(20)),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '12:09',
                                          style: TextStyle(
                                              fontFamily: popinsBold,
                                              color: whiteColor,
                                              fontSize: 24),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'PM',
                                            style: TextStyle(
                                                fontFamily: popinsBold,
                                                color: whiteColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            ' (Start Time)',
                                            style: TextStyle(
                                                fontFamily: popinsRegulr,
                                                color: whiteColor,
                                                fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Education ',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          ' Calendar',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          '  Story Time',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          ' Today Goal',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      shareIcon,
                                      width: 30,
                                      height: 30,
                                    ),
                                    ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                        colors: [
                                          goldenColor,
                                          goldenColor2
                                        ], // Define your gradient colors
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                      child: const Text(
                                        'Share',
                                        style: TextStyle(
                                          fontFamily: popinsRegulr,
                                          fontSize: 12,
                                          color: Colors
                                              .white, // Set a base color (ignored in ShaderMask)
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  'Prayer Time',
                  style: TextStyle(
                      fontFamily: popinsBold, fontSize: 16, color: whiteColor),
                ),
              ),
              10.heightBox,
              Row(
                children: [
                  Obx(
                    () => PrayerTimeWidget(
                      currentPrayer: getCurrentPrayer(),
                      namazName: 'Isha',
                      timings:
                          homeController.prayerTime.value.data!.timings.isha,
                      iqamatimes: iqamatimes,
                      name: 'ISHA',
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  AnnouncementWidget(
                      eventsController: eventsController,
                      homeController: homeController),
                  EventsWidget(
                      eventsController: eventsController,
                      homeController: homeController),
                ],
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
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

String addMinutesToPrayerTime(String prayerTime, int minutesToAdd) {
  try {
    final dateTime = DateFormat("HH:mm").parse(prayerTime);
    DateTime updatedTime = dateTime.add(Duration(minutes: minutesToAdd));
    return DateFormat('h:mm a').format(updatedTime);
  } catch (e) {
    print('Error parsing time: $e');
    return 'Invalid time';
  }

  ///
  ///.
  ///
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

// Function to format prayer time
String formatPrayerTime(String time) {
  try {
    final dateTime = DateFormat("HH:mm").parse(time);
    return DateFormat("h:mm a").format(dateTime);
  } catch (e) {
    return time;
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
  });

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
          width: screenWidth * .33,
          height: screenHeight1 * .065,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFF042838), Color(0xFF0F6467)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
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
                                  child: Text(
                                    formatPrayerTimeToAmPm(timings),
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
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
                                  child: Text(
                                    iqamaTime,
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
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
