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

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eventsController.isLoading.value)
                  SizedBox(
                    width: screenWidth * .7,
                    height: screenHeight1 * .075,
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: primaryColor,
                        size: 50.0,
                      ),
                    ),
                  )
                else if (eventsController.alertsList.isEmpty)
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'No Alerts found',
                        style: TextStyle(fontFamily: popinsRegulr),
                      ),
                    ),
                  )
                else // If alerts exist, display them
                  Column(
                    children: [
                      Container(
                        color: whiteColor,
                        height: 60,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: eventsController.alertsList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var alertsData = eventsController.alertsList[index];
                            print('Alert List: ${alertsData.alertTitle}');
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => AnnouncementsDetailsScreen(
                                        alertDisc: alertsData.alertDescription,
                                        controller: eventsController,
                                        title: alertsData.alertTitle,
                                        details: alertsData.alertDescription,
                                        createdDate:
                                            alertsData.createdAt.toString(),
                                        description: '',
                                        postedDate:
                                            alertsData.updatedAt.toString(),
                                      ));
                                },
                                child: Container(
                                  width: screenWidth * .8,
                                  height: screenHeight1 * .075,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Card(
                                    margin: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: primaryColor),
                                        borderRadius: BorderRadius.circular(30),
                                        color: whiteColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 5,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 21,
                                                    width: 64,
                                                    child: Card(
                                                      color: primaryColor,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: Center(
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          "Alert",
                                                          style: TextStyle(
                                                              color: whiteColor,
                                                              fontSize: 10,
                                                              fontFamily:
                                                                  popinsRegulr),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    alertsData.alertTitle,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: popinsRegulr,
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
                      5.heightBox,
                      SizedBox(
                        height: 35,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => AnnouncementsScreen());
                          },
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // Aligns to the right
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontFamily: popinsRegulr,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
