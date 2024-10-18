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
  HomeStaticBackground({super.key,});


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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(homeUpBh),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  _buildDateAndCompassExpanded(homeController),
                  _buildQiblahIndicator(
                      context, screenWidth, qiblahController, homeController),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateAndCompassExpanded(HomeController homeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 192,
            height: 180, // Increase height to accommodate multiple children
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: 192,
                            height: 50,
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              elevation: 5,
                              color: const Color(0xFF5B7B79),
                              child: Center(
                                child: Text(
                                  '${hijri.day} ${hijri.month.en} ${hijri.year}\n'
                                  '${gregorian.weekday.en},${gregorian.day} ${gregorian.month.en} ${gregorian.year}',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.roboto().debugLabel,
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
                          left: 10,
                          bottom: 30,
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: 120,
                            height: 34,
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              elevation: 5,
                              color: const Color(0xFF5B7B79),
                              child: Center(
                                child: Obx(
                                  () => Text(
                                    homeController.currentTime.value,
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
                          left: 15,
                          bottom: 20,
                          child: Container(
                              width: 20.51,
                              height: 20.51,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: primaryColor),
                              child: Image.asset(clock)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Space between elements
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: 100,
                            height: 34,
                            child: Card(
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
                        ),
                        Positioned(
                          left: 15,
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
                                  mosque,
                                  height: 12.4,
                                  width: 12.4,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(
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
    return SizedBox(
      width: 160,
      height: 167.72,
      child: Stack(
        alignment: Alignment.center, // Center all elements in the Stack
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

                // Avoid recreating the animation and controller in every build
                if (controller.animation == null ||
                    controller.begin != qiblahDirection.qiblah) {
                  controller.animation = Tween(
                    begin: controller.begin,
                    end: (qiblahDirection.qiblah * (pi / 180) * -1),
                  ).animate(controller.animationController);

                  controller.begin = (qiblahDirection.qiblah * (pi / 180) * -1);

                  // Start animation
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
                          compass1,
                          width: 155.7, // Scale the image size appropriately
                          height: 167.72, // Adjust height based on design
                          fit: BoxFit.contain,
                        ),
                        Image.asset(
                          homeBgUp2,
                          width: screenWidth * 0.4,
                          height: 120,
                          fit: BoxFit.contain,
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
          Positioned(
            top: 90, // Adjust according to your design
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
            bottom: 75, // Adjust according to your design
            child: Text(
              homeController.getCurrentPrayer(),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                color: primaryColor,
                fontSize: 13,
              ),
            ),
          ),
          // This part remains fixed in the center
          Positioned(
            bottom: 95, // Adjust according to your design
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Time Remaining in',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
