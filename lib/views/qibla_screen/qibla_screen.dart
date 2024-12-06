import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';

import '../../constants/color.dart';
import '../../constants/image_constants.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/qibla_controller.dart';

class QiblahScreen extends StatelessWidget {
  QiblahScreen({super.key});

  final QiblahController controller = Get.put(QiblahController());
  final homeController = Get.find<HomeController>();
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Qibla Direction',
          style: TextStyle(
            fontFamily: popinsSemiBold,
            color: Colors.black,
            fontSize: screenHeight * 0.022,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF006367),
              ),
            );
          }

          if (snapshot.hasData) {
            final qiblahDirection = snapshot.data!;
            controller.updateQiblahDirection(qiblahDirection.qiblah);

            // Calculate the rotation angle for compass
            double rotationAngle = qiblahDirection.direction * (pi / 180);

            return Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(20),
                    isSelected: [true, false],
                    constraints: BoxConstraints.expand(
                        width: screenWidth * 0.35, height: 40),
                    fillColor: primaryColor,
                    selectedColor: Colors.white,
                    color: primaryColor,
                    children: const [
                      Text(
                        'Compass',
                        style: TextStyle(fontFamily: popinsSemiBold),
                      ),
                      Text(
                        'Arrow',
                        style: TextStyle(fontFamily: popinsSemiBold),
                      ),
                    ],
                    onPressed: (_) {
                      // Optional for toggling future features.
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildInfoCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        label: 'Your angle to Qibla',
                        value: '${qiblahDirection.qiblah.toStringAsFixed(0)}°',
                      ),
                      buildInfoCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        label: 'Qibla angle from N',
                        value:
                            '${qiblahDirection.direction.toStringAsFixed(0)}°',
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: rotationAngle,
                        child: Image.asset(
                          updatedCompase,
                          fit: BoxFit.cover,
                          height: screenHeight * 0.35,
                          width: screenWidth * 0.7,
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.15,
                        child: Image.asset(
                          masjidIcon, // Replace with your Kaaba icon asset
                          height: screenHeight * 0.07,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Qibla angle : ${qiblahDirection.qiblah.toStringAsFixed(0)}°",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                      fontFamily: popinsRegulr,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // Image.asset(
                  //   masjidIcon, // Replace with the footer masjid line asset
                  //   width: screenWidth,
                  //   fit: BoxFit.cover,
                  // ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Unable to get Qiblah direction,\nPlease restart the app",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoCard({
    required double screenWidth,
    required double screenHeight,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: screenHeight * 0.025,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: screenHeight * 0.015,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
