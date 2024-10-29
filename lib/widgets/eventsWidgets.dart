import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen_all.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_screen.dart';
import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

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
                        ), // Loading indicator
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
                    Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 90,
                          width: 106,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: eventsController
                                .events.value!.data.events.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var eventData =
                                  eventsController.events.value!.data;
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => EventsDetailsScreen(
                                      eventDate: eventData
                                          .events[index].eventDate
                                          .toString(),
                                      eventDetails:
                                          eventData.events[index].eventDetail,
                                      eventLink:
                                          eventData.events[index].eventLink));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Image.network(
                                    eventsController.feedsList[index].feedImage,
                                    width: 106,
                                    height: 133,
                                  ),
                                  // child: Container(
                                  //   width: 320,
                                  //   height: 90,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(30),
                                  //           topRight: Radius.circular(30),
                                  //           bottomLeft: Radius.circular(30),
                                  //           bottomRight: Radius.circular(30)),
                                  //       border: Border.all(
                                  //           width: 2, color: secondaryColor)),
                                  //   child: Card(
                                  //     margin: const EdgeInsets.all(0),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(30),
                                  //     ),
                                  //     elevation: 10,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(30),
                                  //         color: whiteColor,
                                  //         // image: DecorationImage(
                                  //         //   fit: BoxFit.contain,
                                  //         //   image: AssetImage(bannerList[index]),
                                  //         // ),
                                  //       ),
                                  //       child: Row(
                                  //         children: [
                                  //           Expanded(
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 16,
                                  //                 vertical: 8,
                                  //               ),
                                  //               child: Column(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     height: 21,
                                  //                     width: 64,
                                  //                     child: Card(
                                  //                       color: secondaryColor,
                                  //                       margin:
                                  //                           const EdgeInsets.all(0),
                                  //                       child: Center(
                                  //                         child: Text(
                                  //                           textAlign:
                                  //                               TextAlign.center,
                                  //                           "Events",
                                  //                           style: TextStyle(
                                  //                               color: whiteColor,
                                  //                               fontSize: 10,
                                  //                               fontFamily:
                                  //                                   popinsRegulr),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   Obx(() {
                                  //                     if (homeController.prayerTime
                                  //                             .value.data !=
                                  //                         null) {
                                  //                       final formattedDate =
                                  //                           eventsController
                                  //                               .formatDateString(
                                  //                                   eventData
                                  //                                       .events[index]
                                  //                                       .eventDate
                                  //                                       .toString());
                                  //                       return Text(
                                  //                         formattedDate,
                                  //                         style: TextStyle(
                                  //                           fontSize: 18,
                                  //                           color: secondaryColor,
                                  //                           fontFamily: popinsRegulr,
                                  //                         ),
                                  //                       );
                                  //                     } else {
                                  //                       return const Text('');
                                  //                     }
                                  //                   }),
                                  //                   Center(
                                  //                     child: Text(
                                  //                       eventData.events[index]
                                  //                           .eventDetail,
                                  //                       maxLines: 1,
                                  //                       style: TextStyle(
                                  //                           color: secondaryColor,
                                  //                           fontFamily: popinsRegulr,
                                  //                           fontSize: 14),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           // SizedBox(
                                  //           //   height: 100,
                                  //           //   width: 60,
                                  //           //   child: Card(
                                  //           //       margin: const EdgeInsets.all(0),
                                  //           //       shape: const RoundedRectangleBorder(
                                  //           //         borderRadius: BorderRadius.only(
                                  //           //           topRight: Radius.circular(40),
                                  //           //           bottomRight:
                                  //           //               Radius.circular(40),
                                  //           //           topLeft: Radius.circular(40),
                                  //           //           bottomLeft: Radius.circular(40),
                                  //           //         ),
                                  //           //       ),
                                  //           //       color: primaryColor,
                                  //           //       child: IconButton(
                                  //           //           onPressed: () {
                                  //           //             AppClass().launchURL(eventData
                                  //           //                 .events[index].eventLink);
                                  //           //           },
                                  //           //           icon: const Icon(
                                  //           //             Icons.location_city_rounded,
                                  //           //             color: Colors.white,
                                  //           //           ))),
                                  //           // ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              );
                            },
                          ),
                        ),
                        // SizedBox(height: 5),
                        // Center(
                        //   child: SmoothPageIndicator(
                        //     controller: _pageController,
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
                        ), // Loading indicator
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
                    Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 133,
                          width: 106,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: eventsController
                                .events.value!.data.events.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var eventData =
                                  eventsController.events.value!.data;
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => EventsDetailsScreen(
                                      eventDate: eventData
                                          .events[index].eventDate
                                          .toString(),
                                      eventDetails:
                                          eventData.events[index].eventDetail,
                                      eventLink:
                                          eventData.events[index].eventLink));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Image.network(
                                    eventsController.feedsList[index].feedImage,
                                    width: 106,
                                    height: 133,
                                  ),
                                  // child: Container(
                                  //   width: 320,
                                  //   height: 90,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(30),
                                  //           topRight: Radius.circular(30),
                                  //           bottomLeft: Radius.circular(30),
                                  //           bottomRight: Radius.circular(30)),
                                  //       border: Border.all(
                                  //           width: 2, color: secondaryColor)),
                                  //   child: Card(
                                  //     margin: const EdgeInsets.all(0),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(30),
                                  //     ),
                                  //     elevation: 10,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(30),
                                  //         color: whiteColor,
                                  //         // image: DecorationImage(
                                  //         //   fit: BoxFit.contain,
                                  //         //   image: AssetImage(bannerList[index]),
                                  //         // ),
                                  //       ),
                                  //       child: Row(
                                  //         children: [
                                  //           Expanded(
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 16,
                                  //                 vertical: 8,
                                  //               ),
                                  //               child: Column(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   SizedBox(
                                  //                     height: 21,
                                  //                     width: 64,
                                  //                     child: Card(
                                  //                       color: secondaryColor,
                                  //                       margin:
                                  //                           const EdgeInsets.all(0),
                                  //                       child: Center(
                                  //                         child: Text(
                                  //                           textAlign:
                                  //                               TextAlign.center,
                                  //                           "Events",
                                  //                           style: TextStyle(
                                  //                               color: whiteColor,
                                  //                               fontSize: 10,
                                  //                               fontFamily:
                                  //                                   popinsRegulr),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   Obx(() {
                                  //                     if (homeController.prayerTime
                                  //                             .value.data !=
                                  //                         null) {
                                  //                       final formattedDate =
                                  //                           eventsController
                                  //                               .formatDateString(
                                  //                                   eventData
                                  //                                       .events[index]
                                  //                                       .eventDate
                                  //                                       .toString());
                                  //                       return Text(
                                  //                         formattedDate,
                                  //                         style: TextStyle(
                                  //                           fontSize: 18,
                                  //                           color: secondaryColor,
                                  //                           fontFamily: popinsRegulr,
                                  //                         ),
                                  //                       );
                                  //                     } else {
                                  //                       return const Text('');
                                  //                     }
                                  //                   }),
                                  //                   Center(
                                  //                     child: Text(
                                  //                       eventData.events[index]
                                  //                           .eventDetail,
                                  //                       maxLines: 1,
                                  //                       style: TextStyle(
                                  //                           color: secondaryColor,
                                  //                           fontFamily: popinsRegulr,
                                  //                           fontSize: 14),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           // SizedBox(
                                  //           //   height: 100,
                                  //           //   width: 60,
                                  //           //   child: Card(
                                  //           //       margin: const EdgeInsets.all(0),
                                  //           //       shape: const RoundedRectangleBorder(
                                  //           //         borderRadius: BorderRadius.only(
                                  //           //           topRight: Radius.circular(40),
                                  //           //           bottomRight:
                                  //           //               Radius.circular(40),
                                  //           //           topLeft: Radius.circular(40),
                                  //           //           bottomLeft: Radius.circular(40),
                                  //           //         ),
                                  //           //       ),
                                  //           //       color: primaryColor,
                                  //           //       child: IconButton(
                                  //           //           onPressed: () {
                                  //           //             AppClass().launchURL(eventData
                                  //           //                 .events[index].eventLink);
                                  //           //           },
                                  //           //           icon: const Icon(
                                  //           //             Icons.location_city_rounded,
                                  //           //             color: Colors.white,
                                  //           //           ))),
                                  //           // ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              );
                            },
                          ),
                        ),
                        // SizedBox(height: 5),
                        // Center(
                        //   child: SmoothPageIndicator(
                        //     controller: _pageController,
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
                ],
              ),
            ),
          );
  }
}
