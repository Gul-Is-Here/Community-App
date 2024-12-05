import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
            if (eventsController.events.value == null ||
                eventsController.events.value!.data.events.isEmpty)
              // Fallback static design
              SizedBox(
                height: 226,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Events',
                            style: TextStyle(
                                fontFamily: popinsBold,
                                color: whiteColor,
                                fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => AllEventsDatesScreen());
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
                    5.heightBox,
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        scrollPhysics: const ScrollPhysics(),
                        height: 169, // Adjust height as needed
                        //  viewportFraction:
                        // 0.8, // Adjust  this to control the visible portion of the next item
                        enableInfiniteScroll: false,
                        enlargeCenterPage:
                            false, // Disable enlarging the center page
                        scrollDirection: Axis.horizontal,
                        initialPage: 1, // Start at the first item
                      ),
                      itemCount: 3, // Number of static placeholder items
                      itemBuilder: (context, index, realIndex) {
                        // Static placeholder data
                        final placeholderData = [
                          {
                            "imageUrl": eventBg2,
                            "eventDate": "2024-01-01",
                            "eventDetail": "Event coming soon"
                          },
                          {
                            "imageUrl": eventBg2,
                            "eventDate": "2024-02-15",
                            "eventDetail": "Event coming soon"
                          },
                          {
                            "imageUrl": eventBg2,
                            "eventDate": "2024-03-20",
                            "eventDetail": "Event coming soon"
                          },
                        ];

                        final item = placeholderData[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Container(
                            width: 287,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(item['imageUrl']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 4),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              eventIcon,
                                              height: 14,
                                              width: 14,
                                            ),
                                            10.widthBox,
                                            Text(
                                              AppClass().formatDate2(
                                                  item['eventDate']!),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontFamily: popinsRegulr,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      5.heightBox,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          item['eventDetail']!,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: popinsSemiBold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => AllEventsDatesScreen());
                                        },
                                        child: Card(
                                          color: whiteColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                  fontFamily: popinsRegulr,
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3, // Number of static placeholder items
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? whiteColor // Active dot for static
                                : Colors.grey, // Inactive dot
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              // Dynamic data design
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Events',
                          style: TextStyle(
                              fontFamily: popinsBold,
                              color: whiteColor,
                              fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AllEventsDatesScreen());
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
                    5.heightBox,
                    SizedBox(
                      height: 185,
                      child: Column(
                        children: [
                          // CarouselSlider.builder with null checks for event data
                          Obx(() {
                            if (eventsController.events.value?.data.events ==
                                    null ||
                                eventsController
                                    .events.value!.data.events.isEmpty) {
                              return const Center(
                                  child: Text("No Events Available"));
                            }

                            return CarouselSlider.builder(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                height: 169,
                                viewportFraction: 1,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  eventsController.updateSelectedIndex(index);
                                },
                              ),
                              itemCount: eventsController
                                  .events.value!.data.events.length,
                              itemBuilder: (context, index, realIndex) {
                                var eventData =
                                    eventsController.events.value!.data;
                                final feedsImages = bannerList.isNotEmpty
                                    ? bannerList[index]
                                    : ''; // Null check for bannerList
                                final feedImage =
                                    eventsController.feedsList.length > index
                                        ? eventsController
                                            .feedsList[index].feedImage
                                        : null;

                                // Check if feedImage is null, use a placeholder
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Container(
                                    width: screenWidth * 1,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [Colors.black, Colors.black],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight),
                                      borderRadius: BorderRadius.circular(10),
                                      image: feedImage != null
                                          ? DecorationImage(
                                              image: NetworkImage(feedImage),
                                              opacity: .3,
                                              fit: BoxFit.cover,
                                            )
                                          : null, // Fallback if feedImage is null
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 4),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      eventIcon,
                                                      height: 14,
                                                      width: 14,
                                                    ),
                                                    10.widthBox,
                                                    Text(
                                                      AppClass().formatDate2(
                                                          eventData
                                                              .events[index]
                                                              .eventDate
                                                              .toString()),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            popinsRegulr,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              5.heightBox,
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 200,
                                                  child: Text(
                                                    eventData.events[index]
                                                        .eventDetail,
                                                    style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          popinsSemiBold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      EventsDetailsScreen(
                                                        imageUrl: feedsImages,
                                                        eventDate: eventData
                                                            .events[index]
                                                            .eventDate
                                                            .toString(),
                                                        eventDetails: eventData
                                                            .events[index]
                                                            .eventDetail,
                                                        eventLink: eventData
                                                            .events[index]
                                                            .eventLink,
                                                      ));
                                                },
                                                child: Card(
                                                  color: whiteColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Details',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              popinsRegulr,
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),

                          5.heightBox,

                          // Dot indicators for the carousel slider with null checks
                          Obx(() {
                            if (eventsController.events.value?.data.events ==
                                    null ||
                                eventsController
                                    .events.value!.data!.events.isEmpty) {
                              return Container();
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                eventsController
                                    .events.value!.data.events.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        eventsController.selectedIndex.value ==
                                                index
                                            ? whiteColor
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
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