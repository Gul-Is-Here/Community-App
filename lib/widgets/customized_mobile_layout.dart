import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/controllers/live_stream_controller.dart';
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

class CustomizedMobileLayout extends StatelessWidget {
  final double screenHeight;

  CustomizedMobileLayout({super.key, required this.screenHeight});

  // Controllers and services
  final HomeController homeController = Get.put(HomeController());
  final LiveStreamController liveStreamController =
      Get.put(LiveStreamController());
  final HomeEventsController eventsController = Get.put(HomeEventsController());
  final NotificationServices notificationServices = NotificationServices();
  final AppClass appClass = AppClass();

  @override
  Widget build(BuildContext context) {
    homeController.updateCurrentPrayer();
    homeController.currentPrayerTitle.value;
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
            const SizedBox(height: 40),
            _buildHeader(context),
            Center(
              child: SizedBox(
                height: screenHeight1 * .24,
                width: 350,
                child: Card(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPrayerTimeHeader(),
                        _buildCurrentPrayerDisplay(),
                        _buildAdditionalInfo(iqamatimes),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle(
              title: 'Prayer Time',
              trailing: _buildLiveStreamButton(),
            ),
            const SizedBox(height: 10),
            _buildPrayerTimesCard(iqamatimes),
            _buildEventsAndAnnouncements(),
            _buildFeaturesSection(),
            _buildOurServicesSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Builds the header row with community name and menu button.
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Image.asset(
                aboutUsIcon,
                height: 32,
                width: 32,
              ),
              const SizedBox(width: 5),
              Text(
                'Rosenberg Community Center',
                style: TextStyle(
                  fontFamily: popinsSemiBold,
                  color: whiteColor,
                  fontSize: 15,
                ),
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
          ),
        ),
      ],
    );
  }

