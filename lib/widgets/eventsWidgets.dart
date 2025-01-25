import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_classes/app_class.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_events_controller.dart';
import '../views/home_screens/EventsAndannouncements/allEvents.dart';
import '../views/home_screens/EventsAndannouncements/events_details_screen.dart';

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
      padding: const EdgeInsets.all(0),
      child: Obx(
        () {
          // Display loading indicator while data is being fetched
          if (eventsController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor, // Add primary color to the loader
              ),
            );
          }

          // Show events or fallback design if no data is available
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eventsController.events.value?.data.events.isEmpty ?? true
                  ? _buildFallbackEvents()
                  : _buildDynamicEvents(),
            ],
          );
        },
      ),
    );
  }

  // Builds the fallback design when no events are available
  Widget _buildFallbackEvents() {
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

    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 5),
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 169,
            initialPage: 0,
          ),
          itemCount: placeholderData.length,
          itemBuilder: (context, index, realIndex) {
            final item = placeholderData[index];
            return _buildEventCard(
              imageUrl: item["imageUrl"]!,
              eventDate: item["eventDate"]!,
              eventDetail: item["eventDetail"]!,
              onTapDetails: () => Get.to(() => AllEventsDatesScreen()),
            );
          },
        ),
        const SizedBox(height: 5),
        _buildCarouselIndicators(placeholderData.length, 0),
      ],
    );
  }

  // Builds the dynamic events UI when events are available
  Widget _buildDynamicEvents() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 5),
          SizedBox(
            height: 185,
            child: Column(
              children: [
                Obx(() {
                  final events =
                      eventsController.events.value?.data.events ?? [];
                  if (events.isEmpty) {
                    return const Center(child: Text("No Events Available"));
                  }
                  return CarouselSlider.builder(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      height: 169,
                      viewportFraction: 0.8,
                      enlargeCenterPage:
                          false, // Disable enlarging for smoothness
                      onPageChanged: (index, reason) {
                        // Update selected index only when necessary
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
                }),
                const SizedBox(height: 5),
                Obx(() {
                  final events =
                      eventsController.events.value?.data.events ?? [];
                  if (events.isEmpty) return Container();
                  return _buildCarouselIndicators(
                    events.length,
                    eventsController.selectedIndex.value,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the header with "Events" and "View All" text
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Events',
          style: TextStyle(
              fontFamily: popinsBold, color: whiteColor, fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Get.to(() => AllEventsDatesScreen()),
          child: Text(
            'View All',
            style: TextStyle(
                fontFamily: popinsRegulr, color: whiteColor, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Builds a single event card
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
          image: DecorationImage(
            image: imageUrl.startsWith('http')
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventDate(eventDate),
              const SizedBox(height: 5),
              Text(
                eventDetail,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: popinsSemiBold,
                ),
                maxLines: 2,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTapDetails,
                child: Card(
                  color: whiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
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
      ),
    );
  }

  // Builds the event date row
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

  // Builds carousel indicators
  Widget _buildCarouselIndicators(int itemCount, int currentIndex) {
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
  }
}
