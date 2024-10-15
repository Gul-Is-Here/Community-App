import 'dart:math';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/widgets/customized_prayertext_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/color.dart';
import '../../constants/image_constants.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/qibla_controller.dart';

// ignore: must_be_immutable
class QiblahScreen extends StatelessWidget {
  QiblahScreen({super.key});

  final QiblahController controller = Get.put(QiblahController());
  final homeController = Get.find<HomeController>();
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    String? currentIqamaTime = homeController.getCurrentIqamaTime();

    print('Qibla Screen $currentIqamaTime');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 20,
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          // Background and header design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Card(
              elevation: 10,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                height: screenHeight * 0.25,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(qiblaTopBg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: screenWidth * 0.19,
            child: Text(
              'Qiblah Locator',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.035,
                fontWeight: FontWeight.bold,
                fontFamily: popinsBold,
              ),
            ),
          ),
          StreamBuilder(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Positioned(
                  bottom: screenHeight * 0.2,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Color(0xFF006367),
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                final qiblahDirection = snapshot.data!;

                // Set animation values and smooth transition
                if (controller.animationController.status ==
                    AnimationStatus.completed) {
                  controller.animation = Tween(
                    begin: controller.begin,
                    end: (qiblahDirection.qiblah * (pi / 180) * -1),
                  ).animate(controller.animationController);
                  controller.begin = controller.animation.value;
                  controller.animationController.forward(from: 0);
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => controller
                                              .locationCountry.value.isEmpty
                                          ? CircularProgressIndicator(
                                              color: primaryColor,
                                            )
                                          : Text(
                                              '${controller.locationCountry}, ${controller.locationCity}',
                                              style: TextStyle(
                                                fontFamily: popinsRegulr,
                                                color: Colors.grey,
                                                fontSize: screenHeight * 0.015,
                                              ),
                                            ),
                                    ),
                                    5.widthBox,
                                    "|"
                                        .text
                                        .color(primaryColor)
                                        .size(20)
                                        .make(),
                                    5.widthBox,
                                    Icon(
                                      Icons.location_on,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: controller.animation,
                          builder: (context, child) => Transform.rotate(
                            angle: controller.animation.value,
                            child: Image.asset(
                              controller.selectedImage.value,
                              height: screenHeight * 0.3,
                              width: screenWidth * 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Display Qiblah direction in degrees
                      Text(
                        "Qiblah Direction: ${qiblahDirection.qiblah.toStringAsFixed(2)}°",
                        style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsBold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Theme and image options
                      Container(
                        width: double.infinity,
                        height: 40,
                        color: primaryColor,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Theme',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: popinsBold,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            imageOptions.length,
                            (index) => GestureDetector(
                              onTap: () {
                                controller.selectedImage.value =
                                    imageOptions[index];
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 5, color: Color(0xFF006367)),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      imageOptions[index],
                                      height: screenHeight * 0.08,
                                      width: screenWidth * 0.16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Positioned(
                  bottom: screenHeight * 0.5,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Unable to get Qiblah direction,\n       Please restart the app",
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
