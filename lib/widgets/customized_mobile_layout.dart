import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/model/prayer_model.dart';
import 'package:community_islamic_app/views/Gallery_Events/galler_screen.dart';
import 'package:community_islamic_app/views/about_us/about_us.dart';
import 'package:community_islamic_app/views/project/project_screen.dart';
import 'package:community_islamic_app/widgets/customized_prayertext_widget.dart';
import 'package:community_islamic_app/widgets/social_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  // String? currentIqamaTime;

  // @override
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // if (homeController.prayerTime.value.data == null) {
    // Show loading indicator while fetching data
    //   return Center(
    //     child: SpinKitFadingCircle(
    //       color: Colors.blue, // or your preferred color
    //       size: 50.0,
    //     ),
    //   );
    // }
    // Get Azan and Iqama times
    var iqamatimes = getAllIqamaTimes();
    var currentPrayer = homeController.getCurrentPrayer();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            HomeStaticBackground(
                // screenHeight: screenHeight,
                // dateTime: homeController.prayerTimes.value.data!.date.readable,
                ),
            // homeController.prayerTime.value.data != null
            Padding(
              padding: const EdgeInsets.only(top: 180.0, left: 17),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 106,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => homeController.prayerTime.value.data == null
                          ? Center(child: Text(''))
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.baseline,
                                  children: [
                                    PrayerTimeWidget(
                                      azanIcon: azanlogo,
                                      iqamaIcon: iqamalogo,
                                      namazName: 'Fajr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.fajr,
                                      iqamatimes: iqamatimes,
                                      name: 'Fajr',
                                      currentPrayer:
                                          getCurrentPrayer(), // Pass the current prayer name
                                      imageIcon: morningIcon, // Your icon asset
                                    ),
                                    2.widthBox,
                                    PrayerTimeWidget(
                                      azanIcon: azanlogo,
                                      iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: afternoon,
                                      namazName: 'Dhuhr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.dhuhr,
                                      iqamatimes: iqamatimes,
                                      name: 'Dhuhr',
                                    ),
                                    2.widthBox,
                                    PrayerTimeWidget(
                                      azanIcon: azanlogo,
                                      iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: morningIcon,
                                      namazName: 'Asr',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.asr,
                                      iqamatimes: iqamatimes,
                                      name: 'Asr',
                                    ),
                                    2.widthBox,
                                    PrayerTimeWidget(
                                      azanIcon: azanlogo,
                                      iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: dayandNight,
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
                                      name: 'Maghrib',
                                    ),
                                    2.widthBox,
                                    PrayerTimeWidget2(
                                      azanIcon: azanlogo,
                                      iqamaIcon: iqamalogo,
                                      currentPrayer: getCurrentPrayer(),
                                      imageIcon: night,
                                      namazName: 'Isha',
                                      timings: homeController
                                          .prayerTime.value.data!.timings.isha,
                                      iqamatimes: iqamatimes,
                                      name: 'Isha',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .35),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 105,
                        child: Card(
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
                                          fontFamily: popinsMedium,
                                          fontSize: 11),
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
                                          fontFamily: popinsMedium,
                                          fontSize: 11),
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
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => GalleyScreen());
                                  },
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            elevation: 10,
                                            color: const Color(0xFF06313F),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                aboutUsIcon,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'RCC Live',
                                            style: TextStyle(
                                                fontFamily: popinsMedium,
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: 5,
                                        left: 45,
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                  top: screenHeight1 * .245, right: screenHeight1 * .37),
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

class PrayerTimeWidget extends StatelessWidget {
  const PrayerTimeWidget({
    super.key,
    required this.azanIcon,
    required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
    required this.imageIcon,
  });

  final String imageIcon;
  final String azanIcon;
  final String iqamaIcon;
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
        ? Color(0xFF042838) // Highlight color for current prayer
        : const Color(0xFF5B7B79); // Default color for other prayers

