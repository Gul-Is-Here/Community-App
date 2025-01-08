import 'dart:math';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

import '../../constants/color.dart';
import '../../constants/image_constants.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/qibla_controller.dart';

class QiblahScreen extends StatelessWidget {
  final bool isNavigation;
  QiblahScreen({super.key, required this.isNavigation});

  final QiblahController controller = Get.put(QiblahController());
  final homeController = Get.find<HomeController>();
  final loginController = Get.put(LoginController());

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: primaryColor,
            title: Text(
              "Exit App",
              style: TextStyle(fontFamily: popinsSemiBold, color: whiteColor),
            ),
            content: Text(
              "Are you sure you want to quit the app?",
              style: TextStyle(fontFamily: popinsMedium, color: whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the app
                child: Text(
                  "No",
                  style: TextStyle(fontFamily: popinsMedium, color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Exit the app
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontFamily: popinsMedium, color: secondaryColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: isNavigation
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: whiteColor,
                  ),
                )
              : SizedBox(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Qibla Direction',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              color: whiteColor,
              fontSize: screenHeight * 0.022,
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        body: StreamBuilder(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              );
            }

            if (snapshot.hasData) {
              final qiblahDirection = snapshot.data!;
              controller.updateQiblahDirection(qiblahDirection.qiblah);

              return Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      width: 234,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF01823D), Color(0xFF01823D)],
                              begin: Alignment.center,
                              end: Alignment.center),
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: Color(0xFF18423F))),
                      child: Text(
                        'Compass',
                        style: TextStyle(
                          fontFamily: popinsSemiBold,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildInfoCard(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          label: 'Your angle to Qibla',
                          value:
                              '${(qiblahDirection.qiblah % 360).toStringAsFixed(0)}°',
                        ),
                        buildInfoCard(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          label: 'Qibla angle from N',
                          value:
                              '${(qiblahDirection.direction % 360).toStringAsFixed(0)}°',
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          qiblaCircle,
                          height: 230,
                          width: 229,
                          fit: BoxFit.cover,
                        ),
                        Transform.rotate(
                          angle: (qiblahDirection.direction * (pi / 180) * -1),
                          child: Image.asset(
                            qiblaCompass,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Transform.rotate(
                          angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                          child: Transform.translate(
                            offset: const Offset(0, -130),
                            child: Image.asset(
                              kabba,
                              height: 34,
                              width: 34,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "${(qiblahDirection.direction % 360).toStringAsFixed(0)}°",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: popinsMedium,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Qibla angle :${(qiblahDirection.direction % 360).toStringAsFixed(0)}°",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: popinsRegulr,
                        color: whiteColor,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      compassBg,
                      width: screenWidth,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 60,
                    ),
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
      height: 67,
      width: 162,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: primaryColor,
        border: Border.all(color: lightColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: screenHeight * 0.025,
              color: lightColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 10,
              color: lightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:get/get.dart';

// import '../../constants/color.dart';
// import '../../constants/image_constants.dart';
// import '../../controllers/qibla_controller.dart';

// class QiblahScreen extends StatelessWidget {
//   QiblahScreen({super.key});

//   final QiblahController controller = Get.put(QiblahController());

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: primaryColor,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           'Qibla Direction',
//           style: TextStyle(
//             fontFamily: 'popinsSemiBold',
//             color: Colors.black,
//             fontSize: screenHeight * 0.022,
//           ),
//         ),
//         automaticallyImplyLeading: true,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: StreamBuilder(
//         stream: FlutterQiblah.qiblahStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: const Color(0xFF006367),
//               ),
//             );
//           }

//           if (snapshot.hasData) {
//             final qiblahDirection = snapshot.data!;
//             controller.updateQiblahDirection(qiblahDirection.qiblah);

//             // Angle to rotate the Kaaba relative to the device
//             double kaabaRotationAngle = qiblahDirection.qiblah * (pi / 180);

//             // Compass stays fixed, North aligns to device's magnetic north
//             double compassRotationAngle =
//                 qiblahDirection.direction * (pi / 180) * -1;

//             return Center(
//               child: Column(
//                 children: [
//                   SizedBox(height: screenHeight * 0.05),
//                   Text(
//                     "Point your phone towards the Kaaba direction",
//                     style: TextStyle(
//                       fontSize: screenHeight * 0.018,
//                       fontFamily: 'popinsRegular',
//                       color: Colors.black54,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       buildInfoCard(
//                         screenWidth: screenWidth,
//                         screenHeight: screenHeight,
//                         label: 'Your angle to Qibla',
//                         value: '${qiblahDirection.qiblah.toStringAsFixed(0)}°',
//                       ),
//                       buildInfoCard(
//                         screenWidth: screenWidth,
//                         screenHeight: screenHeight,
//                         label: 'Qibla angle from N',
//                         value:
//                             '${qiblahDirection.direction.toStringAsFixed(0)}°',
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.03),
//                   Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             colors: [Colors.black, Colors.black])),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       alignment: Alignment.center,
//                       children: [
//                         // Fixed Circular Line
//                         Image.asset(
//                           qiblaCircle,
//                           height: 230,
//                           width: 229,
//                           fit: BoxFit.cover,
//                         ),
//                         // Rotating Cardinal Compass Inside the Circle
//                         Transform.rotate(
//                           angle:
//                               compassRotationAngle, // Rotate based on magnetic north
//                           child: Image.asset(
//                             qiblaCompass, // Compass asset with N, S, E, W directions
//                             height: 200,
//                             width: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),

//                         // Rotating Kaaba Icon Around the Edge of the Circle
//                         Transform.rotate(
//                           angle:
//                               kaabaRotationAngle, // Rotation angle based on Qibla direction
//                           child: Transform.translate(
//                             offset: Offset(0,
//                                 -115), // Offset to place the icon on the edge
//                             child: Image.asset(
//                               kabba, // Kaaba icon
//                               height: 34,
//                               width: 34,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.05),
//                   SizedBox(height: screenHeight * 0.03),
//                   Text(
//                     "Qibla angle: ${qiblahDirection.qiblah.toStringAsFixed(0)}°",
//                     style: TextStyle(
//                       fontSize: screenHeight * 0.02,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'popinsRegular',
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: Text(
//                 "Unable to get Qiblah direction,\nPlease restart the app",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.black),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget buildInfoCard({
//     required double screenWidth,
//     required double screenHeight,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(screenWidth * 0.03),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             spreadRadius: 3,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontFamily: 'popinsSemiBold',
//               fontSize: screenHeight * 0.025,
//               color: primaryColor,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: 'popinsRegular',
//               fontSize: screenHeight * 0.015,
//               color: Colors.black54,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
