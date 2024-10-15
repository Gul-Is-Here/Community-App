import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app_classes/app_class.dart';
import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({
    super.key,
    required this.eventsController,
    required this.homeController,
  });

  final HomeEventsController eventsController;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();

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
            else if (eventsController.events.value == null ||
                eventsController.events.value!.data.events.isEmpty)
              const SizedBox(
                height: 100,
                width: 320,
                child: Center(
                  child: Text(
                    'No Events found',
                    style: TextStyle(fontFamily: popinsRegulr),
                  ),
                ),
              )
            else if (eventsController.events.value != null &&
                eventsController.events.value!.data.events.isNotEmpty)
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 90,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount:
                          eventsController.events.value!.data.events.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var eventData = eventsController.events.value!.data;
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => EventsDetailsScreen(
                                eventDate: eventData.events[index].eventDate
                                    .toString(),
                                eventDetails:
                                    eventData.events[index].eventDetail,
                                eventLink: eventData.events[index].eventLink));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: primaryColor,
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
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
                                              Center(
                                                child: Text(
                                                  eventData.events[index]
                                                      .eventDetail,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: popinsSemiBold,
                                                  ),
                                                ),
                                              ),
                                              Obx(() {
                                                if (homeController.prayerTime
                                                        .value.data !=
                                                    null) {
                                                  final formattedDate =
                                                      eventsController
                                                          .formatDateString(
                                                              eventData
                                                                  .events[index]
                                                                  .eventDate
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
                                                bottomRight:
                                                    Radius.circular(40),
                                                topLeft: Radius.circular(40),
                                                bottomLeft: Radius.circular(40),
                                              ),
                                            ),
                                            color: primaryColor,
                                            child: IconButton(
                                                onPressed: () {
                                                  AppClass().launchURL(eventData
                                                      .events[index].eventLink);
                                                },
                                                icon: const Icon(
                                                  Icons.location_city_rounded,
                                                  color: Colors.white,
                                                ))),
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
                  SizedBox(height: 5),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
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
                Get.to(() => EventsScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'View Events & Activities',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
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