  /// Builds the top part of the prayer time card showing remaining time and sunrise/sunset.
  Widget _buildPrayerTimeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text(
              'Remaining Time (${homeController.timeUntilNextPrayer})',
              style: TextStyle(
                color: whiteColor,
                fontFamily: popinsRegulr,
                fontSize: 10,
              ),
            )),
        Obx(() {
          final timingsData = homeController.prayerTime.value.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sunrise : ${timingsData != null && timingsData.timings.sunrise.isNotEmpty ? homeController.formatPrayerTime(timingsData.timings.sunrise) : '6:54 AM'}',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: popinsRegulr,
                  fontSize: 10,
                ),
              ),
              Text(
                'Sunset : ${timingsData != null && timingsData.timings.sunset.isNotEmpty ? homeController.formatPrayerTime(timingsData.timings.sunset) : ''}',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: popinsRegulr,
                  fontSize: 10,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Builds the central display showing the current prayer, its time, and a blinking dot.
  Widget _buildCurrentPrayerDisplay() {
    return Row(
      children: [
        Obx(() => Text(
              '${homeController.currentPrayerTitle.value} ',
              style: TextStyle(
                fontFamily: popinsBold,
                color: whiteColor,
                fontSize: 28,
              ),
            )),
        // const SizedBox(width: 10),
        const BlinkingDot(),
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
    );
  }

  /// Builds the row below the current prayer display that shows prayer timing, iqama time, and navigation links.
  Widget _buildAdditionalInfo(Map<String, String> iqamatimes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      homeController.currentPrayerTimes.value,
                      style: TextStyle(
                        fontFamily: popinsBold,
                        color: whiteColor,
                        fontSize: 24,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Obx(() => Text(
                        homeController.currentPrayerTitle.value ==
                                    'Next: Fajr' ||
                                homeController.currentPrayerTitle.value ==
                                    'Iqama: Fajr'
                            ? 'AM'
                            : 'PM',
                        style: TextStyle(
                          fontFamily: popinsBold,
                          color: whiteColor,
                          fontSize: 16,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Obx(() => Text(
                        ' (${homeController.currentPrayerIqama})',
                        style: TextStyle(
                          fontFamily: popinsRegulr,
                          color: whiteColor,
                          fontSize: 11,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildNavLink(' Calendar',
                    () => Get.to(() => const HijriCalendarExample())),
                _buildNavLink('  View Times',
                    () => Get.to(() => const NamazTimingsScreen())),
                _buildNavLink(
                    '  Events', () => Get.to(() => NotificationSettingsPage())),
              ],
            )
          ],
        ),
        GestureDetector(
          onTap: () => appClass.showSocialMediaDialog(Get.context!),
          child: Column(
            children: [
              // const SizedBox(height: 6),
              Image.asset(
                shareIcon,
                width: 30,
                height: 30,
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [goldenColor, goldenColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Connect',
                  style: TextStyle(
                    fontFamily: popinsRegulr,
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => MapSplashScreen());
                },
                child: Image.asset(
                  wayMasjid,
                  width: 30,
                  height: 30,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// Helper widget for navigation links in the prayer card.
  Widget _buildNavLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: popinsRegulr,
            color: whiteColor,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  /// Builds a section title with an optional trailing widget.
  Widget _buildSectionTitle({required String title, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: popinsBold,
              fontSize: 16,
              color: whiteColor,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  /// Builds the live stream status button.
  Widget _buildLiveStreamButton() {
    return Obx(() {
      // Show a default live indicator when loading.
      if (liveStreamController.isLoading.value) {
        return Row(
          children: [
            Text(
              "LIVE",
              style: TextStyle(
                color: whiteColor,
                fontFamily: popinsMedium,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Image.asset(
              liveIcon,
              width: 20,
              height: 20,
            )
          ],
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
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  "LIVE",
                  style: TextStyle(
                      color: whiteColor,
                      // fontWeight: FontWeight.bold,
                      fontFamily: popinsMedium),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  liveIcon,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }

  /// Builds the prayer times card that shows the five daily prayer times.
  Widget _buildPrayerTimesCard(Map<String, String> iqamatimes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: const Color(0xFF315B5A),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fajr Prayer Widget
              Obx(() {
                final timingsData = homeController.prayerTime.value.data;
                return PrayerTimeWidget(
                  currentPrayer: homeController.heighlite.value,
                  namazName: 'Fajr',
                  timings: timingsData != null
                      ? timingsData.timings.fajr
                      : '6:33 AM',
                  iqamatimes: iqamatimes,
                  name: 'FAJR',
                );
              }),
              // Dhuhr or Jum'ah Widget based on day
              Obx(() {
                bool isFriday = DateTime.now().weekday == DateTime.friday;
                if (isFriday) {
                  return PrayerTimeWidget(
                    currentPrayer: homeController.heighlite.value,
                    namazName: 'Dhuhr',
                    timings: homeController.jummaTimes.value.data != null
                        ? homeController
                            .jummaTimes.value.data!.jumah.prayerTiming
                        : '12:10 PM',
                    iqamatimes: iqamatimes,
                    name: 'JUMUAH',
                  );
                } else {
                  final timingsData = homeController.prayerTime.value.data;
                  return PrayerTimeWidget(
                    currentPrayer: homeController.heighlite.value,
                    namazName: 'Dhuhr',
                    timings: timingsData != null
                        ? timingsData.timings.dhuhr
                        : '12:10 PM',
                    iqamatimes: iqamatimes,
                    name: 'DHUHR',
                  );
                }
              }),
              // Asr Prayer Widget
              Obx(() {
                final timingsData = homeController.prayerTime.value.data;
                return PrayerTimeWidget(
                  currentPrayer: homeController.heighlite.value,
                  namazName: 'Asr',
                  timings: timingsData != null
                      ? timingsData.timings.asr
                      : '03:04 PM',
                  iqamatimes: iqamatimes,
                  name: 'ASR',
                );
              }),
              // Maghrib Prayer Widget
              Obx(() {
                final timingsData = homeController.prayerTime.value.data;
                return PrayerTimeWidget(
                  currentPrayer: homeController.heighlite.value,
                  namazName: 'Maghrib',
                  timings: timingsData != null
                      ? timingsData.timings.maghrib
                      : '05:23 PM',
                  iqamatimes: iqamatimes,
                  name: 'MAGHRIB',
                );
              }),
              // Isha Prayer Widget
              Obx(() {
                final timingsData = homeController.prayerTime.value.data;
                return PrayerTimeWidget(
                  currentPrayer: homeController.heighlite.value,
                  namazName: 'Isha',
                  timings: timingsData != null
                      ? timingsData.timings.isha
                      : '06:33 PM',
                  iqamatimes: iqamatimes,
                  name: 'ISHA',
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Combines the Events and Announcements widgets.
  Widget _buildEventsAndAnnouncements() {
    return Column(
      children: [
        EventsWidget(
          eventsController: eventsController,
          homeController: homeController,
        ),
        AnnouncementWidget(
          eventsController: eventsController,
          homeController: homeController,
        ),
      ],
    );
  }

  /// Builds the Features section with a toggle button.
  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'Features',
          trailing: Obx(() => IconButton(
                onPressed: () {
                  eventsController.isHiddenFeature.value =
                      !eventsController.isHiddenFeature.value;
                },
                icon: Icon(
                  eventsController.isHiddenFeature.value
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: whiteColor,
                ),
              )),
        ),
        Obx(() {
          if (!eventsController.isHiddenFeature.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FeatureWidgeticons(
                    icons: quranIcon,
                    onTap: () =>
                        Get.to(() => const QuranScreen(isNavigation: true)),
                  ),
                  FeatureWidgeticons(
                    icons: azkarIcon,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  FeatureWidgeticons(
                    icons: haditIcon,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  FeatureWidgeticons(
                    icons: duaIcon,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  FeatureWidgeticons(
                    icons: tasbihIcon,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  FeatureWidgeticons(
                    icons: qiblaIcon,
                    onTap: () => Get.to(() => QiblahScreen(isNavigation: true)),
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

  /// Builds the "Our Services" section with a toggle button.
  Widget _buildOurServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          title: 'Our Services',
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
        const SizedBox(height: 5),
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
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  OurServicesWidget(
                    title: 'FREE QURAN CLASSES',
                    image: freeQuranClasses,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  OurServicesWidget(
                    title: 'YOUTH SIRA SERIES',
                    image: youthSeraSeries,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
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
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  OurServicesWidget(
                    title: 'YOUTH PROGRAM',
                    image: youthProgram,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
                  ),
                  OurServicesWidget(
                    title: 'YOUTH SOCCER CLUB',
                    image: youthsoccorClub,
                    onTap: () => Get.to(() => const CommingSoonScreen()),
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

    return {
      'Fajr': '',
      'Dhuhr': '',
      'Asr': '',
      'Maghrib': '',
      'Isha': '',
    };
  }
}
