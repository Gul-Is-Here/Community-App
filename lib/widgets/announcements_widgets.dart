import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
          // Observing changes in the alerts list
          Obx(() {
            if (eventsController.isLoading.value) {
              // Show loading spinner while fetching data
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Announcement',
                          style: TextStyle(
                              fontFamily: popinsBold,
                              color: whiteColor,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Get.to(() => AnnouncementsScreen());
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                                fontFamily: popinsRegulr,
                                color: whiteColor,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 49,
                    width: screenWidth * 1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        // var alertsData = eventsController.alertsList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(0),
                              width: 225,
                              height: screenHeight1 * .08,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    30,
                                  ),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: lightColor,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(35),
                                      bottomLeft: Radius.circular(35),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: const Color(0xFF1E5045),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 47,
                                        width: 47,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: lightColor,
                                        ),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              '2 Mar',
                                              style: TextStyle(
                                                  fontFamily: popinsSemiBold,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 5,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 5),
                                              Text(
                                                maxLines: 2,
                                                'Announcements are coming soon',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: whiteColor,
                                                  fontFamily: popinsSemiBold,
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
                SizedBox(height: 10,),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: eventsController.selectedIndex.value == index
                                ? whiteColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (eventsController.alertsList.isEmpty) {
              // Show "Notification Coming Soon" if the list is empty
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Announcement',
                          style: TextStyle(
                              fontFamily: popinsBold,
                              color: whiteColor,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AnnouncementsScreen());
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                                fontFamily: popinsRegulr,
                                color: whiteColor,
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 49,
                    width: screenWidth * 1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        // var alertsData = eventsController.alertsList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to AnnouncementsDetailsScreen
                              // eventsController
                              //     .selectedIndexAnnouncment.value = index;
                              // Get.to(() => AnnouncementsDetailsScreen(
                              //       alertDisc: alertsData.alertDescription,
                              //       controller: eventsController,
                              //       title: alertsData.alertTitle,
                              //       details: alertsData.alertDescription,
                              //       createdDate:
                              //           alertsData.createdAt.toString(),
                              //       description: '',
                              //       postedDate:
                              //           alertsData.updatedAt.toString(),
                              //     ));
                            },
                            child: Container(
                              margin: EdgeInsets.all(0),
                              width: 225,
                              height: screenHeight1 * .08,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    30,
                                  ),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: lightColor,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(35),
                                      bottomLeft: Radius.circular(35),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: const Color(0xFF1E5045),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 47,
                                        width: 47,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: lightColor,
                                        ),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              '2 Mar',
                                              style: TextStyle(
                                                  fontFamily: popinsSemiBold,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 5,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 5),
                                              Text(
                                                maxLines: 2,
                                                'Announcemnets are coming soon',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: whiteColor,
                                                  fontFamily: popinsSemiBold,
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
                SizedBox(height: 10,),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: eventsController.selectedIndex.value == index
                                ? whiteColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Show list of alerts if available
            return Column(
              children: [
                // Header Row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Announcement',
                        style: TextStyle(
                          fontFamily: popinsBold,
                          color: whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AnnouncementsScreen());
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontFamily: popinsRegulr,
                            color: whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
         SizedBox(height: 5,),
                // Carousel Slider with dots
                Obx(() {
                  return Column(
                    children: [
                      // Carousel Slider
                      CarouselSlider.builder(
                        itemCount: eventsController.alertsList.length,
                        itemBuilder: (context, index, realIndex) {
                          var alertsData = eventsController.alertsList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to AnnouncementsDetailsScreen
                                eventsController
                                    .selectedIndexAnnouncment.value = index;
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
                                margin: EdgeInsets.all(0),
                                width: 320,
                                height: 50, // Adjusted height
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Card(
                                  margin: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 10,
                                  child: Container(
                                    margin: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: lightColor,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color(0xFF1E5045),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 47,
                                          width: 47,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: lightColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppClass().convertDate(alertsData
                                                  .createdAt
                                                  .toString()),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: popinsSemiBold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 5),
                                                Text(
                                                  alertsData.alertTitle,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: whiteColor,
                                                    fontFamily: popinsSemiBold,
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
                        options: CarouselOptions(
                          height: 50, // Adjust height as needed
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          enlargeCenterPage: true,
                          viewportFraction: 1,

                          onPageChanged: (index, reason) {
                            eventsController.selectedIndex.value = index;
                          },
                        ),
                      ),

                      // Indicator Dots
                    SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          eventsController.alertsList.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  eventsController.selectedIndex.value == index
                                      ? whiteColor
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              SizedBox(height: 10,),
              ],
            );
          })
        ],
      ),
    );
  }
}
