import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/views/home_screens/comming_soon_screen.dart';
import 'package:community_islamic_app/views/namaz_timmings/namaztimmings.dart';
import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:community_islamic_app/views/quran_screen.dart/quran_screen.dart';
import 'package:community_islamic_app/widgets/blink_dot.dart';
import 'package:community_islamic_app/widgets/featureWidgetIcons.dart';
import 'package:community_islamic_app/widgets/our_services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../controllers/login_controller.dart';
import '../hijri_calendar.dart';
import '../model/prayer_times_static_model.dart';
import '../services/notification_service.dart';
import '../views/azan_settings/azan_settings_screen.dart';
import 'announcements_widgets.dart';
import 'customized_prayertext_widget.dart';
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
  final appClass = AppClass();

  @override
  Widget build(BuildContext context) {
    eventsController.feedsList;
    getCurrentPrayer();
    homeController.jummaTimes.value;
    final LoginController loginController = Get.put(LoginController());
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('Height : $screenHeight1');
    print('width : $screenWidth');
    var iqamatimes = getAllIqamaTimes();
    homeController.getCurrentPrayer();

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        image: const DecorationImage(
          opacity: .02,
          image: AssetImage(homeNewBg),
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        aboutUsIcon,
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Rosenberg Community Center',
                        style: TextStyle(
                            fontFamily: popinsSemiBold,
                            color: whiteColor,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: whiteColor,
                    ))
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
                              Obx(
                                () => Text(
                                  '${homeController.timeUntilNextPrayer}',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontFamily: popinsRegulr,
                                      fontSize: 10),
                                ),
                              ),
                              Obx(
                                () => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    homeController.prayerTime.value.data !=
                                                null &&
                                            homeController
                                                .prayerTime
                                                .value
                                                .data!
                                                .timings
                                                .sunrise
                                                .isNotEmpty
                                        ? Text(
                                            'Sunrise : ${homeController.formatPrayerTime(homeController.prayerTime.value.data!.timings.sunrise)}',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontFamily: popinsRegulr,
                                              fontSize: 10,
                                            ),
                                          )
                                        : Text(
                                            'Sunrise : 6:54 AM',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontFamily: popinsRegulr,
                                              fontSize: 10,
                                            ),
                                          ),

                                    // 5.heightBox,
                                    homeController.prayerTime.value.data !=
                                                null &&
                                            homeController.prayerTime.value
                                                .data!.timings.sunset.isNotEmpty
                                        ? Text(
                                            'Sunset : ${homeController.formatPrayerTime(homeController.prayerTime.value.data!.timings.sunset)}',
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontFamily: popinsRegulr,
                                                fontSize: 10),
                                          )
                                        : Text(
                                            'Sunset : ',
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontFamily: popinsRegulr,
                                                fontSize: 10),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  '${homeController.getCurrentPrayer()} ',
                                  style: TextStyle(
                                      fontFamily: popinsBold,
                                      color: whiteColor,
                                      fontSize: 28),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BlinkingDot(),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const AzanSettingsScreen());
                                  },
                                  child: Image.asset(
                                    notificationICon,
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
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
                                      Obx(
                                        () => Text(
                                          homeController
                                              .getNextPrayerTimeWithIqama(),
                                          style: TextStyle(
                                              fontFamily: popinsBold,
                                              color: whiteColor,
                                              fontSize: 24),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: homeController
                                                    .getCurrentPrayerTime() ==
                                                'Fajr'
                                            ? Text(
                                                'AM',
                                                style: TextStyle(
                                                    fontFamily: popinsBold,
                                                    color: whiteColor,
                                                    fontSize: 16),
                                              )
                                            : Text(
                                                'PM',
                                                style: TextStyle(
                                                    fontFamily: popinsBold,
                                                    color: whiteColor,
                                                    fontSize: 16),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Obx(
                                          () => Text(
                                            ' (${homeController.getCurrentPhase()})',
                                            style: TextStyle(
                                                fontFamily: popinsRegulr,
                                                color: whiteColor,
                                                fontSize: 11),
                                          ),
                                        ),
                                      ),
                                      //
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //   'Education ',
                                      //   style: TextStyle(
                                      //       fontFamily: popinsRegulr,
                                      //       color: whiteColor,
                                      //       fontSize: 11),
                                      // ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() =>
                                              const HijriCalendarExample());
                                        },
                                        child: Text(
                                          ' Calendar',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              () => const NamazTimingsScreen());
                                        },
                                        child: Text(
                                          '  View Times',
                                          style: TextStyle(
                                              fontFamily: popinsRegulr,
                                              color: whiteColor,
                                              fontSize: 11),
                                        ),
                                      ),
                                      // Text(
                                      //   ' Today Goal',
                                      //   style: TextStyle(
                                      //       fontFamily: popinsRegulr,
                                      //       color: whiteColor,
                                      //       fontSize: 11),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  appClass.showSocialMediaDialog(context);
                                },
                                child: Column(
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
                                        'Connect',
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
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Prayer Time',
                style: TextStyle(
                    fontFamily: popinsBold, fontSize: 16, color: whiteColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.all(0),
                color: const Color(0xFF315B5A),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        // Check if the prayerTime data is null before accessing it
                        if (homeController.prayerTime.value.data == null) {
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Fajr',
                            timings:
                                '6:33 AM', // Default value when prayerTime data is null
                            iqamatimes: iqamatimes,
                            name: 'FAJR',
                          );
                        }

                        // If the data is not null, use the actual prayer time
                        return PrayerTimeWidget(
                          currentPrayer: getCurrentPrayer(),
                          namazName: 'Fajr',
                          timings: homeController
                              .prayerTime.value.data!.timings.fajr,
                          iqamatimes: iqamatimes,
                          name: 'FAJR',
                        );
                      }),

                      // Similarly handle the other prayer times to prevent null errors
                      Obx(() {
                        bool isFriday =
                            DateTime.now().weekday == DateTime.friday;

                        if (isFriday) {
                          if (homeController.jummaTimes.value.data == null) {
                            return PrayerTimeWidget(
                              currentPrayer: getCurrentPrayer(),
                              namazName: 'Dhuhr',
                              timings:
                                  '12:10 PM', // Default value when prayerTime data is null
                              iqamatimes: iqamatimes,
                              name: 'JUMUAH',
                            );
                          }
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Dhuhr',
                            timings: homeController
                                .jummaTimes.value.data!.jumah.prayerTiming,
                            iqamatimes: iqamatimes,
                            name: 'JUMUAH',
                          );
                        } else {
                          if (homeController.prayerTime.value.data == null) {
                            return PrayerTimeWidget(
                              currentPrayer: getCurrentPrayer(),
                              namazName: 'Dhuhr',
                              timings:
                                  '12:10 PM', // Default value when prayerTime data is null
                              iqamatimes: iqamatimes,
                              name: 'DHUHR',
                            );
                          }
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Dhuhr',
                            timings: homeController
                                .prayerTime.value.data!.timings.dhuhr,
                            iqamatimes: iqamatimes,
                            name: 'DHUHR',
                          );
                        }
                      }),

                      Obx(() {
                        if (homeController.prayerTime.value.data == null) {
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Asr',
                            timings:
                                '03:04 PM', // Default value when prayerTime data is null
                            iqamatimes: iqamatimes,
                            name: 'ASR',
                          );
                        }
                        return PrayerTimeWidget(
                          currentPrayer: getCurrentPrayer(),
                          namazName: 'Asr',
                          timings:
                              homeController.prayerTime.value.data!.timings.asr,
                          iqamatimes: iqamatimes,
                          name: 'ASR',
                        );
                      }),

                      Obx(() {
                        if (homeController.prayerTime.value.data == null) {
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Maghrib',
                            timings:
                                '05:23 PM', // Default value when prayerTime data is null
                            iqamatimes: iqamatimes,
                            name: 'MAGHRIB',
                          );
                        }
                        return PrayerTimeWidget(
                          currentPrayer: getCurrentPrayer(),
                          namazName: 'Maghrib',
                          timings: homeController
                              .prayerTime.value.data!.timings.maghrib,
                          iqamatimes: iqamatimes,
                          name: 'MAGHRIB',
                        );
                      }),

                      Obx(() {
                        if (homeController.prayerTime.value.data == null) {
                          return PrayerTimeWidget(
                            currentPrayer: getCurrentPrayer(),
                            namazName: 'Isha',
                            timings:
                                '06:33 PM', // Default value when prayerTime data is null
                            iqamatimes: iqamatimes,
                            name: 'ISHA',
                          );
                        }
                        return PrayerTimeWidget(
                          currentPrayer: getCurrentPrayer(),
                          namazName: 'Isha',
                          timings: homeController
                              .prayerTime.value.data!.timings.isha,
                          iqamatimes: iqamatimes,
                          name: 'ISHA',
                        );
                      }),
                      // Obx(() {

                      // }),
                    ],
                  ),
                ),
              ),
            ),

            Column(
              children: [
                EventsWidget(
                    eventsController: eventsController,
                    homeController: homeController),
                AnnouncementWidget(
                    eventsController: eventsController,
                    homeController: homeController),
              ],
            ),
            // 10.heightBox,

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Features',
                        style: TextStyle(
                            fontFamily: popinsBold,
                            color: whiteColor,
                            fontSize: 16),
                      ),
                      Obx(
                        () => IconButton(
                            onPressed: () {
                              eventsController.isHiddenFeature.value =
                                  !eventsController.isHiddenFeature.value;
                            },
                            icon: eventsController.isHiddenFeature.value
                                ? Icon(
                                    Icons.keyboard_arrow_down,
                                    color: whiteColor,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_up,
                                    color: whiteColor,
                                  )),
                      )
                    ],
                  ),
                ),
                Obx(() {
                  if (!eventsController.isHiddenFeature.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FeatureWidgeticons(
                              icons: quranIcon,
                              onTap: () {
                                Get.to(() => QuranScreen(
                                      isNavigation: true,
                                    ));
                              }),
                          FeatureWidgeticons(
                              icons: azkarIcon,
                              onTap: () {
                                Get.to(() => CommingSoonScreen());
                              }),
                          FeatureWidgeticons(
                              icons: haditIcon,
                              onTap: () {
                                Get.to(() => CommingSoonScreen());
                              }),
                          FeatureWidgeticons(
                              icons: duaIcon,
                              onTap: () {
                                Get.to(() => CommingSoonScreen());
                              }),
                          FeatureWidgeticons(
                              icons: tasbihIcon,
                              onTap: () {
                                Get.to(() => CommingSoonScreen());
                              }),
                          FeatureWidgeticons(
                              icons: qiblaIcon,
                              onTap: () {
                                Get.to(() => QiblahScreen(
                                      isNavigation: true,
                                    ));
                              })
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Our Services',
                        style: TextStyle(
                            fontFamily: popinsBold,
                            color: whiteColor,
                            fontSize: 16),
                      ),
                      Obx(
                        () => IconButton(
                            onPressed: () {
                              eventsController.isHiddenServices.value =
                                  !eventsController.isHiddenServices.value;
                            },
                            icon: eventsController.isHiddenServices.value
                                ? Icon(
                                    Icons.keyboard_arrow_down,
                                    color: whiteColor,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_up,
                                    color: whiteColor,
                                  )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(() {
                  if (!eventsController.isHiddenServices.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OurServicesWidget(
                            title: '5 DAILY\PRAYERS',
                            image: dailyPrayer,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                          OurServicesWidget(
                            title: 'FREE QURAN CLASSES',
                            image: freeQuranClasses,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                          OurServicesWidget(
                            title: 'YOUTH SIRA SERIES',
                            image: youthSeraSeries,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }),
                Obx(() {
                  if (!eventsController.isHiddenServices.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OurServicesWidget(
                            title: 'GIRLS HALAQA',
                            image: girlsHaqa,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                          OurServicesWidget(
                            title: 'YOUTH PROGRAM',
                            image: youthProgram,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                          OurServicesWidget(
                            title: 'YOUTH SOCCER CLUB',
                            image: youthsoccorClub,
                            onTap: () {
                              Get.to(() => CommingSoonScreen());
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                })
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
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
    DateTime currentDate = appClass.parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = appClass.parseDate(timing.startDate);
      DateTime endDate = appClass.parseDate(timing.endDate);

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
    DateTime currentDate = appClass.parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = appClass.parseDate(timing.startDate);
      DateTime endDate = appClass.parseDate(timing.endDate);

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
