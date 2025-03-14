import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/views/azan_settings/events_notification_settinons.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_details_screen.dart';
import 'package:community_islamic_app/widgets/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';

import '../../../constants/image_constants.dart'; // Adjust with your controller path

class AnnouncementsScreen extends StatelessWidget {
  final HomeEventsController controller = Get.put(HomeEventsController());

  AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios,
                color: Colors.white, size: 20)),
        backgroundColor: primaryColor,
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.share,
        //         color: goldenColor,
        //       )),
        // ],
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1.0), // Height of the bottom line
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              color: Colors.white, // Bottom line color
              height: 1.0,
            ),
          ),
        ),
        title: Text(
          'Announcements',
          style: TextStyle(
              fontFamily: popinsSemiBold, color: lightColor, fontSize: 18),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() =>  NotificationSettingsPage()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                notificationICon, // Your notification icon
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],

        // centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        } else if (controller.feedsList.isEmpty) {
          return Center(
              child: MyText(
            "No announcements available.",
            style: TextStyle(fontFamily: popinsRegulr, color: whiteColor),
          ));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: controller.alertsList.length,
            itemBuilder: (context, index) {
              // final feed = controller.feedsList[index];
              final alert = controller.alertsList[index];
              return AnnouncementCard(
                alertDisc: alert.alertDescription,
                onTap: () {
                  Get.to(() => AnnouncementsDetailsScreen(
                      image: alert.image,
                      alertDisc: alert.alertDescription,
                      controller: controller,
                      title: alert.alertTitle,
                      details: alert.alertDescription,
                      createdDate: alert.createdAt.toString(),
                      description: '',
                      postedDate: alert.updatedAt.toString()));
                },
                title: alert.alertTitle,
                postedDate:
                    controller.formatDateString(alert.createdAt.toString()),
              );
            },
          );
        }
      }),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  void Function() onTap;

  final String title;
  final String postedDate;
  final String alertDisc;

  AnnouncementCard({
    super.key,
    required this.alertDisc,
    required this.onTap,
    required this.title,
    required this.postedDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xFFC4F1DD)),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: const Color(0xFF032727)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth * .7,
                            child: MyText(
                              title,
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: whiteColor,
                                fontFamily: popinsRegulr,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                eventIcon,
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                "Posted on $postedDate",
                                style: TextStyle(
                                  fontFamily: popinsRegulr,
                                  fontSize: 12.0,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * .03,
                  decoration: const BoxDecoration(
                      color: Color(0xFF032727),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
