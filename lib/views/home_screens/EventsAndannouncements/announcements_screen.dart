import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart'; // Adjust with your controller path

class AnnouncementsScreen extends StatelessWidget {
  final HomeEventsController controller = Get.put(HomeEventsController());

  AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: primaryColor,
        title: const Text(
          'Announcements',
          style: TextStyle(fontFamily: popinsSemiBold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        } else if (controller.feedsList.isEmpty) {
          return Center(
              child: Text(
            "No announcements available.",
            style: TextStyle(fontFamily: popinsRegulr),
          ));
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: controller.alertsList.length,
            itemBuilder: (context, index) {
              // final feed = controller.feedsList[index];
              final alert = controller.alertsList[index];
              return AnnouncementCard(
                alertDisc: alert.alertDescription,
                onTap: () {
                  Get.to(() => AnnouncementsDetailsScreen(alertDisc: alert.alertDescription,
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.grey, size: 16),
                      SizedBox(width: 5),
                      Text(
                        "Posted on $postedDate",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
