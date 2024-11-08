import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
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

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eventsController.isLoading.value)
              SizedBox(
                width: screenWidth,
                height: screenHeight1 * .075,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: primaryColor,
                    size: 50.0,
                  ),
                ),
              )
            else if (eventsController.events.value == null ||
                eventsController.events.value!.data.events.isEmpty)
              SizedBox(
                width: screenWidth * .9,
                height: screenHeight1 * .075,
                child: Center(
                  child: Text(
                    'No Events found',
                    style: TextStyle(fontFamily: popinsRegulr),
                  ),
                ),
              )
            else
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: ,
                      children: List.generate(
                        eventsController.events.value!.data.events.length,
                        (index) {
                          var eventData = eventsController.events.value!.data;
                          final feedsImages = bannerList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => EventsDetailsScreen(
                                  imageUrl: feedsImages,
                                  eventDate: eventData.events[index].eventDate
                                      .toString(),
                                  eventDetails:
                                      eventData.events[index].eventDetail,
                                  eventLink:
                                      eventData.events[index].eventLink));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Container(
                                width: screenWidth * .9,
                                height: 89,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  image: DecorationImage(
                                    image: AssetImage(eventBg2),
                                    opacity: .8,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 4),
                                            child: Text(
                                              "Event",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: popinsBold,
                                              ),
                                            ),
                                          ),
                                          5.heightBox,
                                          Text(
                                            AppClass().formatDate2(eventData
                                                .events[index].eventDate
                                                .toString()),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: popinsSemiBold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            width: screenWidth * .6,
                                            child: Text(
                                              maxLines: 1,

                                              eventData
                                                  .events[index].eventDetail,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: popinsSemiBold,
                                              ),
                                              // maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      height: double.infinity,
                                      width: 60,
                                      decoration: const BoxDecoration(
                                          // color: primaryColor,
                                          gradient: LinearGradient(colors: [
                                            Color(0xFF042838),
                                            Color(0xFF0F6467)
                                          ]),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                              topRight: Radius.circular(
                                                30,
                                              ),
                                              bottomRight:
                                                  Radius.circular(30))),
                                      child: Image.asset(
                                        locationIcon,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  5.heightBox,
                  SizedBox(
                    height: 35,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AllEventsDatesScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}





///class EventsWidget extends StatelessWidget {
//   const EventsWidget({
//     super.key,
//     required this.eventsController,
//     required this.homeController,
//   });

//   final HomeEventsController eventsController;
//   final HomeController homeController;

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight1 = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Obx(
//         () => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (eventsController.isLoading.value)
//               SizedBox(
//                 width: screenWidth * 1,
//                 height: screenHeight1 * .075,
//                 child: Center(
//                   child: SpinKitFadingCircle(
//                     color: primaryColor,
//                     size: 50.0,
//                   ),
//                 ),
//               )
//             else if (eventsController.events.value == null ||
//                 eventsController.events.value!.data.events.isEmpty)
//               SizedBox(
//                 width: screenWidth * .9,
//                 height: screenHeight1 * .075,
//                 child: Center(
//                   child: Text(
//                     'No Events found',
//                     style: TextStyle(fontFamily: popinsRegulr),
//                   ),
//                 ),
//               )
//             else
//               Column(
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(
//                         eventsController.events.value!.data.events.length,
//                         (index) {
//                           var eventData = eventsController.events.value!.data;
//                           final feedsImages = eventsController.feedsList[index];
//                           return GestureDetector(
//                             onTap: () {
//                               Get.to(() => EventsDetailsScreen(
//                                   imageUrl: feedsImages.feedImage,
//                                   eventDate: eventData.events[index].eventDate
//                                       .toString(),
//                                   eventDetails:
//                                       eventData.events[index].eventDetail,
//                                   eventLink:
//                                       eventData.events[index].eventLink));
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 4, vertical: 5),
//                               child: Image.network(
//                                 eventsController.feedsList[index].feedImage,
//                                 fit: BoxFit.cover,
//                                 width: 90,
//                                 height: 120,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   5.heightBox,
//                   SizedBox(
//                     height: 35,
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.to(() => AllEventsDatesScreen());
//                       },
//                       child: Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment.end, // Aligns to the right
//                         children: [
//                           Text(
//                             'View All',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: primaryColor,
//                               fontFamily: popinsRegulr,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: primaryColor,
//                             ),
//                             child: Icon(
//                               Icons.arrow_forward,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
