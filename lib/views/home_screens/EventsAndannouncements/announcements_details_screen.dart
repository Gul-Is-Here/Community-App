import 'dart:io';
import 'package:flutter/material.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AnnouncementsDetailsScreen extends StatefulWidget {
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
  _AnnouncementsDetailsScreenState createState() =>
      _AnnouncementsDetailsScreenState();
}

class _AnnouncementsDetailsScreenState
    extends State<AnnouncementsDetailsScreen> {
  bool _isSharing = false;

  Future<void> _shareContent() async {
    setState(() {
      _isSharing = true;
    });

    try {
      String text =
          ''' *${widget.title}*\n\n${widget.alertDisc}\n\n*Shared from Rosenberg Community Center App*''';

      if (widget.image != null && widget.image!.isNotEmpty) {
        final uri = Uri.parse(widget.image!);
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/shared_image.png');
          await file.writeAsBytes(response.bodyBytes);

          await Share.shareXFiles([XFile(file.path)], text: text);
        } else {
          // If image download fails, still share text
          await Share.share(text);
        }
      } else {
        // If no image, just share the text
        await Share.share(text);
      }
    } catch (e) {
      print("Error sharing: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share content: $e")),
      );
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
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
            icon: _isSharing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.share, color: goldenColor),
            onPressed: _isSharing ? null : _shareContent,
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
                    widget.title,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontFamily: popinsSemiBold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.alertDisc,
                    style: TextStyle(
                      fontFamily: popinsRegulr,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.image != null && widget.image!.isNotEmpty)
                    Image.network(
                      widget.image!,
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
