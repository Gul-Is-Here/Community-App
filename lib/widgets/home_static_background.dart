import 'dart:math';
import 'package:community_islamic_app/views/home_screens/masjid_map/map_splash_screen.dart';
import 'package:community_islamic_app/widgets/prayer_widget.dart';
import 'package:community_islamic_app/widgets/social_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:community_islamic_app/constants/color.dart';

import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';

class HomeStaticBackground extends StatelessWidget {
  HomeStaticBackground({super.key});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    homeController.prayerTime.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Column(
          children: [
            Obx(() {
              // Check if prayer time data is available
              if (homeController.prayerTime.value.data == null) {
                // No data available, show an empty container instead of a loading indicator
                return SizedBox.shrink();
              }

              // Display the date and prayer timings once data is loaded
              final gregorianDate =
                  homeController.prayerTime.value.data!.date.gregorian;
              final hijriDate =
                  homeController.prayerTime.value.data!.date.hijri;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${gregorianDate.day} ${gregorianDate.month.en} ${gregorianDate.year}',
                              style: TextStyle(
                                  fontFamily: popinsSemiBold,
                                  color: whiteColor),
                            ),
                            Text(
                              '${hijriDate.day} ${hijriDate.month.en} ${hijriDate.year}',
                              style: TextStyle(
                                  fontFamily: popinsSemiBold,
                                  color: whiteColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrayerTimings(homeController: homeController),
                      ),
                      SizedBox(
                        height: screenHeight * .2,
                        child: SocialMediaFloatingButton(),
                      ),
                      Positioned(
                        top: screenHeight * .12,
                        left: screenWidth * .03,
                        child: FloatingActionButton(
                          elevation: 0,
                          isExtended: true,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            Get.to(() => MapSplashScreen());
                          },
                          child: Image.asset(
                            masjidIcon,
                            height: 45,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * .3,
                        child: QiblahIndicator(homeController: homeController),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}

class PrayerTimings extends StatelessWidget {
  final HomeController homeController;

  PrayerTimings({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTimeCard(
            time: homeController.formatPrayerTime(
              homeController.prayerTime.value.data!.timings.sunrise,
            ),
            icon: sunrise,
          ),
          buildTimeCard(
            time: homeController.formatPrayerTime(
              homeController.prayerTime.value.data!.timings.sunset,
            ),
            icon: sunset,
          ),
        ],
      ),
    );
  }
}

class QiblahIndicator extends StatelessWidget {
  final HomeController homeController;

  QiblahIndicator({required this.homeController});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return screenWidth < 450 || screenHeight < 900
        ? SizedBox(
            width: screenWidth * .4,
            height: screenHeight * .2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50.0,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      final qiblahDirection = snapshot.data!;
                      final rotationAngle =
                          (qiblahDirection.qiblah * (pi / 180) * -1);

                      return Transform.rotate(
                        angle: rotationAngle,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              qiblaCircleIcon2,
                              width: 150.7,
                              height: 170.72,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 0,
                              child: Image.asset(
                                qiblaMainIcon,
                                height: screenHeight * .035,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Unable to get Qiblah direction,\nPlease restart the app",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: asColor,
                            fontFamily: popinsRegulr,
                          ),
                        ),
                      );
                    }
                  },
                ),
                // Static watch image
                Image.asset(
                  watch,
                  width: 115,
                  height: 127,
                  fit: BoxFit.contain,
                ),
                Positioned(
                    top: screenHeight * .08,
                    child: Text(
                      'Time Remaining',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                        color: Colors.black,
                      ),
                    )),
                Positioned(
                  top: screenHeight * .11,
                  child: Obx(() {
                    return Text(
                      homeController.timeUntilNextPrayer.value,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    );
                  }),
                ),
                Positioned(
                  bottom: screenHeight * .09,
                  child: Obx(
                    () => Text(
                      homeController.getCurrentPrayer(),
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            // Larger layout code here...
            );
  }
}
