import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/allEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
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
                    // 5.heightBox,
                    SizedBox(
                      height: 5,
                    ),
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
                                            // 10.widthBox,
                                            SizedBox(
                                              height: 10,
                                            ),
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
                                      // 5.heightBox,
                                      SizedBox(
                                        height: 5,
                                      ),
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
                    SizedBox(
                      height: 5,
                    ),
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
                    // 5.heightBox,
                    SizedBox(
                      height: 5,
                    ),
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
                                // reverse: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                height: 169,
                                viewportFraction: 0.8,
                                enableInfiniteScroll: true,
                                // enlargeCenterPage: true,
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
                                // Null check for bannerList

                                // Check if feedImage is null, use a placeholder
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Container(
                                    width: screenWidth * 1,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            colors: [
                                              Colors.black,
                                              Colors.black
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            eventData.events[index].eventImage,
                                          ),
                                          opacity: .3,
                                          fit: BoxFit.cover,
                                        )
                                        // Fallback if feedImage is null
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
                                                    // 10.widthBox,
                                                    SizedBox(
                                                      height: 10,
                                                    ),
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
                                              // 5.heightBox,
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 200,
                                                  child: Text(
                                                    eventData.events[index]
                                                        .eventTitle,
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
                                                  Get.to(() => EventDetailPage(
                                                        eventId: eventData
                                                            .events[index]
                                                            .eventId,
                                                        eventVenue: eventData
                                                            .events[index]
                                                            .venueName,
                                                        title: eventData
                                                            .events[index]
                                                            .eventTitle,
                                                        sTime: eventData
                                                            .events[index]
                                                            .eventStarttime,
                                                        endTime: eventData
                                                            .events[index]
                                                            .eventEndtime,
                                                        entry: eventData
                                                                    .events[
                                                                        index]
                                                                    .paid ==
                                                                '0'
                                                            ? 'Free Event'
                                                            : eventData
                                                                        .events[
                                                                            index]
                                                                        .paid ==
                                                                    '1'
                                                                ? 'Paid Event'
                                                                : '',
                                                        eventDate: eventData
                                                            .events[index]
                                                            .eventDate
                                                            .toString(),
                                                        eventDetails: eventData
                                                            .events[index]
                                                            .eventDetail,
                                                        eventType: eventData
                                                            .events[index]
                                                            .eventhastype
                                                            .eventtypeName,
                                                        imageLink: eventData
                                                            .events[index]
                                                            .eventImage,
                                                        locatinV: eventData
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

                          // 5.heightBox
                          SizedBox(
                            height: 5,
                          ),

                          // Dot indicators for the carousel slider with null checks
                          Obx(() {
                            if (eventsController.events.value?.data.events ==
                                    null ||
                                eventsController
                                    .events.value!.data.events.isEmpty) {
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
