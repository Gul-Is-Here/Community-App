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
import 'package:velocity_x/velocity_x.dart';

import '../views/namaz_timmings/namaztimmings.dart';

class HomeStaticBackground extends StatelessWidget {
  HomeStaticBackground({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final homeController = Get.find<HomeController>();
    final qiblahController = Get.put(QiblahController());

    return Container(
      height: screenHeight * 0.24,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(homeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDateAndCompassExpanded(homeController)),
              _buildQiblahIndicator(context, screenWidth, qiblahController),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndCompassExpanded(HomeController homeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Obx(() {
              if (homeController.isLoading.value) {
                // Display loading indicator while data is loading
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        5.widthBox,
                        Expanded(
                          child: Text(
                            ' ${gregorian.day} ${gregorian.month.en} ${gregorian.year}\n'
                            '${hijri.day} ${hijri.month.en} ${hijri.year}H',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Next Athan Time',
                      style:
                          TextStyle(color: asColor, fontFamily: popinsSemiBold),
                    ),
                    Obx(() {
                      return homeController.getCurrentPrayer().isEmpty
                          ? SpinKitFadingCircle(
                              color: primaryColor,
                            )
                          : Text(
                              '(${homeController.getCurrentPrayer()})',
                              style: TextStyle(
                                  color: asColor, fontFamily: popinsSemiBold),
                            );
                    }),
                    10.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          color: Colors.white,
                        ),
                        5.widthBox,
                        Obx(() {
                          return Text(
                            homeController.formatPrayerTime(
                              homeController.getPrayerTimes().toString(),
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontFamily: popinsBold),
                          );
                        }),
                      ],
                    ),
                    5.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        5.widthBox,
                        Obx(() => Text(
                              homeController.formatPrayerTime(
                                  homeController.timeUntilNextPrayer.value),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: popinsBold,
                                  fontSize: 11),
                            )),
                      ],
                    ),
                    5.heightBox,
                    RichText(
                      text: TextSpan(
                        text: 'View Times',
                        style: TextStyle(
                          color: asColor,
                          fontFamily: popinsSemiBold,
                          decoration: TextDecoration.underline,
                          decorationColor: asColor,
                        ),
                      ),
                    ).onTap(() {
                      Get.to(() => NamazTimingsScreen());
                    }),
                  ],
                );
              } else {
                // Fallback if data is not available
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

  Widget _buildQiblahIndicator(
      BuildContext context, double screenWidth, QiblahController controller) {
    return Expanded(
      child: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                color: primaryColor,
                size: 50.0,
              ), // Loading indicator
            );
          }

          if (snapshot.hasData) {
            final qiblahDirection = snapshot.data!;
            controller.animation = Tween(
              begin: controller.begin,
              end: (qiblahDirection.qiblah * (pi / 180) * -1),
            ).animate(controller.animationController);
            controller.begin = (qiblahDirection.qiblah * (pi / 180) * -1);
            controller.animationController.forward(from: 0);

            return Center(
              child: AnimatedBuilder(
                animation: controller.animation,
                builder: (context, child) => Transform.rotate(
                  angle: controller.animation.value,
                  child: Image.asset(
                    compass,
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.4,
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "Unable to get Qiblah direction,\n       Please restart the app",
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
    );
  }
}
