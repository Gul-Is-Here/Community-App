import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

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
    // Create a PageController
    PageController pageController = PageController();

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
                    height: 90,
                    width: 320,
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: primaryColor,
                        size: 50.0,
                      ), // Loading indicator
                    ),
                  )
                else if (eventsController.feedsList.isEmpty)
                  const SizedBox(
                    height: 117,
                    width: 320,
                    child: Center(
                      child: Text(
                        'No Feeds found',
                        style: TextStyle(fontFamily: popinsRegulr),
                      ),
                    ),
                  ),
                if (eventsController.events.value != null &&
                    eventsController.events.value!.data.events.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 90,
                        child: PageView.builder(
                          controller:
                              pageController, // Assign the PageController
                          itemCount: eventsController.feedsList.length,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            eventsController.currentIndex.value =
                                index; // Update current index
                          },
                          itemBuilder: (context, index) {
                            var feedsData = eventsController.feedsList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => AnnouncementsDetailsScreen(
                                      controller: eventsController,
                                      title: feedsData.feedTitle,
                                      image: feedsData.feedImage,
                                      createdDate:
                                          feedsData.createdAt.toString(),
                                      description: '',
                                      postedDate:
                                          feedsData.feedDate.toString()));
                                },
                                child: Container(
                                  width: 320,
                                  height: 90,
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
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF5B7B79),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
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
                                                      color: const Color(
                                                          0xFFbacD9D9D9),
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
                                                  Obx(() {
                                                    if (eventsController
                                                        .feedsList.isNotEmpty) {
                                                      final formattedDate =
                                                          eventsController
                                                              .formatDateString(
                                                                  feedsData
                                                                      .feedDate
                                                                      .toString());
                                                      return Text(
                                                        formattedDate,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              popinsRegulr,
                                                        ),
                                                      );
                                                    } else {
                                                      return const Text('');
                                                    }
                                                  }),
                                                  Text(
                                                    feedsData.feedTitle,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: popinsRegulr,
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
                                              margin: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40),
                                                  bottomRight:
                                                      Radius.circular(40),
                                                  topLeft: Radius.circular(40),
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

                SizedBox(
                  height: 20,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => AnnouncementsScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: Co,
                      children: [
                        const Text(
                          'View All Alerts',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: popinsRegulr,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 10,
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
