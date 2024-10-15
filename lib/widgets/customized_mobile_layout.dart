import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/views/Gallery_Events/galler_screen.dart';
import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:community_islamic_app/views/project/project_screen.dart';
import 'package:community_islamic_app/widgets/social_media_widget.dart';
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

import '../views/services_screen/services_screen.dart';
import 'announcements_widgets.dart';
import 'eventsWidgets.dart';
import 'home_static_background.dart';

// ignore: must_be_immutable
class CustomizedMobileLayout extends StatelessWidget {
  final double screenHeight;
  CustomizedMobileLayout({super.key, required this.screenHeight});

  final HomeController homeController = Get.put(HomeController());
  final NotificationServices notificationServices = NotificationServices();
  var eventsController = Get.put(HomeEventsController());

  String? currentIqamaTime;

  // @override
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final screenHeight1 = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            HomeStaticBackground(
              screenHeight: screenHeight,
              // dateTime: homeController.prayerTimes.value.data!.date.readable,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .22),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 10,
                        color: const Color(0xFFEAF3F2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => AboutUsScreen());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 10,
                                      color: const Color(0xFF06313F),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          aboutUsIcon,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'About',
                                    style: TextStyle(
                                        fontFamily: popinsMedium, fontSize: 11),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ServicesScreen());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 10,
                                      color: const Color(0xFF06313F),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          aboutUsIcon,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Services',
                                    style: TextStyle(
                                        fontFamily: popinsMedium, fontSize: 11),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const ProjectScreen());
                                },
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 10,
                                      color: const Color(0xFF06313F),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          aboutUsIcon,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Project',
                                      style: TextStyle(
                                          fontFamily: popinsMedium,
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => GalleyScreen());
                                },
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 10,
                                      color: const Color(0xFF06313F),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          aboutUsIcon,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Gallery',
                                      style: TextStyle(
                                          fontFamily: popinsMedium,
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
            ),
            10.heightBox,
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight1 * .22, right: screenHeight1 * .37),
              child: const SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SocialMediaFloatingButton())),
            )
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
              DateFormat("h:mm a").format(now.add(const Duration(minutes: 5))),
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
}
