import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/allEvents.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/home_events_model.dart';

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
    return Padding(
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (eventsController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        final events = eventsController.events.value?.data.events ?? [];
        if (events.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: lightColor,
            ),
          );
        }

        return _buildEventsContent(events);
      }),
    );
  }

  Widget _buildEventsContent(List<Event> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 5),
          SizedBox(
            height: 185,
            child: Column(
              children: [
                _buildCarousel(events),
                const SizedBox(height: 5),
                _buildCarouselIndicators(events.length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Events',
          style: TextStyle(
            fontFamily: popinsBold,
            color: whiteColor,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => AllEventsDatesScreen()),
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
    );
  }

  Widget _buildCarousel(List<Event> events) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        height: 169,
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
                eventType: event.eventhastype.eventtypeName,
                imageLink: event.eventImage,
                locatinV: event.eventLink,
              )),
        );
      },
    );
  }

  Widget _buildEventCard({
    required String imageUrl,
    required String eventDate,
    required String eventDetail,
    required VoidCallback onTapDetails,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        width: 287,
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
                    primaryColor.withOpacity(.6), // Dark overlay
                    Colors.transparent, // Transparent at the bottom
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Event Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventDate(eventDate),
                  const SizedBox(height: 5),
                  Text(
                    eventDetail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTapDetails,
                    child: Card(
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontFamily: popinsRegulr,
                            fontSize: 12,
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

  Widget _buildEventDate(String eventDate) {
    return Row(
      children: [
        Image.asset(
          eventIcon,
          height: 14,
          width: 14,
        ),
        const SizedBox(width: 10),
        Text(
          AppClass().formatDate2(eventDate),
          style: const TextStyle(
            fontSize: 10,
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
