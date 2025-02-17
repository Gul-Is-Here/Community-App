import 'package:community_islamic_app/constants/image_constants.dart';
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
  final String? image;

  AnnouncementsDetailsScreen({
    Key? key,
    required this.alertDisc,
    required this.controller,
    required this.title,
    required this.details,
    required this.createdDate,
    required this.description,
    required this.postedDate,
    this.image,
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
            fontFamily: popinsSemiBold,
            fontSize: 18,
            color: whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: goldenColor),
            onPressed: () {
              Share.share(
                  ''' *$title*\n\n$alertDisc\n\n*Shared from Rosenberg Community Center App*''');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              color: lightColor,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    alertDisc,
                    style: TextStyle(
                      fontFamily: popinsRegulr,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (image != null && image!.isNotEmpty)
                    Image.network(
                      image!,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
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
