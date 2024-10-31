import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/color.dart';
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
    final screenHeight1 = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return screenWidth < 400 || screenHeight1 < 850
        ? Padding(
            padding: const EdgeInsets.all(0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eventsController.isLoading.value)
                    SizedBox(
                      height: 80,
                      width: 320,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50.0,
                        ),
                      ),
                    )
                  else if (eventsController.events.value == null ||
                      eventsController.events.value!.data.events.isEmpty)
                    const SizedBox(
                      height: 80,
                      width: 320,
                      child: Center(
                        child: Text(
                          'No Events found',
                          style: TextStyle(fontFamily: popinsRegulr),
                        ),
                      ),
                    )
                  else if (eventsController.events.value != null &&
                      eventsController.feedsList.isNotEmpty &&
                      eventsController.events.value!.data.events.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          eventsController.events.value!.data.events.length,
                          (index) {
                            var eventData = eventsController.events.value!.data;
                            final feedsImages =
                                eventsController.feedsList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => EventsDetailsScreen(
                                    imageUrl: feedsImages.feedImage,
                                    eventDate: eventData.events[index].eventDate
                                        .toString(),
                                    eventDetails:
                                        eventData.events[index].eventDetail,
                                    eventLink:
                                        eventData.events[index].eventLink));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                child: Image.network(
                                  eventsController.feedsList[index].feedImage,
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 120,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  5.heightBox,
                  SizedBox(
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AllEventsDatesScreen());
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(0),
            child: Obx(
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
                        ),
                      ),
                    )
                  else if (eventsController.events.value == null ||
                      eventsController.events.value!.data.events.isEmpty)
                    const SizedBox(
                      height: 90,
                      width: 320,
                      child: Center(
                        child: Text(
                          'No Events found',
                          style: TextStyle(fontFamily: popinsRegulr),
                        ),
                      ),
                    )
                  else if (eventsController.events.value != null &&
                      eventsController.feedsList.isNotEmpty &&
                      eventsController.events.value!.data.events.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          eventsController.events.value!.data.events.length,
                          (index) {
                            var eventData = eventsController.events.value!.data;
                            final feedsImages =
                                eventsController.feedsList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => EventsDetailsScreen(
                                    imageUrl: feedsImages.feedImage,
                                    eventDate: eventData.events[index].eventDate
                                        .toString(),
                                    eventDetails:
                                        eventData.events[index].eventDetail,
                                    eventLink:
                                        eventData.events[index].eventLink));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Image.network(
                                  eventsController.feedsList[index].feedImage,
                                  width: 106,
                                  height: 133,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  5.heightBox,
                  SizedBox(
                    height: 30,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AllEventsDatesScreen());
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
