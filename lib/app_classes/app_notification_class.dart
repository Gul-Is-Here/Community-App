// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';

// class AppNotificationClass{
//   Future<void> fetchPrayerTimes() async {
//   final date = DateTime.now().toLocal().toString().split(' ')[0];
//  // final url = 'https://api.aladhan.com/v1/timingsByCity/$date?city=Lahore&country=PK';
//   final url = 'https://api.aladhan.com/v1/timingsByCity/$date?city=Sugar+Land&country=USA';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final timings = data['data']['timings'];

//     print('Fajr: ${timings['Fajr']}');
//     print('Dhuhr: ${timings['Dhuhr']}');
//     print('Asr: ${timings['Asr']}');
//     print('Maghrib: ${timings['Maghrib']}');
//     print('Isha: ${timings['Isha']}');

//     // Convert prayer times to DateTime
//     DateTime fajrTime = _convertToDateTime(timings['Fajr']);
//     DateTime dhuhrTime = _convertToDateTime(timings['Dhuhr']);
//     DateTime asrTime = _convertToDateTime(timings['Asr']);
//     DateTime maghribTime = _convertToDateTime(timings['Maghrib']);
//     DateTime ishaTime = _convertToDateTime(timings['Isha']);

//     // Create Timestamps
//     Timestamp fajrTimestamp = Timestamp.fromDate(fajrTime);
//     Timestamp dhuhrTimestamp = Timestamp.fromDate(dhuhrTime);
//     Timestamp asrTimestamp = Timestamp.fromDate(asrTime);
//     Timestamp maghribTimestamp = Timestamp.fromDate(maghribTime);
//     Timestamp ishaTimestamp = Timestamp.fromDate(ishaTime);

//     // Print the Timestamps
//     print('Fajr Timestamp: $fajrTimestamp');
//     print('Dhuhr Timestamp: $dhuhrTimestamp');
//     print('Asr Timestamp: $asrTimestamp');
//     print('Maghrib Timestamp: $maghribTimestamp');
//     print('Isha Timestamp: $ishaTimestamp');


//     // Retrieve the token
//     String? token = await FirebaseMessaging.instance.getToken();

//     if (token != null) {
//       // Set the prayer times in Firestore with the token
//       await _setPrayerTimes({
//         'whenToNotify1': fajrTimestamp,
//         'whenToNotify2': dhuhrTimestamp,
//         'whenToNotify3': asrTimestamp,
//         'whenToNotify4': maghribTimestamp,
//         'whenToNotify5': ishaTimestamp,

//       }, token,);
//     } else {
//       print('Failed to get FCM token');
//     }
//   } else {
//     print('Failed to load prayer times');
//   }
// }
// DateTime _convertToDateTime(String timeString) {
//   List<String> timeParts = timeString.split(':');
//   int hour = int.parse(timeParts[0]);
//   int minute = int.parse(timeParts[1]);

//   DateTime now = DateTime.now();
//   return DateTime(now.year, now.month, now.day, hour, minute);
// }

// // Function to set the prayer times timestamps in Firestore
// Future<void> _setPrayerTimes(Map<String, Timestamp> prayerTimes, String token) async {
//   try {
//     await FirebaseFirestore.instance.collection('notifications').doc(token).set({
//       ...prayerTimes,
//       'token': token,
//     });
//     print('Prayer times set successfully!');
//   } catch (error) {
//     print('Failed to set prayer times: $error');
//   }
// }
// }