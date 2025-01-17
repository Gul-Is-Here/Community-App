import 'dart:io';

import 'package:community_islamic_app/views/Gallery_Events/ask_imam_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../views/home_screens/EventsAndannouncements/events_details_screen.dart';

class AppClass {
  Future<void> launchURL(String url) async {
    if (url.isEmpty) {
      throw 'Invalid URL';
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // Opens in external browser
    } else {
      throw 'Could not launch $url';
    }
  }

  int calculateAge(String dob) {
    if (dob == null || dob.isEmpty) return 0;

    try {
      // Define the date format based on the presence of "/" or "-"
      DateFormat dateFormat = dob.contains('-')
          ? DateFormat('yyyy-MM-dd')
          : DateFormat('yyyy/MM/dd');

      // Parse the date using the correct format
      DateTime birthDate = dateFormat.parse(dob);

      // Get the current date
      DateTime today = DateTime.now();

      // Calculate the difference in years
      int age = today.year - birthDate.year;

      // Adjust if the birthdate hasn't occurred yet this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print("Error parsing date: $e");
      return 0;
    }
  }

  String formatDate(String date) {
    // Split the date string into year, month, and day
    List<String> dateParts = date.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Create a list of month names
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Format the date into "Month Day, Year"
    return "${monthNames[month - 1]} $day, $year"; // Month is 0-based in the list
  }

  String formatTime(String time) {
    // Split the input string into hours, minutes, and seconds
    List<String> timeParts = time.split(':');

    // Parse the parts as integers
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    // Determine AM/PM period
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    int formattedHour = hour % 12;
    formattedHour =
        formattedHour == 0 ? 12 : formattedHour; // Handle midnight as 12 AM

    // Format minutes and seconds to always show two digits
    String formattedMinute = minute.toString().padLeft(2, '0');
    String formattedSecond = second.toString().padLeft(2, '0');

    return "$formattedHour:$formattedMinute:$formattedSecond $period";
  }

  String formatDate2(String dateString) {
    try {
      // Parse the input string to DateTime
      DateTime parsedDate = DateTime.parse(dateString);

      // Extract day, month, and weekday
      String weekday =
          DateFormat('EEEE').format(parsedDate); // Full day name (e.g., Friday)
      String month = DateFormat('MMMM')
          .format(parsedDate); // Full month name (e.g., January)
      int day = parsedDate.day;

      // Add the appropriate ordinal suffix
      String suffix = _getDaySuffix(day);

      // Format as "Friday, January 17th"
      return '$weekday, $month $day$suffix';
    } catch (e) {
      print("Error parsing date: $e");
      return ""; // Return an empty string or handle the error as needed
    }
  }

// Helper function to get the ordinal suffix
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th'; // Special case for 11th, 12th, 13th
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formatPrayerTime(String time) {
    try {
      final dateTime = DateFormat("HH:mm").parse(time);
      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      return time;
    }
  }

  String formatPrayerTimeToAmPm(String time) {
    try {
      // Parse the input time from "HH:mm" format
      final dateTime = DateFormat("HH:mm").parse(time);
      // Format it to "hh:mm a" format
      return DateFormat("hh:mm a").format(dateTime);
    } catch (e) {
      print('Error parsing time: $e');
      return 'Invalid time'; // Return a default message for invalid input
    }
  }

  String addMinutesToPrayerTime(String prayerTime, int minutesToAdd) {
    try {
      final dateTime = DateFormat("HH:mm").parse(prayerTime);
      DateTime updatedTime = dateTime.add(Duration(minutes: minutesToAdd));
      return DateFormat('h:mm a').format(updatedTime);
    } catch (e) {
      print('Error parsing time: $e');
      return 'Invalid time';
    }

    ///
    ///.
    ///
  }

  DateTime parseDate(String dateStr) {
    return DateFormat('d/M').parse(dateStr);
  }

  // Metho 1 dec

  String convertDate(String inputDate) {
    try {
      // Parse the date string with the given format
      DateFormat inputFormat = DateFormat('yy-MM-dd');
      DateTime parsedDate = inputFormat.parse(inputDate);

      // Format the date to "1 MMM"
      String formattedDate = "1 ${DateFormat('MMM').format(parsedDate)}";
      return formattedDate;
    } catch (e) {
      // Handle errors if the date format is invalid
      return 'Invalid date format';
    }
  }

  void _showWhatsAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Join WhatsApp Group',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: 18,
              color: whiteColor,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildSocialMediaButton(
                    context: context,
                    image: icWhatsApp,
                    label: 'RCC Brothers',
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await launchUrl(Uri.parse(
                          'https://chat.whatsapp.com/C558smdW2bc2asAJIeoS6t'));
                    },
                  ),
                  buildSocialMediaButton(
                    context: context,
                    image: icWhatsApp,
                    label: 'RCC Sisters',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://chat.whatsapp.com/JwNn9RLPj4kFcrOLW4ANgW'));
                    },
                  ),
                ],
              ),
              // ListTile(
              //   leading: Image.asset(icWhatsapp),
              //   title: Text(
              //     'RCC Brothers',
              //     style: TextStyle(fontFamily: popinsRegulr),
              //   ),
              //   onTap: () async {

              //   },
              // ),
              // const Divider(),
            ],
          ),
        );
      },
    );
  }
