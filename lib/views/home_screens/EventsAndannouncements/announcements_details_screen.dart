import 'package:flutter/material.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class AnnouncementsDetailsScreen extends StatelessWidget {
  final HomeEventsController controller;
  final String title;
  final String createdDate;
  final String postedDate;
  final String description;
  final String details;
  final String alertDisc;

  AnnouncementsDetailsScreen({
    Key? key,
    required this.alertDisc,
    required this.controller,
    required this.title,
    required this.details,
    required this.createdDate,
    required this.description,
    required this.postedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: popinsMedium,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: goldenColor),
            onPressed: () {
              // Share functionality
              Share.share('Check out this announcement: $title\n\n$alertDisc');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Height of the bottom line
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              color: Colors.white, // Bottom line color
              height: 1.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section

            // Announcement Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Posted Date
                  // Row(
                  //   children: [
                  //     Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                  //     SizedBox(width: 8),
                  //     Text(
                  //       'Posted: ${controller.formatDateString(postedDate)}',
                  //       style: TextStyle(
                  //         color: Colors.grey[700],
                  //         fontSize: 14.0,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8.0),

                  // Created Date
                  // Row(
                  //   children: [
                  //     Icon(Icons.date_range, color: Colors.grey, size: 18),
                  //     SizedBox(width: 8),
                  //     Text(
                  //       'Created: ${controller.formatDateString(createdDate)}',
                  //       style: TextStyle(
                  //         color: Colors.grey[700],
                  //         fontSize: 14.0,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 20.0),

                  // // Title
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontFamily: popinsSemiBold,
                      // color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    alertDisc,
                    style: TextStyle(
                      fontFamily: popinsRegulr,
                      // fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Description with Card-like appearance
                  // Container(
                  //   padding: EdgeInsets.all(16.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12.0),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 8.0,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Text(
                  //     description,
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //       height: 1.6,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
