import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen_all.dart';
import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../views/home_screens/EventsAndannouncements/announcements_details_screen.dart';
import '../views/home_screens/EventsAndannouncements/announcements_screen.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget({
    super.key,
    required this.eventsController,
    required this.homeController,
  });

  final HomeEventsController eventsController;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Create a PageController
    PageController pageController = PageController();

    return screenWidth < 400 || screenHeight1 < 850
        ? Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (eventsController.isLoading.value)
                        SizedBox(
                          height: 50,
                          width: 320,
                          child: Center(
                            child: SpinKitFadingCircle(
                              color: primaryColor,
                              size: 50.0,
                            ), // Loading indicator
                          ),
                        )
                      else if (eventsController.alertsList.isEmpty)
                        const SizedBox(
                          height: 50,
                          width: 320,
                          child: Center(
                            child: Text(
                              'No Alerts found',
                              style: TextStyle(fontFamily: popinsRegulr),
                            ),
                          ),
                        ),
                      if (eventsController.events.value != null &&
                          eventsController.events.value!.data.events.isNotEmpty)
                        Column(
                          children: [
                            Container(
                              color: whiteColor,
                              height: 60,
                              child: PageView.builder(
                                controller:
                                    pageController, // Assign the PageController
                                itemCount: eventsController.alertsList.length,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index) {
                                  eventsController.currentIndex.value =
                                      index; // Update current index
                                },
                                itemBuilder: (context, index) {
                                  var alertsData =
                                      eventsController.alertsList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => AnnouncementsDetailsScreen(
                                            alertDisc:
                                                alertsData.alertDescription,
                                            controller: eventsController,
                                            title: alertsData.alertTitle,
                                            details:
                                                alertsData.alertDescription,
                                            createdDate:
                                                alertsData.createdAt.toString(),
                                            description: '',
                                            postedDate: alertsData.updatedAt
                                                .toString()));
                                      },
                                      child: Container(
                                        width: 320,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Card(
                                          margin: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              ),
                                              color: whiteColor,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 5,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 21,
                                                          width: 64,
                                                          child: Card(
                                                            color: primaryColor,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Center(
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "Alert",
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        popinsRegulr),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        5.heightBox,
                                                        // Obx(() {
                                                        //   if (eventsController
                                                        //       .feedsList.isNotEmpty) {
                                                        //     final formattedDate =
                                                        //         eventsController
                                                        //             .formatDateString(
                                                        //                 alertsData
                                                        //                     .updatedAt
                                                        //                     .toString());
                                                        //     return Text(
                                                        //       formattedDate,
                                                        //       style: const TextStyle(
                                                        //         fontWeight:
                                                        //             FontWeight.w400,
                                                        //         fontSize: 16,
                                                        //         color: Colors.white,
                                                        //         fontFamily:
                                                        //             popinsRegulr,
                                                        //       ),
                                                        //     );
                                                        //   } else {
                                                        //     return const Text('');
                                                        //   }
                                                        // }),
                                                        Text(
                                                          alertsData.alertTitle,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                popinsRegulr,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Centered Page Indicator (uncomment if needed)
                            // Center(
                            //   child: SmoothPageIndicator(
                            //     controller: pageController,
                            //     count: eventsController.events.value!.data.events.length,
                            //     effect: ExpandingDotsEffect(
                            //       activeDotColor: primaryColor,
                            //       dotColor: Colors.grey,
                            //       dotHeight: 8,
                            //       dotWidth: 8,
                            //       expansionFactor: 3,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      5.heightBox,
                      SizedBox(
                        height: 30,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => AnnouncementsScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'View All',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: whiteColor,
                                          fontFamily: popinsRegulr,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward,
                                            color: whiteColor,
                                            size: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Remove spacing between PageView and View All Alerts
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (eventsController.isLoading.value)
                        SizedBox(
                          height: 60,
                          width: 320,
                          child: Center(
                            child: SpinKitFadingCircle(
                              color: primaryColor,
                              size: 50.0,
                            ), // Loading indicator
                          ),
                        )
                      else if (eventsController.alertsList.isEmpty)
                        const SizedBox(
                          height: 60,
                          width: 320,
                          child: Center(
                            child: Text(
                              'No Alerts found',
                              style: TextStyle(fontFamily: popinsRegulr),
                            ),
                          ),
                        ),
                      if (eventsController.events.value != null &&
                          eventsController.events.value!.data.events.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(
                              height: 70,
                              child: PageView.builder(
                                controller:
                                    pageController, // Assign the PageController
                                itemCount: eventsController.alertsList.length,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index) {
                                  eventsController.currentIndex.value =
                                      index; // Update current index
                                },
                                itemBuilder: (context, index) {
                                  var alertsData =
                                      eventsController.alertsList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => AnnouncementsDetailsScreen(
                                            alertDisc:
                                                alertsData.alertDescription,
                                            controller: eventsController,
                                            title: alertsData.alertTitle,
                                            details:
                                                alertsData.alertDescription,
                                            createdDate:
                                                alertsData.createdAt.toString(),
                                            description: '',
                                            postedDate: alertsData.updatedAt
                                                .toString()));
                                      },
                                      child: Container(
                                        width: 320,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Card(
                                          margin: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color(0xFF5B7B79),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 21,
                                                          width: 64,
                                                          child: Card(
                                                            color: const Color(
                                                                0xFFbacD9D9D9),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Center(
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "Alert",
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        popinsRegulr),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        5.heightBox,
                                                        // Obx(() {
                                                        //   if (eventsController
                                                        //       .feedsList.isNotEmpty) {
                                                        //     final formattedDate =
                                                        //         eventsController
                                                        //             .formatDateString(
                                                        //                 alertsData
                                                        //                     .updatedAt
                                                        //                     .toString());
                                                        //     return Text(
                                                        //       formattedDate,
                                                        //       style: const TextStyle(
                                                        //         fontWeight:
                                                        //             FontWeight.w400,
                                                        //         fontSize: 16,
                                                        //         color: Colors.white,
                                                        //         fontFamily:
                                                        //             popinsRegulr,
                                                        //       ),
                                                        //     );
                                                        //   } else {
                                                        //     return const Text('');
                                                        //   }
                                                        // }),
                                                        Text(
                                                          alertsData.alertTitle,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                popinsRegulr,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 90,
                                                  width: 60,
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(40),
                                                        bottomRight:
                                                            Radius.circular(40),
                                                        topLeft:
                                                            Radius.circular(40),
                                                        bottomLeft:
                                                            Radius.circular(40),
                                                      ),
                                                    ),
                                                    color: primaryColor,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Image.asset(
                                                        locationIcon,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Centered Page Indicator (uncomment if needed)
                            // Center(
                            //   child: SmoothPageIndicator(
                            //     controller: pageController,
                            //     count: eventsController.events.value!.data.events.length,
                            //     effect: ExpandingDotsEffect(
                            //       activeDotColor: primaryColor,
                            //       dotColor: Colors.grey,
                            //       dotHeight: 8,
                            //       dotWidth: 8,
                            //       expansionFactor: 3,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      5.heightBox,
                      SizedBox(
                        height: 30,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'View All',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: whiteColor,
                                          fontFamily: popinsRegulr,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward,
                                            color: whiteColor,
                                            size: 20,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Remove spacing between PageView and View All Alerts
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
