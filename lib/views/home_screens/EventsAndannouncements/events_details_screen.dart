// import 'package:your_project_path/reminder_util.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../app_classes/app_class.dart';
import '../../../constants/color.dart';
import '../../../constants/image_constants.dart';
import '../../../services/reminderUtilles.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;
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

  const EventDetailPage({
    super.key,
    required this.eventId,
    required this.title,
    required this.sTime,
    required this.endTime,
    required this.entry,
    required this.eventDate,
    required this.eventDetails,
    required this.eventType,
    required this.imageLink,
    required this.locatinV,
    required this.eventVenue,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  DateTime? _reminderDateTime;
  bool isSharing = false; // State for managing loading indicator

  @override
  void initState() {
    super.initState();
    ReminderUtil.initializeNotifications();
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final reminder = await ReminderUtil.loadReminderFromStorage(widget.title);
    setState(() {
      _reminderDateTime = reminder;
    });
  }

  Future<void> _setReminder(DateTime reminderDateTime) async {
    try {
      await ReminderUtil.setReminder(
        eventId: widget.eventId.toString(),
        title: widget.title,
        details: widget.eventDetails,
        reminderDateTime: reminderDateTime,
      );
      await ReminderUtil.saveReminderToStorage(widget.title, reminderDateTime);
      setState(() {
        _reminderDateTime = reminderDateTime;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Reminder set for ${DateFormat('yyyy-MM-dd HH:mm:a').format(reminderDateTime)}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateFormat('yyyy-MM-dd').parse(widget.eventDate),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime reminderDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final DateTime eventDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(
          '${widget.eventDate} ${widget.sTime}',
        );

        if (reminderDateTime.isBefore(eventDateTime)) {
          await _setReminder(reminderDateTime);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Reminder must be set before the event time.')),
          );
        }
      }
    }
  }

  Future<void> _downloadAndShareImage(
      String imageUrl, String title, String details) async {
    setState(() {
      isSharing = true; // Show loading indicator
    });
    try {
      String formattedDetails = """
Join Us for a Special Gathering at the Rosenberg Community Center

📅 Date: ${AppClass().formatDate2(widget.eventDate)}
⏰ Time: ${AppClass().formatTimeToAMPM(widget.sTime)} – ${AppClass().formatTimeToAMPM(widget.endTime)}
📍 Location: ${widget.eventVenue}

🌟 Theme: ${widget.title}

$details

📌 RSVP Required: ${widget.locatinV}

*Shared from Rosenberg Community Center App*
""";

      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/event_image.png');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: formattedDetails);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch image.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share image: $e")),
      );
    } finally {
      setState(() {
        isSharing = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003130),
        title: Text(
          "Event Detail",
          style: TextStyle(
              fontSize: 18,
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: popinsSemiBold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: isSharing
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: goldenColor,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.share, color: goldenColor),
            onPressed: isSharing
                ? null // Disable button while sharing
                : () => _downloadAndShareImage(
                      widget.imageLink,
                      widget.title,
                      widget.eventDetails,
                    ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(color: lightColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: popinsRegulr,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEventDetailItem("Event Time",
                    "Start: ${AppClass().formatTimeToAMPM(widget.sTime)}\nEnd: ${AppClass().formatTimeToAMPM(widget.endTime)}"),
                _buildEventDetailItem("Event",
                    "Type: ${widget.eventType}\nEntry: ${widget.entry}"),
              ],
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildSectionTitle("Event Date"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppClass().formatDate2(widget.eventDate),
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: popinsRegulr),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSectionTitle("Details"),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.eventDetails,
                style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: primaryColor,
                    fontFamily: popinsRegulr),
              ),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _showDateTimePicker,
            //   child: const Text("Set Reminder"),
            // ),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: lightColor, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            icLocation,
                            color: primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(
                                fontFamily: popinsSemiBold,
                                fontSize: 16,
                                color: primaryColor),
                          ),
                          // Text(
                          //   '(click to locate )',
                          //   style: TextStyle(
                          //       fontFamily: popinsRegulr,
                          //       fontSize: 11,
                          //       color: lightColor),
                          // ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppClass().openMap(widget.locatinV);
                      }
                      // print(eventLink);
                      ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Text(
                            maxLines: 4,
                            widget.eventVenue,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontFamily: popinsSemiBold,
                                color: primaryColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),

            const SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          backgroundColor: primaryColor),
                      onPressed: _showDateTimePicker,
                      child: Text(
                        "Set Reminder",
                        style: TextStyle(
                            fontFamily: popinsMedium, color: lightColor),
                      ),
                    ),
                  ),
                  if (_reminderDateTime != null) ...[
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          "Reminder Set",
                          style: TextStyle(
                              fontFamily: popinsSemiBold,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                        // const SizedBox(height: 5),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(_reminderDateTime!),
                          style: TextStyle(
                              fontFamily: popinsRegulr,
                              color: primaryColor,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.network(
              widget.imageLink,
              height: 250,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndShareImage(
      String imageUrl, String title, String details) async {
    try {
      String formattedDetails = """
Join Us for a Special Gathering at the Rosenberg Community Center

📅 Date: ${AppClass().formatDate2(widget.eventDate)}
⏰ Time: ${AppClass().formatTimeToAMPM(widget.sTime)} – ${AppClass().formatTimeToAMPM(widget.endTime)}
📍 Location: ${widget.eventVenue}

🌟 Theme: ${widget.title}

$details

📌 RSVP Required: ${widget.locatinV}

*Shared from Rosenberg Community Center App*
""";

      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/event_image.png');
        await file.writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: formattedDetails);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch image.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share image: $e")),
      );
    }
  }

  Widget _buildEventDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: popinsRegulr),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 14, color: primaryColor, fontFamily: popinsRegulr),
          ),
        ],
      ),
    );
  }

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
