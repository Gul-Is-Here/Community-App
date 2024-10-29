import 'dart:math';
import 'package:community_islamic_app/views/azan_settings/azan_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/qibla_controller.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/namaz_timmings/namaztimmings.dart';

class HomeStaticBackground extends StatelessWidget {
  // final String azanTime;
  // final String iqamaTime;
  // final String sunset;
  // final String sunshine;
  // final String imageAzan;
  // final String imageIqama;
  // final String imageSunset;
  // final String imageSunshine;
  HomeStaticBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final homeController = Get.find<HomeController>();
    final qiblahController = Get.put(QiblahController());

    return Column(
      children: [
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(homeUpBh),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  _buildDateAndCompassExpanded(homeController, context),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, right: 10),
                    child: _buildQiblahIndicator(
                        context, screenWidth, qiblahController, homeController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateAndCompassExpanded(
      HomeController homeController, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * .48,
            height: screenHeight *
                .23, // Increase height to accommodate multiple children
            child: Obx(() {
              if (homeController.isLoading.value) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: primaryColor,
                    size: 50.0,
                  ),
                );
              } else if (homeController.prayerTime.value.data != null) {
                final gregorian =
                    homeController.prayerTime.value.data!.date.gregorian;
                final hijri = homeController.prayerTime.value.data!.date.hijri;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 192,
                            height: 64,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              margin: const EdgeInsets.all(0),
                              elevation: 5,
                              color: const Color(0xFF5B7B79),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    '${hijri.day} ${hijri.month.en} ${hijri.year}\n'
                                    '${gregorian.day} ${gregorian.month.en} ${gregorian.year}\n ${homeController.currentTime.value}',
                                    style: GoogleFonts.cairo(
                                      // fontFamily: popinsRegulr,
                                      color: whiteColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 45,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor),
                            child: const Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Space between elements

                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: 71,
                                height: 34,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  margin: const EdgeInsets.all(0),
                                  elevation: 5,
                                  color: const Color(0xFF5B7B79),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        homeController.formatPrayerTime(
                                            homeController
                                                .getPrayerTimes()
                                                .toString()),
                                        style: TextStyle(
                                          fontFamily: popinsSemiBold,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 20,
                              child: Container(
                                  width: 20.51,
                                  height: 20.51,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: primaryColor),
                                  child: Image.asset(azanlogo)),
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: 71,
                              height: 34,
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                color: const Color(0xFF5B7B79),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      homeController.formatPrayerTime(
                                          homeController.getCurrentIqamaTime()),
                                      style: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -5,
                              bottom: 20,
                              child: Container(
                                  width: 20.51,
                                  height: 20.51,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Image.asset(
                                      iqamalogo,
                                      height: 12.4,
                                      width: 12.4,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: 71,
                                height: 34,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  margin: const EdgeInsets.all(0),
                                  elevation: 5,
                                  color: const Color(0xFF5B7B79),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        homeController.formatPrayerTime(
                                          homeController.prayerTime.value.data!
                                              .timings.sunrise,
                                        ),
                                        style: TextStyle(
                                          fontFamily: popinsSemiBold,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 20,
                              child: Container(
                                  width: 20.51,
                                  height: 20.51,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: primaryColor),
                                  child: Image.asset(
                                    sunrise,
                                    color: whiteColor,
                                  )),
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: 71,
                              height: 34,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                margin: const EdgeInsets.all(0),
                                elevation: 5,
                                color: const Color(0xFF5B7B79),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      homeController.formatPrayerTime(
                                        homeController.prayerTime.value.data!
                                            .timings.sunset,
                                      ),
                                      style: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -5,
                              bottom: 20,
                              child: Container(
                                  width: 20.51,
                                  height: 20.51,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: primaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Image.asset(
                                      sunset,
                                      height: 12.4,
                                      width: 12.4,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.heightBox,
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "Unable to load prayer times",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: popinsRegulr,
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblahIndicator(BuildContext context, double screenWidth,
      QiblahController controller, HomeController homeController) {
    const Duration countdownDuration = Duration(hours: 1, minutes: 5);
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

                      if (controller.animation == null ||
                          controller.begin != qiblahDirection.qiblah) {
                        controller.animation = Tween(
                          begin: controller.begin,
                          end: (qiblahDirection.qiblah * (pi / 180) * -1),
                        ).animate(controller.animationController);

                        controller.begin =
                            (qiblahDirection.qiblah * (pi / 180) * -1);

                        controller.animationController.forward(from: 0);
                      }

                      return AnimatedBuilder(
                        animation: controller.animation,
                        builder: (context, child) => Transform.rotate(
                          angle: controller.animation.value,
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
                                top: -0,
                                // bottom: 0,
                                child: Image.asset(
                                  qiblaMainIcon,
                                  height: screenHeight * .035,
                                ),
                              ),
                            ],
                          ),
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
                  top: 88,
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
                  bottom: 75,
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

                Positioned(
                  bottom: 95,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Time Remaining',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            width: 170,
            height: 180.72,
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

                      if (controller.animation == null ||
                          controller.begin != qiblahDirection.qiblah) {
                        controller.animation = Tween(
                          begin: controller.begin,
                          end: (qiblahDirection.qiblah * (pi / 180) * -1),
                        ).animate(controller.animationController);

                        controller.begin =
                            (qiblahDirection.qiblah * (pi / 180) * -1);

                        controller.animationController.forward(from: 0);
                      }

                      return AnimatedBuilder(
                        animation: controller.animation,
                        builder: (context, child) => Transform.rotate(
                          angle: controller.animation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                qiblaCircleIcon2,
                                width: 170.7,
                                height: 180.72,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 0,
                                // bottom: 0,
                                child: Image.asset(
                                  qiblaMainIcon,
                                ),
                              ),
                            ],
                          ),
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
                  width: 137,
                  height: 137,
                  fit: BoxFit.contain,
                ),

                Positioned(
                  top: 100,
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
                  bottom: 75,
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

                Positioned(
                  bottom: 95,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Time Remaining',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
