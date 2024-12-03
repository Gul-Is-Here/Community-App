import 'package:community_islamic_app/views/Gallery_Events/ask_imam_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color.dart';
import '../constants/image_constants.dart';
import '../views/Gallery_Events/chat_with_Rcc.dart';
import '../widgets/social_widget.dart';

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

      // Format the DateTime to "MMM d, yyyy"
      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return ""; // Return an empty string or handle the error as needed
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

// Method For Social Media Links

  void showSocialMediaDialog(BuildContext context) {
    print('Pressed');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Connect with RCC',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                children: [
                  buildSocialMediaButton(
                    icon: Image.asset(askImamIcon),
                    label: 'Ask Imam',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => AskImamScreen());
                    },
                  ),
                  buildSocialMediaButton(
                    icon: Icon(Icons.email, color: primaryColor),
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
                    icon: const Icon(Icons.call, color: Colors.greenAccent),
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
                    icon: Image.asset(icWhatsapp),
                    label: 'WhatsApp',
                    onPressed: () {
                      Navigator.of(context).pop();
                      showWhatsAppDialog(
                          context); // New dialog for WhatsApp options
                    },
                  ),
                  buildSocialMediaButton(
                    icon: const Icon(Icons.facebook, color: Colors.blueAccent),
                    label: 'Facebook',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.facebook.com/rosenbergcommunitycenter/'));
                    },
                  ),
                  buildSocialMediaButton(
                    icon: Image.asset(
                      fit: BoxFit.cover,
                      icyoutube,
                    ),
                    label: 'YouTube',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.youtube.com/channel/UCBvcBiS7SvA7NDn6oI1Qu5Q'));
                    },
                  ),
                  buildSocialMediaButton(
                    icon: Image.asset(icInstagram),
                    label: 'Instagram',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.instagram.com/rosenbergcommunitycenter/?igshid=MmIzYWVlNDQ5Yg%3D%3D'));
                    },
                  ),
                  buildSocialMediaButton(
                    icon: Icon(
                      Icons.newspaper,
                      color: primaryColor,
                    ),
                    label: 'Newsletters',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  buildSocialMediaButton(
                    icon: Icon(
                      Icons.chat,
                      color: primaryColor,
                    ),
                    label: 'RCC Chat',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => const ChatWithRCCScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showWhatsAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Join WhatsApp Group',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(icWhatsapp),
                title: Text(
                  'RCC Brothers',
                  style: TextStyle(fontFamily: popinsRegulr),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await launchUrl(Uri.parse(
                      'https://chat.whatsapp.com/C558smdW2bc2asAJIeoS6t'));
                },
              ),
              const Divider(),
              ListTile(
                leading: Image.asset(icWhatsapp),
                title: const Text(
                  'RCC Sisters',
                  style: TextStyle(fontFamily: popinsRegulr),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await launchUrl(Uri.parse(
                      'https://chat.whatsapp.com/JwNn9RLPj4kFcrOLW4ANgW'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
