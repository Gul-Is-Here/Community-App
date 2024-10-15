// Announcment Widget
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
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
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eventsController.isLoading.value)
              SizedBox(
                height: 100,
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
                height: 100,
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
                      controller: pageController, // Assign the PageController
                      itemCount: eventsController.feedsList.length,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index) {
                        eventsController.currentIndex.value =
                            index; // Update current index
                      },
                      itemBuilder: (context, index) {
                        var feedsData = eventsController.feedsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => AnnouncementsDetailsScreen(
                                  controller: eventsController,
                                  title: feedsData.feedTitle,
                                  image: feedsData.feedImage,
                                  createdDate: feedsData.createdAt.toString(),
                                  description: '',
                                  postedDate: feedsData.feedDate.toString()));
                            },
                            child: Container(
                              width: 320,
                              height: 100,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: primaryColor,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(bannerList[index]),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                feedsData.feedTitle,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: popinsSemiBold,
                                                ),
                                              ),
                                              Obx(() {
                                                if (eventsController
                                                    .feedsList.isNotEmpty) {
                                                  final formattedDate =
                                                      eventsController
                                                          .formatDateString(
                                                              feedsData.feedDate
                                                                  .toString());
                                                  return Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          popinsSemiBold,
                                                    ),
                                                  );
                                                } else {
                                                  return const Text('');
                                                }
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        width: 60,
                                        child: Card(
                                          margin: const EdgeInsets.all(0),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40),
                                              bottomRight: Radius.circular(40),
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40),
                                            ),
                                          ),
                                          color: primaryColor,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.location_city_rounded,
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
                  5.heightBox,
                  Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: eventsController.events.value!.data.events.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: primaryColor,
                        dotColor: Colors.grey,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {
                Get.to(() => AnnouncementsScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View Announcements',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
