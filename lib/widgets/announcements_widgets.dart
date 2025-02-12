import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/azan_settings/events_notification_settinons.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Obx(() {
            if (eventsController.isLoading.value) {
              return _buildLoadingState();
            }

            if (eventsController.alertsList.isEmpty) {
              return _buildEmptyState();
            }

            return _buildAnnouncementsContent(screenWidth);
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Announcements are coming soon',
            style: TextStyle(
              fontSize: 16,
              color: whiteColor,
              fontFamily: popinsSemiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsContent(double screenWidth) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 5),
        _buildCarousel(screenWidth),
        const SizedBox(height: 10),
        _buildCarouselIndicators(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Announcement',
                style: TextStyle(
                  fontFamily: popinsBold,
                  color: whiteColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              // GestureDetector(
              //   onTap: () => Get.to(() => NotificationSettingsPage()),
              //   child: Image.asset(
              //     notificationICon,
              //     width: 20,
              //     height: 20,
              //   ),
              // )
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AnnouncementsScreen());
            },
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
      ),
    );
  }

  Widget _buildCarousel(double screenWidth) {
    return CarouselSlider.builder(
      itemCount: eventsController.alertsList.length,
      itemBuilder: (context, index, realIndex) {
        final alert = eventsController.alertsList[index];
        return _buildAnnouncementCard(alert);
      },
      options: CarouselOptions(
        height: screenWidth * 0.26,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          eventsController.selectedIndex.value = index;
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(dynamic alert) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          eventsController.selectedIndexAnnouncment.value =
              eventsController.alertsList.indexOf(alert);
          Get.to(() => AnnouncementsDetailsScreen(
                alertDisc: alert.alertDescription,
                controller: eventsController,
                title: alert.alertTitle,
                details: alert.alertDescription,
                createdDate: alert.createdAt.toString(),
                description: '',
                postedDate: alert.updatedAt.toString(),
              ));
        },
        child: Card(
          color: Colors.transparent,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Background Container with Gradient
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF032727),
                  borderRadius: BorderRadius.circular(10),
                  // gradient: LinearGradient(
                  //   colors: [
                  //     primaryColor
                  //         .withOpacity(0.8), // Primary color with opacity
                  //     Colors.transparent, // Transparent at the bottom
                  //   ],
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  // ),
                ),
              ),
              // Announcement Content
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                alert.alertTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whiteColor,
                                  fontFamily: popinsSemiBold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 12.0,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    eventIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Posted on ${AppClass().formatDate2(alert.createdAt.toString())}',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontFamily: popinsRegulr,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicators() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          eventsController.alertsList.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: eventsController.selectedIndex.value == index
                  ? whiteColor
                  : Colors.grey,
            ),
          ),
        ),
      );
    });
  }
}
