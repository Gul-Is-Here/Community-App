import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/controllers/live_stream_controller.dart';
import 'package:community_islamic_app/controllers/prayer_controller.dart';
import 'package:community_islamic_app/views/home_screens/masjid_map/map_splash_screen.dart';
import 'package:community_islamic_app/views/namaz_timmings/namaztimmings.dart';
import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:community_islamic_app/views/quran_screen.dart/quran_screen.dart';
import 'package:community_islamic_app/widgets/blink_dot.dart';
import 'package:community_islamic_app/widgets/featureWidgetIcons.dart';
import 'package:community_islamic_app/widgets/our_services_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../controllers/prayerTimingsController.dart';
import '../hijri_calendar.dart';
import '../model/prayer_times_static_model.dart';
import '../services/notification_service.dart';
import '../views/azan_settings/azan_settings_screen.dart';
import '../views/azan_settings/events_notification_settinons.dart';
import '../views/home_screens/comming_soon_screen.dart';
import '../views/liveStream/liveStream_page.dart';
import '../views/liveStream/youtube_player_widget.dart';
import 'announcements_widgets.dart';
import 'customized_prayertext_widget.dart';
import 'eventsWidgets.dart';
import 'myText.dart';

class CustomizedMobileLayout extends StatefulWidget {
  final double screenHeight;

  CustomizedMobileLayout({super.key, required this.screenHeight});

  @override
  State<CustomizedMobileLayout> createState() => _CustomizedMobileLayoutState();
}

class _CustomizedMobileLayoutState extends State<CustomizedMobileLayout> {
  // Controllers and services
  final HomeController homeController = Get.put(HomeController());

  final prayerContrler = Get.put(PrayerTimingController());

  final LiveStreamController liveStreamController =
      Get.put(LiveStreamController());

  final HomeEventsController eventsController = Get.put(HomeEventsController());

  final NotificationServices notificationServices = NotificationServices();

  final AppClass appClass = AppClass();

  Future<void> getPrayerTimes() async {
    await homeController.updateCurrentPrayer();
    await homeController.currentPrayerTitle.value;
  }

