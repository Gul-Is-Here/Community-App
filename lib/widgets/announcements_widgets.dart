import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_details_screen.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_screen.dart';
import 'package:community_islamic_app/widgets/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/azan_settings/events_notification_settinons.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Column(
        children: [
          Obx(() {
            if (eventsController.isLoading.value) {
              return _buildLoadingState(screenHeight);
            }

            if (eventsController.alertsList.isEmpty) {
              return _buildEmptyState(screenHeight);
            }

            return _buildAnnouncementsContent(screenWidth, screenHeight);
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingState(double screenHeight) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: screenHeight * 0.02),
        Center(child: CircularProgressIndicator(color: primaryColor)),
      ],
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: screenHeight * 0.02),
        Center(
          child: Text(
            'Announcements are coming soon',
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              color: whiteColor,
              fontFamily: popinsSemiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsContent(double screenWidth, double screenHeight) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: screenHeight * 0.01),
        _buildCarousel(screenWidth, screenHeight),
        SizedBox(height: screenHeight * 0.015),
        _buildCarouselIndicators(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MyText(
                'ANNOUNCEMENTS',
                style: TextStyle(
                  fontFamily: popinsBold,
                  color: whiteColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AnnouncementsScreen());
            },
            child: MyText(
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

  Widget _buildCarousel(double screenWidth, double screenHeight) {
    return CarouselSlider.builder(
      itemCount: eventsController.alertsList.length,
      itemBuilder: (context, index, realIndex) {
        final alert = eventsController.alertsList[index];
        return _buildAnnouncementCard(alert, screenWidth, screenHeight);
      },
      options: CarouselOptions(
        height: screenHeight * 0.11, // Responsive height
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

  Widget _buildAnnouncementCard(
      dynamic alert, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: GestureDetector(
        onTap: () {
          eventsController.selectedIndexAnnouncment.value =
              eventsController.alertsList.indexOf(alert);
          Get.to(() => AnnouncementsDetailsScreen(
                image: alert.image,
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
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFC4F1DD)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Background Container with Gradient
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF032727),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Announcement Content
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.008,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.005),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.03),
                            child: MyText(
                              alert.alertTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: whiteColor,
                                fontFamily: popinsSemiBold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.002,
                              horizontal: screenWidth * 0.03,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  eventIcon,
                                  width: screenWidth * 0.06,
                                  height: screenWidth * 0.06,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: MyText(
                                    'Posted on ${AppClass().formatDate2(alert.createdAt.toString())}',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: screenWidth * 0.03,
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