    return Stack(
      clipBehavior: Clip.none, // Allow the icon to overflow
      children: [
        SizedBox(
          width: screenWidth * .18,
          height: screenHeight1 * .1,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: backgroundColor, // Background color changes dynamically
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: popinsMedium,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 10), // Use SizedBox for spacing
                  Row(
                    children: [
                      Image.asset(
                        iqamaIcon,
                        width: 15,
                        height: 10,
                        // fit: BoxFit.contai,
                      ),
                      Text(
                        formatPrayerTimeToAmPm(timings), // Format Azan time
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsMedium,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Image.asset(
                        azanIcon,
                        width: 15,
                        height: 10,
                      ),
                      Text(
                        iqamaTime, // Already formatted Iqama time
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsMedium,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: -16, // Adjust the vertical position of the icon
        //   left: 0, // Adjust horizontal position if needed
        //   right: 0, // Center the icon horizontally
        //   child: Image.asset(
        //     cardCircle,
        //     height: 24,
        //     width: 24,
        //     color: Colors.red, // Icon color
        //   ),
        // ),
        Positioned(
          top: -19, // Adjust the vertical position of the icon
          left: 0, // Adjust horizontal position if needed
          right: 0, // Center the icon horizontally
          child: Image.asset(
            imageIcon,
            height: 24,
            width: 24,
            color: Colors.black45, // Icon color
          ),
        ),
      ],
    );
  }
}

// Prayer Widget 2

class PrayerTimeWidget2 extends StatelessWidget {
  const PrayerTimeWidget2({
    super.key,
    required this.azanIcon,
    required this.iqamaIcon,
    required this.namazName,
    required this.name,
    required this.timings,
    required this.iqamatimes,
    required this.currentPrayer, // Current prayer passed from the controller
    required this.imageIcon,
  });

  final String imageIcon;
  final String azanIcon;
  final String iqamaIcon;
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
        ? Color(0xFF042838) // Highlight color for current prayer
        : const Color(0xFF5B7B79); // Default color for other prayers

    return screenWidth < 450 || screenHeight1 < 900
        ? Stack(
            clipBehavior: Clip.none, // Allow the icon to overflow
            children: [
              SizedBox(
                width: screenWidth * .18,
                height: screenHeight1 * .1,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color:
                      backgroundColor, // Background color changes dynamically
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: popinsMedium,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 10), // Use SizedBox for spacing
                        Row(
                          children: [
                            Image.asset(
                              iqamaIcon,
                              width: 15,
                              height: 10,
                              // fit: BoxFit.contai,
                            ),
                            Text(
                              formatPrayerTimeToAmPm(
                                  timings), // Format Azan time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Image.asset(
                              azanIcon,
                              width: 15,
                              height: 10,
                            ),
                            Text(
                              iqamaTime, // Already formatted Iqama time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: -16, // Adjust the vertical position of the icon
              //   left: 0, // Adjust horizontal position if needed
              //   right: 0, // Center the icon horizontally
              //   child: Image.asset(
              //     cardCircle,
              //     height: 24,
              //     width: 24,
              //     color: Colors.red, // Icon color
              //   ),
              // ),
              Positioned(
                top: -17, // Adjust the vertical position of the icon
                left: 0, // Adjust horizontal position if needed
                right: 0, // Center the icon horizontally
                child: Image.asset(
                  imageIcon,
                  height: 24,
                  width: 24,
                  color: Colors.black45, // Icon color
                ),
              ),
            ],
          )
        : Stack(
            clipBehavior: Clip.none, // Allow the icon to overflow
            children: [
              SizedBox(
                width: 78,
                height: 85,
                child: Card(
                  color:
                      backgroundColor, // Background color changes dynamically
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: popinsMedium,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 10), // Use SizedBox for spacing
                        Row(
                          children: [
                            Image.asset(
                              azanIcon,
                              width: 20,
                            ),
                            Text(
                              formatPrayerTimeToAmPm(
                                  timings), // Format Azan time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Image.asset(
                              iqamaIcon,
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              iqamaTime, // Already formatted Iqama time
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: popinsMedium,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: -16, // Adjust the vertical position of the icon
              //   left: 0, // Adjust horizontal position if needed
              //   right: 0, // Center the icon horizontally
              //   child: Image.asset(
              //     cardCircle,
              //     height: 24,
              //     width: 24,
              //     color: Colors.red, // Icon color
              //   ),
              // ),
              Positioned(
                top: -17, // Adjust the vertical position of the icon
                left: 0, // Adjust horizontal position if needed
                right: 0, // Center the icon horizontally
                child: Image.asset(
                  imageIcon,
                  height: 24,
                  width: 24,
                  color: Colors.black45, // Icon color
                ),
              ),
            ],
          );
  }
}

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
    return DateFormat("h:mm a").format(dateTime);
  } catch (e) {
    print('Error parsing time: $e');
    return 'Invalid time'; // Return a default message for invalid input
  }
}
