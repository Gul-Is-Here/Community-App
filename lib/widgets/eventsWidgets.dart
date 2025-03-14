import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/allEvents.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:community_islamic_app/widgets/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/home_events_model.dart';
import '../views/azan_settings/events_notification_settinons.dart';

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
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Obx(() {
        if (eventsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        final events = eventsController.events.value?.data.events ?? [];
        if (events.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: lightColor),
          );
        }

        return _buildEventsContent(events, screenWidth, screenHeight);
      }),
    );
  }

  Widget _buildEventsContent(
      List<Event> events, double screenWidth, double screenHeight) {
    return Padding(
      padding:
          EdgeInsets.only(left: screenWidth * 0.03, top: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(screenWidth),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: screenHeight * 0.22, // Scales based on screen height
            child: Column(
              children: [
                _buildCarousel(events, screenWidth),
                SizedBox(height: screenHeight * 0.008),
                _buildCarouselIndicators(events.length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MyText(
              'EVENTS',
              style: TextStyle(
                fontFamily: popinsBold,
                color: whiteColor,
                fontSize: screenWidth * 0.045, // Scales text size dynamically
              ),
            ),
            SizedBox(width: screenWidth * 0.01),
          ],
        ),
        GestureDetector(
          onTap: () => Get.to(() => AllEventsDatesScreen()),
          child: MyText(
            'View All',
            style: TextStyle(
              fontFamily: popinsRegulr,
              color: whiteColor,
              fontSize: screenWidth * 0.03, // Responsive text size
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(List<Event> events, double screenWidth) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        height: screenWidth * 0.4, // Adjust height based on screen width
        viewportFraction: 0.8,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {
          eventsController.updateSelectedIndex(index);
        },
      ),
      itemCount: events.length,
      itemBuilder: (context, index, realIndex) {
        final event = events[index];
        return _buildEventCard(
          imageUrl: event.eventImage,
          eventDate: event.eventDate.toString(),
          eventDetail: event.eventTitle,
          onTapDetails: () => Get.to(() => EventDetailPage(
                resType: event.resType,
                resUrl: event.resUrl,
                eventId: event.eventId,
                eventVenue: event.venueName,
                title: event.eventTitle,
                sTime: event.eventStarttime,
                endTime: event.eventEndtime,
                entry: event.paid == '0'
                    ? 'Free Event'
                    : event.paid == '1'
                        ? 'Paid Event'
                        : '',
                eventDate: event.eventDate.toString(),
                eventDetails: event.eventDetail,
                eventType: event.eventhastype!.eventtypeName,
                imageLink: event.eventImage,
                locatinV: event.eventLink,
              )),
          screenWidth: screenWidth,
        );
      },
    );
  }

  Widget _buildEventCard({
    required String imageUrl,
    required String eventDate,
    required String eventDetail,
    required VoidCallback onTapDetails,
    required double screenWidth,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 5),
      child: Container(
        width: screenWidth * 0.7, // Scales proportionally
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Event Details
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventDate(eventDate, screenWidth),
                  SizedBox(height: screenWidth * 0.015),
                  MyText(
                    eventDetail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive text
                      color: Colors.white,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onTapDetails,
                    child: Card(
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: MyText(
                          'Details',
                          style: TextStyle(
                            fontFamily: popinsRegulr,
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                          ),
                        ),
                      ),
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

  Widget _buildEventDate(String eventDate, double screenWidth) {
    return Row(
      children: [
        Image.asset(
          eventIcon,
          height: screenWidth * 0.035,
          width: screenWidth * 0.035,
        ),
        SizedBox(width: screenWidth * 0.02),
        MyText(
          AppClass().formatDate2(eventDate),
          style: TextStyle(
            fontSize: screenWidth * 0.03, // Responsive text
            color: Colors.white,
            fontFamily: popinsRegulr,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicators(int itemCount) {
    return Obx(() {
      final currentIndex = eventsController.selectedIndex.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
          (index) => Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex ? whiteColor : Colors.grey,
            ),
          ),
        ),
      );
    });
  }
}