// Method For Social Media Links

  void showSocialMediaDialog(BuildContext context) {
    PageController pageController = PageController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(16),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Connect with RCC',
                style: TextStyle(
                  fontFamily: popinsSemiBold,
                  fontSize: 16,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          content: SizedBox(
            width: 335, // Fixed width
            height: 280, // Fixed height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView(
                      controller: pageController,
                      children: [
                        // Page 1 with 8 icons in 2 rows
                        buildSocialMediaPage(context, [
                          buildSocialMediaButton(
                            context: context,
                            image: icFacebook,
                            label: 'Facebook',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await launchUrl(Uri.parse(
                                  'https://www.facebook.com/rosenbergcommunitycenter/'));
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icInsta,
                            label: 'Instagram',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await launchUrl(Uri.parse(
                                  'https://www.instagram.com/rosenbergcommunitycenter'));
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icYoutube,
                            label: 'Youtube',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await launchUrl(Uri.parse(
                                  'https://www.youtube.com/channel/UCBvcBiS7SvA7NDn6oI1Qu5Q'));
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icWhatsApp,
                            label: 'WhatsApp',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              _showWhatsAppDialog(context);
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icNewsLetter,
                            label: 'Newsletters',
                            onPressed: () async {
                              launchUrl(Uri.parse(
                                  'https://rosenbergcommunitycenter.us21.list-manage.com/subscribe?u=7e6387230db8bce6af81ee41d&id=93bc7cf7b2'));
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icGmail,
                            label: 'Email Us',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'admin@rosenbergcommunitycenter.org',
                              );
                              await launchUrl(emailLaunchUri);
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icCall,
                            label: 'Call Us',
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final Uri phoneUri = Uri(
                                scheme: 'tel',
                                path: '+1 (281) 303-1758',
                              );
                              await launchUrl(phoneUri);
                            },
                          ),
                          buildSocialMediaButton(
                            context: context,
                            image: icChat,
                            label: 'RCC Chat',
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Chat action
                            },
                          ),
                        ]),
                        // Page 2 with 1 icon
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: buildSocialMediaButton(
                              context: context,
                              image: icAskImam,
                              label: 'Ask Imam',
                              onPressed: () {
                                Navigator.of(context).pop();
                                Get.to(() => AskImamPage());
                                // Ask Imam action
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 2, // Total pages
                    effect: const WormEffect(
                      dotHeight: 9.0,
                      dotWidth: 9.0,
                      activeDotColor: Color(0xFF44A63C),
                      dotColor: Color(0xFF335B5A),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSocialMediaPage(BuildContext context, List<Widget> buttons) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.take(4).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.skip(4).take(4).toList(),
        ),
      ],
    );
  }

  Widget buildSocialMediaButton({
    required BuildContext context,
    required String image,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: lightColor,
            child: Image.asset(
              image,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 12,
              color: whiteColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
        await Share.shareXFiles([XFile(file.path)],
            text:
                '''$title\n\n$details\n\n*Shared From Rosenberg Community Center App*
        ''');
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

  // ---- Show Model Bottom Sheet of Events Details Page
  Future<dynamic> EventDetailsShowModelBottomSheet(
    BuildContext context,
    String title,
    String sTime,
    String endTime,
    String eventType,
    String entry,
    String eventDate,
    String eventDetails,
    String imageLink,
    String locatinD,
    String eventLink,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color(0xFFB3E8DA),
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: .75,
        child: SingleChildScrollView(
          child: Container(
            // height: 600,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          maxLines: 2,
                          title,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontFamily: popinsSemiBold,
                              color: secondaryColor),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            await _downloadAndShareImage(
                                imageLink, title, eventDetails);
                          },
                          child: Icon(
                            Icons.share,
                            color: secondaryColor,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Event Time',
                            style: TextStyle(
                                fontFamily: popinsSemiBold,
                                fontSize: 16,
                                color: secondaryColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Start: ${formatTimeToAMPM(sTime)}',
                            style: const TextStyle(
                                fontFamily: popinsRegulr,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'End:  ${formatTimeToAMPM(endTime)}',
                            style: const TextStyle(
                                fontFamily: popinsRegulr,
                                color: Colors.black,
                                fontSize: 12),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Event',
                            style: TextStyle(
                                fontFamily: popinsSemiBold,
                                fontSize: 16,
                                color: secondaryColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Type: $eventType',
                            style: const TextStyle(
                                fontFamily: popinsRegulr,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Entry: $entry',
                            style: const TextStyle(
                                fontFamily: popinsRegulr,
                                color: Colors.black,
                                fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Event Date',
                    style: TextStyle(
                        fontFamily: popinsSemiBold,
                        fontSize: 16,
                        color: secondaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${AppClass().formatDate2(eventDate)}',
                    style: const TextStyle(
                        fontFamily: popinsRegulr,
                        color: Colors.black,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Details',
                    style: TextStyle(
                        fontFamily: popinsSemiBold,
                        fontSize: 16,
                        color: secondaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    maxLines: 8,
                    eventDetails,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        fontFamily: popinsRegulr,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(icLocation),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Venue',
                        style: TextStyle(
                            fontFamily: popinsSemiBold,
                            fontSize: 16,
                            color: secondaryColor),
                      ),
                      Text(
                        '(click to locate )',
                        style: TextStyle(
                            fontFamily: popinsRegulr,
                            fontSize: 11,
                            color: secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppClass().launchURL(eventLink);
                      print(eventLink);
                    },
                    child: Text(
                        maxLines: 4,
                        locatinD,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontFamily: popinsSemiBold,
                            color: primaryColor)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        imageLink,
                        // fit: BoxFit.cover,
                        height: 250,
                      )),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Event Details Screen time formate method
  String formatTimeToAMPM(String time24) {
    // Parse the input time string
    DateTime parsedTime = DateFormat("HH:mm").parse(time24);

    // Format to 12-hour time with AM/PM
    String formattedTime = DateFormat("h:mm a").format(parsedTime);

    return formattedTime; // e.g., "1:40 PM"
  }

  Color hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) {
      buffer.write('ff'); // Add alpha value (fully opaque)
      buffer.write(hexCode.replaceFirst('#', '')); // Remove '#' if present
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
