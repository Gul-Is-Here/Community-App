import 'dart:core';
import 'dart:io';
import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class EventDetailPage extends StatelessWidget {
  final String title;
  final String sTime;
  final String endTime;
  final String eventType;
  final String entry;
  final String eventDate;
  final String eventDetails;
  final String imageLink;
  final String locatinV;
  final String eventVenue;

  const EventDetailPage(
      {super.key,
      required this.title,
      required this.sTime,
      required this.endTime,
      required this.entry,
      required this.eventDate,
      required this.eventDetails,
      required this.eventType,
      required this.imageLink,
      required this.locatinV,
      required this.eventVenue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F0), // Light greenish background
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Event Detail",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: popinsRegulr),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              await _downloadAndShareImage(imageLink, title, eventDetails);
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: popinsRegulr,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),

            // Event Time and Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEventDetailItem("Event Time",
                    "Start: ${AppClass().formatTimeToAMPM(sTime)}\nEnd: ${AppClass().formatTimeToAMPM(endTime)}"),
                _buildEventDetailItem(
                    "Event", "Type: $eventType\nEntry: $entry"),
              ],
            ),
            const SizedBox(height: 20),

            // Event Date
            _buildSectionTitle("Event Date"),
            const SizedBox(height: 8),
            Text(
              "${AppClass().formatDate2(eventDate)}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: popinsRegulr),
            ),
            const SizedBox(height: 20),

            // Details Section
            _buildSectionTitle("Details"),
            const SizedBox(height: 8),
            Text(
              eventDetails,
              style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                  fontFamily: popinsRegulr),
            ),
            const SizedBox(height: 20),

            // Venue Section
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppClass().launchURL(locatinV);
                      },
                      child: const Icon(Icons.location_on,
                          color: Color(0xFF3FA27E), size: 20),
                    ),
                    Expanded(
                      child: Text(
                        'Venue',
                        style: TextStyle(
                            fontFamily: popinsSemiBold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 5,),
                Text(
                  eventVenue,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: popinsRegulr),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Section
            Image.network(
              imageLink,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAndShareImage(
      String imageUrl, String title, String details) async {
    try {
      if (imageUrl.isEmpty) {
        throw "Image URL is empty";
      }
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/event_image.png');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: "$title\n\n$details");
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to fetch image. Status Code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error sharing image: $e");
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text("Failed to share image: $e")),
      );
    }
  }

  // Reusable Widget for Event Time and Type
  Widget _buildEventDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontFamily: popinsRegulr),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 14, color: Colors.black87, fontFamily: popinsRegulr),
        ),
      ],
    );
  }

  // Reusable Widget for Section Titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: popinsRegulr,
        color: primaryColor,
      ),
    );
  }
}