  @override
  void initState() {
    eventsController.fetchEventsData();
    eventsController.fetchAlertsData();
    prayerContrler.fetchPrayerTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight1 = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final iqamatimes = _getAllIqamaTimes();

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        image: const DecorationImage(
          opacity: .02,
          image: AssetImage(homeNewBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight1 * .05),
            _buildHeader(context),
            Center(
              child: SizedBox(
                height: screenHeight1 * .20,
                width: 350,
                child: Card(
                  color: const Color(0xFF032727),
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: screenHeight1 * .01,
                        left: screenHeight1 * .015,
                        top: screenWidth * .015),
                    child: Column(
                      children: [
                        _buildPrayerTimeHeader(),
                        _buildCurrentPrayerDisplay(context),
                        _buildAdditionalInfo(iqamatimes, context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            _buildSectionTitle(
              title: 'PRAYER TIME',
              trailing: _buildLiveStreamButton(),
            ),
            const SizedBox(height: 10),
            buildPrayerTimesCard(),
            EventsWidget(
              eventsController: eventsController,
              homeController: homeController,
            ),
            AnnouncementWidget(
              eventsController: eventsController,
              homeController: homeController,
            ),
            buildOurServicesSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.045; // Adaptive text size
    double iconSize = screenWidth * 0.09; // Adaptive icon size

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Logo & Title Section
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  aboutUsIcon,
                  height: iconSize,
                  width: iconSize,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: MyText(
                          'Rosenberg Community Center',
                          style: TextStyle(
                            fontFamily: popinsSemiBold,
                            color: whiteColor,
                            fontSize: textSize.clamp(14, 18),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: MyText(
                          'Faith. Family. Fellowship',
                          style: TextStyle(
                            fontFamily: popinsSemiBold,
                            color: whiteColor,
                            fontSize: textSize * 0.8, // Slightly smaller
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Drawer Menu Button
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: whiteColor,
                  size: iconSize,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the top part of the prayer time card showing remaining time and sunrise/sunset.
  Widget _buildPrayerTimeHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double textSize =
            screenWidth * 0.03; // Scales text size based on screen width

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => MyText(
                  'Remaining Time (${homeController.timeUntilNextPrayer})',
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: popinsRegulr,
                    fontSize: textSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
            Obx(() {
              final timingsData =
                  homeController.prayerTime.value.todayPrayerTime;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    'Sunrise: ${timingsData.sunrise.isNotEmpty && timingsData.sunset.isNotEmpty ? timingsData.sunrise : '6:54 AM'}',
                    style: TextStyle(
                      color: whiteColor,
                      fontFamily: popinsRegulr,
                      fontSize: textSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005), // Small spacing
                  MyText(
                    'Sunset: ${timingsData.date.isNotEmpty && timingsData.sunset.isNotEmpty ? timingsData.sunset : ''}',
                    style: TextStyle(
                        color: whiteColor,
                        fontFamily: popinsRegulr,
                        fontSize: textSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  /// Builds the central display showing the current prayer, its time, and a blinking dot.
  Widget _buildCurrentPrayerDisplay(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double textSize = screenWidth * 0.08; // Adaptive text size
        final double iconSize = screenWidth * 0.07; // Adaptive icon size

        return Row(
          children: [
            /// Prayer Title
            Expanded(
              child: Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.005),
                          child: MyText(
                            '${homeController.currentPrayerTitle.value} ',
                            style: TextStyle(
                              fontFamily: popinsBold,
                              color: whiteColor,
                              fontSize:
                                  textSize.clamp(26, 30), // Ensures readability
                              overflow:
                                  TextOverflow.ellipsis, // Prevents overflow
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const BlinkingDot(),
                    ],
                  )),
            ),

            /// Share Icon
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              child: GestureDetector(
                onTap: () => appClass.showSocialMediaDialog(context),
                child: Image.asset(
                  shareIcon,
                  width: iconSize.clamp(20, 32), // Ensures proper scaling
                  height: iconSize.clamp(20, 32),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the row below the current prayer display that shows prayer timing, iqama time, and navigation links.
  Widget _buildAdditionalInfo(
      Map<String, String> iqamatimes, BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var textSizeLarge = screenWidth * 0.06; // Responsive text size
    var textSizeSmall = screenWidth * 0.035;
    var iconSize = screenWidth * 0.07;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// First Column (Prayer Info & Navigation Links)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Prayer Time Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Prayer Time Details
                    Obx(() => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize
                              .min, // Prevents infinite width issues
                          children: [
                            MyText(
                              homeController.currentPrayerTimes.value,
                              style: TextStyle(
                                fontFamily: popinsBold,
                                color: whiteColor,
                                fontSize: textSizeLarge.clamp(26, 32),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.01),
                              child: MyText(
                                (homeController.currentPrayerTitle.value
                                        .contains('FAJR'))
                                    ? 'AM'
                                    : 'PM',
                                style: TextStyle(
                                  fontFamily: popinsBold,
                                  color: whiteColor,
                                  // fontSize: textSizeSmall.clamp(14, 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.012),
                              child: MyText(
                                ' (${homeController.currentPrayerIqama.value})',
                                style: TextStyle(
                                  fontFamily: popinsRegulr,
                                  color: whiteColor,
                                  fontSize: textSizeSmall.clamp(10, 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),

                /// Navigation Links Row
                SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                Row(
                  children: [
                    buildNavLink(
                      ' Calendar',
                      () => Get.to(() => const HijriCalendarExample()),
                      Icon(
                        Icons.calendar_month,
                        color: goldenColor,
                        size: iconSize.clamp(15, 22),
                      ),
                    ),
                    buildNavLink(
                      '  View Times',
                      () => Get.to(() => const NamazTimingsScreen()),
                      Icon(
                        Icons.timer,
                        color: goldenColor,
                        size: iconSize.clamp(15, 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// Masjid Location Icon
            GestureDetector(
              onTap: () => Get.to(() => MapSplashScreen()),
              child: Padding(
                padding: EdgeInsets.only(
                    right: screenWidth * 0.03, top: screenHeight * 0.01),
                child: Image.asset(
                  wayMasjid,
                  width: iconSize.clamp(24, 32),
                  height: iconSize.clamp(24, 32),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Helper widget for navigation links in the prayer card.
  Widget buildNavLink(String text, VoidCallback onTap, Icon icIcon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = MediaQuery.of(context).size.width;
        var textSize = screenWidth * 0.03; // Dynamic text scaling
        var iconSize = screenWidth * 0.04; // Dynamic icon scaling

        return GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icIcon.icon,
                color: icIcon.color,
                size: iconSize.clamp(14, 20), // Clamping icon size
              ),
              const SizedBox(width: 4), // Space between icon and text
              MyText(
                text,
                style: TextStyle(
                  fontFamily: popinsRegulr,
                  color: whiteColor,
                  fontSize: textSize.clamp(10, 14), // Clamping text size
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // Dynamic spacing
            ],
          ),
        );
      },
    );
  }

  /// Builds a section title with an optional trailing widget.
  Widget _buildSectionTitle({required String title, Widget? trailing}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = MediaQuery.of(context).size.width;
        var textSize = screenWidth * 0.04; // Dynamic text scaling

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, // Responsive horizontal padding
            vertical: screenWidth * 0.02, // Responsive vertical padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                title,
                style: TextStyle(
                  fontFamily: popinsBold,
                  fontSize:
                      textSize.clamp(16, 20), // Clamping for better scaling
                  color: whiteColor,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        );
      },
    );
  }

  /// Builds the live stream status button.
  Widget _buildLiveStreamButton() {
    return Obx(() {
      var screenWidth = MediaQuery.of(Get.context!).size.width;
      var screenHeight = MediaQuery.of(Get.context!).size.height;
      var textSize = screenWidth * 0.035; // Responsive text size
      var iconSize = screenWidth * 0.05; // Responsive icon size
      var paddingSize = screenWidth * 0.02; // Dynamic padding

      // Show a default live indicator when loading.
      if (liveStreamController.isLoading.value) {
        return Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.003,
            left: screenWidth * 0.015,
            right: screenWidth * 0.015,
          ),
          child: Row(
            children: [
              MyText(
                "LIVE",
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: popinsMedium,
                  fontSize: textSize.clamp(10, 16),
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(
                liveIcon,
                width: iconSize.clamp(16, 24),
                height: iconSize.clamp(16, 24),
              ),
            ],
          ),
        );
      }

      // Determine if the URL is from YouTube.
      bool isYouTubeLink =
          liveStreamController.liveUrl.value.contains("youtube.com") ||
              liveStreamController.liveUrl.value.contains("youtu.be");

      if (liveStreamController.isLive.value) {
        return GestureDetector(
          onTap: () {
            Get.to(
                () => isYouTubeLink ? YouTubePlayerPage() : LiveStreamPage());
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(
                    screenWidth * 0.05), // Adaptive border radius
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.004,
                  horizontal: paddingSize.clamp(6, 12),
                ),
                child: Row(
                  children: [
                    MyText(
                      "LIVE",
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: popinsMedium,
                        fontSize: textSize.clamp(10, 16),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      liveIcon,
                      width: iconSize.clamp(16, 24),
                      height: iconSize.clamp(16, 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  /// Builds the prayer times card that shows the five daily prayer times.
  Widget buildPrayerTimesCard() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(Get.context!).size.width * 0.02), // Responsive padding
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: const Color(0xFF315B5A),
        child: Padding(
          padding: EdgeInsets.all(
              MediaQuery.of(Get.context!).size.width * 0.01), // Dynamic padding
          child: LayoutBuilder(
            builder: (context, constraints) {
              var screenWidth = constraints.maxWidth;
              var prayerWidgetWidth =
                  screenWidth / 5.5; // Ensuring equal width for all prayers
              var fontSize = screenWidth * 0.03; // Dynamic text size
              var spacing = screenWidth * 0.01; // Dynamic spacing

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Fajr Prayer Widget

                  Obx(() {
                    final timing = prayerContrler.prayerData['PrayerTime'];

                    return SizedBox(
                      width: prayerWidgetWidth.clamp(60, 120),
                      child: PrayerTimeWidget(
                        currentPrayer: homeController.heighlite.value,
                        namazName: 'Fajr',
                        timings: timing == null ? '' : timing['Fajr'],
                        iqamatimes: timing == null ? '' : timing['FajrIqamah'],
                        name: 'FAJR',
                      ),
                    );
                  }),

                  /// Dhuhr or Jum'ah Widget based on the day
                  Obx(() {
                    final timing = prayerContrler.prayerData['PrayerTime'];
                    bool isFriday = DateTime.now().weekday == DateTime.friday;

                    return SizedBox(
                      width: prayerWidgetWidth.clamp(60, 120),
                      child: PrayerTimeWidget(
                        currentPrayer: homeController.heighlite.value,
                        namazName: isFriday &&
                                homeController.heighlite.value == 'Jumuah'
                            ? 'Jumuah'
                            : 'Dhuhr',
                        timings: timing == null
                            ? ''
                            // ignore: prefer_if_null_operators
                            : timing['Jumuah'] == ""
                                ? timing['Dhuhr']
                                : timing['Jumuah']['prayer_timing'],

                        // ignore: prefer_if_null_operators
                        iqamatimes: timing == null
                            ? ''
                            // ignore: prefer_if_null_operators
                            : timing['DuhurIqamah'] == null
                                ? ''
                                : timing['DuhurIqamah'],
                        name: isFriday ? 'JUMUAH' : 'DHUHR',
                      ),
                    );
                  }),
                  Obx(() {
                    final timing = prayerContrler.prayerData['PrayerTime'];

                    return SizedBox(
                      width: prayerWidgetWidth.clamp(60, 120),
                      child: PrayerTimeWidget(
                        currentPrayer: homeController.heighlite.value,
                        namazName: 'Asr',
                        timings: timing == null ? '' : timing['Asr'],
                        iqamatimes: timing == null ? '' : timing['AsrIqamah'],
                        name: 'ASR',
                      ),
                    );
                  }),

                  SizedBox(width: spacing),
                  Obx(() {
                    final timing = prayerContrler.prayerData['PrayerTime'];

                    return SizedBox(
                      width: prayerWidgetWidth.clamp(60, 120),
                      child: PrayerTimeWidget(
                        currentPrayer: homeController.heighlite.value,
                        namazName: 'Maghrib',
                        timings: timing == null ? '' : timing['Maghrib'],
                        iqamatimes:
                            timing == null ? '' : timing['MaghribIqamah'],
                        name: 'MAGHRIB',
                      ),
                    );
                  }),
                  Obx(() {
                    final timing = prayerContrler.prayerData['PrayerTime'];

                    return SizedBox(
                      width: prayerWidgetWidth.clamp(60, 120),
                      child: PrayerTimeWidget(
                        currentPrayer: homeController.heighlite.value,
                        namazName: 'Isha',
                        timings: timing == null ? '' : timing['Isha'],
                        iqamatimes: timing == null ? '' : timing['IshaIqamah'],
                        name: 'ISHA',
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Combines the Events and Announcements widgets.

  /// Builds the "Our Services" section with a toggle button.
  Widget buildOurServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'OUR SERVICES',
          trailing: Obx(() => IconButton(
                onPressed: () {
                  eventsController.isHiddenServices.value =
                      !eventsController.isHiddenServices.value;
                },
                icon: Icon(
                  eventsController.isHiddenServices.value
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: whiteColor,
                ),
              )),
        ),
        // const SizedBox(height: 5),
        Obx(() {
          if (!eventsController.isHiddenServices.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OurServicesWidget(
                    title: '5 DAILY\nPRAYERS',
                    image: dailyPrayer,
                    onTap: () {},
                  ),
                  OurServicesWidget(
                      title: 'FREE QURAN CLASSES',
                      image: freeQuranClasses,
                      onTap: () {}),
                  OurServicesWidget(
                    title: 'YOUTH SIRA SERIES',
                    image: youthSeraSeries,
                    onTap: () {},
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OurServicesWidget(
                    title: 'GIRLS HALAQA',
                    image: girlsHaqa,
                    onTap: () {},
                  ),
                  OurServicesWidget(
                    title: 'YOUTH PROGRAM',
                    image: youthProgram,
                    onTap: () {},
                  ),
                  OurServicesWidget(
                    title: 'YOUTH SOCCER CLUB',
                    image: youthsoccorClub,
                    onTap: () {},
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  /// Helper function to retrieve all IQama times based on the current date.
  Map<String, String> _getAllIqamaTimes() {
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('d/M').format(now);
    DateTime currentDate = appClass.parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = appClass.parseDate(timing.startDate);
      DateTime endDate = appClass.parseDate(timing.endDate);
      DateTime maghribTime = now.add(const Duration(minutes: 5));
      String formattedTime = DateFormat("hh:mm a").format(maghribTime);
      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        return {
          'Fajr': timing.fjar,
          'Dhuhr': timing.zuhr,
          'Asr': timing.asr,
          'Maghrib': formattedTime,
          'Isha': timing.isha,
        };
      }
    }

    return {
      'Fajr': '',
      'Dhuhr': '',
      'Asr': '',
      'Maghrib': '',
      'Isha': '',
    };
  }
}
