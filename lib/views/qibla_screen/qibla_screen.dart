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
  var loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Qibla Locator',
          style: TextStyle(fontFamily: popinsSemiBold, color: whiteColor),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF006367),
              ),
            );
          }

          if (snapshot.hasData) {
            final qiblahDirection = snapshot.data!;
            controller.updateQiblahDirection(qiblahDirection.qiblah);

            // Calculate the angle difference (offset) between current direction and Qiblah direction
            double offsetAngle =
                (qiblahDirection.direction - qiblahDirection.qiblah) % 360;
            if (offsetAngle < 0) offsetAngle += 360;

            // Check alignment with tolerance
            bool isAligned = offsetAngle < 5 || offsetAngle > 355;

            // Calculate the rotation angle for compass
            double rotationAngle = qiblahDirection.direction * (pi / 180);

            // Determine alignment message
            // String guidanceMessage;
            // if (isAligned) {
            //   guidanceMessage = "Aligned! You're facing the Qiblah.";
            // } else if (offsetAngle > 0 && offsetAngle < 180) {
            //   guidanceMessage = "Turn slightly to the left";
            // } else {
            //   guidanceMessage = "Turn slightly to the right";
            // }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  // Compass image with rotation
                  Transform.rotate(
                    angle: rotationAngle,
                    child: Image.asset(
                      updatedCompase,
                      fit: BoxFit.cover,
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Qiblah Direction: ${qiblahDirection.qiblah.toStringAsFixed(0)}°",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                      fontFamily: popinsRegulr,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   guidanceMessage,
                  //   style: TextStyle(
                  //     fontSize: screenHeight * 0.02,
                  //     color: isAligned ? Colors.green : Colors.red,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            );
          } else {
            return Center(
              child: const Text(
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
}




// import 'dart:math';
// import 'package:community_islamic_app/controllers/home_controller.dart';
// import 'package:community_islamic_app/widgets/customized_prayertext_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../constants/color.dart';
// import '../../constants/image_constants.dart';
// import '../../controllers/login_controller.dart';
// import '../../controllers/qibla_controller.dart';

// class QiblahScreen extends StatelessWidget {
//   QiblahScreen({super.key});

//   final QiblahController controller = Get.put(QiblahController());
//   final homeController = Get.find<HomeController>();
//   var loginController = Get.put(LoginController());

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;
//     String? currentIqamaTime = homeController.getCurrentIqamaTime();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Qibla Locator',
//           style: TextStyle(fontFamily: popinsSemiBold, color: whiteColor),
//         ),
//         automaticallyImplyLeading: false,
//         // toolbarHeight: 20,
//         backgroundColor: primaryColor,
//       ),
//       body: Column(
//         children: [
//           // Positioned(
//           //   top: 0,
//           //   left: 0,
//           //   right: 0,
//           //   child: Card(
//           //     elevation: 10,
//           //     margin: EdgeInsets.zero,
//           //     shape: const RoundedRectangleBorder(
//           //       borderRadius: BorderRadius.only(
//           //         bottomLeft: Radius.circular(20),
//           //         bottomRight: Radius.circular(20),
//           //       ),
//           //     ),
//           //     child: Container(
//           //       height: screenHeight * 0.25,
//           //       decoration: const BoxDecoration(
//           //         borderRadius: BorderRadius.only(
//           //           bottomLeft: Radius.circular(20),
//           //           bottomRight: Radius.circular(20),
//           //         ),
//           //         image: DecorationImage(
//           //           image: AssetImage(qiblaTopBg),
//           //           fit: BoxFit.cover,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // Positioned(
//           //   top: screenHeight * 0.10,
//           //   left: screenWidth * 0.20,
//           //   child: Text(
//           //     'Qiblah Locator',
//           //     style: TextStyle(
//           //       color: Colors.white,
//           //       fontSize: screenHeight * 0.035,
//           //       fontWeight: FontWeight.bold,
//           //       fontFamily: popinsBold,
//           //     ),
//           //   ),
//           // ),
//           StreamBuilder(
//             stream: FlutterQiblah.qiblahStream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Positioned(
//                   bottom: screenHeight * 0.2,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     alignment: Alignment.center,
//                     child: const CircularProgressIndicator(
//                       color: Color(0xFF006367),
//                     ),
//                   ),
//                 );
//               }

//               if (snapshot.hasData) {
//                 final qiblahDirection = snapshot.data!;
//                 controller.updateQiblahDirection(qiblahDirection.qiblah);

//                 // Calculate the offset from the Qiblah direction
//                 var offsetAngle =
//                     (qiblahDirection.direction - qiblahDirection.qiblah) % 360;
//                 if (offsetAngle < 0) offsetAngle += 360;

//                 bool isAligned =
//                     offsetAngle < 5 || offsetAngle > 355; // Alignment tolerance

//                 // Calculate rotation angle in radians
//                 double rotationAngle = qiblahDirection.direction * (pi / 180);

//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: screenHeight * 0.12),
//                       // Qiblah Compass Rotation in Real-Time
//                       Center(
//                         child: Transform.rotate(
//                           angle: rotationAngle,
//                           child: Image.asset(
//                             updatedCompase,
//                             fit: BoxFit.cover,
//                             height: screenHeight * 0.3,
//                             width: screenWidth * 0.5,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "Qiblah Direction: ${qiblahDirection.qiblah.toStringAsFixed(0)}°",
//                         style: TextStyle(
//                           fontSize: screenHeight * 0.02,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: popinsRegulr,
//                           color: Colors.black,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       // // Offset Angle and Real-Time Instructions
//                       // Text(
//                       //   isAligned
//                       //       ? "Aligned with Qiblah"
//                       //       : "Rotate device by ${offsetAngle.toStringAsFixed(1)}° to align with Qiblah",
//                       //   style: TextStyle(
//                       //     fontSize: screenHeight * 0.02,
//                       //     fontWeight: FontWeight.bold,
//                       //     fontFamily: popinsRegulr,
//                       //     color: isAligned ? Colors.green : Colors.red,
//                       //   ),
//                       // ),
//                       // SizedBox(height: 20),
//                       // Container(
//                       //   width: double.infinity,
//                       //   height: 40,
//                       //   color: primaryColor,
//                       //   child: const Padding(
//                       //     padding: EdgeInsets.all(4.0),
//                       //     child: Text(
//                       //       'Theme',
//                       //       style: TextStyle(
//                       //         color: Colors.white,
//                       //         fontSize: 20,
//                       //         fontWeight: FontWeight.bold,
//                       //         fontFamily: popinsBold,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       // SingleChildScrollView(
//                       //   scrollDirection: Axis.horizontal,
//                       //   child: Row(
//                       //     children: List.generate(
//                       //       imageOptions.length,
//                       //       (index) => GestureDetector(
//                       //         onTap: () {
//                       //           controller.selectedImage.value =
//                       //               imageOptions[index];
//                       //         },
//                       //         child: Padding(
//                       //           padding: const EdgeInsets.all(8.0),
//                       //           child: Card(
//                       //             shape: RoundedRectangleBorder(
//                       //               borderRadius: BorderRadius.circular(10),
//                       //               side: BorderSide(
//                       //                   width: 5, color: Color(0xFF006367)),
//                       //             ),
//                       //             color: Colors.white,
//                       //             child: Padding(
//                       //               padding: const EdgeInsets.all(4.0),
//                       //               child: Image.asset(
//                       //                 imageOptions[index],
//                       //                 height: screenHeight * 0.08,
//                       //                 width: screenWidth * 0.16,
//                       //               ),
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Positioned(
//                   bottom: screenHeight * 0.5,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     alignment: Alignment.center,
//                     child: const Text(
//                       "Unable to get Qiblah direction,\n       Please restart the app",
//                     ),
//                   ),
//                 );
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
