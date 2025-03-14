import 'dart:io'; // Import this for Platform check
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/firebase_options.dart';
import 'package:community_islamic_app/views/auth_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';

Future<void> initNotifications() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/logo',
    [
      NotificationChannel(
        icon: 'resource://drawable/logo',
        playSound: true,
        soundSource: 'resource://raw/beep',
        channelKey: 'beep_channel',
        channelName: 'Beep notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: primaryColor,
        ledColor: primaryColor,
      ),
      NotificationChannel(
          icon: 'resource://drawable/logo',
          playSound: true,
          soundSource: 'resource://raw/azan',
          channelKey: 'makkah_channel',
          channelName: 'Makkah Azan Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: primaryColor,
          ledColor: primaryColor),
      NotificationChannel(
        icon: 'resource://drawable/logo',
        playSound: true,
        soundSource: 'resource://raw/makkahfajrazan',
        channelKey: 'makkah_fajar_channel',
        channelName: 'Makkah Azan fajr Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: primaryColor,
        ledColor: primaryColor,
      ),
      NotificationChannel(
        icon: 'resource://drawable/logo',
        playSound: true,
        soundSource: 'resource://raw/azanmadina',
        channelKey: 'madina_channel',
        channelName: 'Makkah Azan Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: primaryColor,
        ledColor: primaryColor,
      ),
      NotificationChannel(
          icon: 'resource://drawable/logo',
          playSound: true,
          soundSource: 'resource://raw/madinafajrazan',
          channelKey: 'madina_fajar_channel',
          channelName: 'Madina Azan fajr Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: primaryColor,
          ledColor: primaryColor,
          importance: NotificationImportance.High),
      NotificationChannel(
          icon: 'resource://drawable/logo',
          playSound: true,
          soundSource: 'resource://raw/iqamah',
          channelKey: 'iqamah_channel',
          channelName: 'Iqamah  Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: primaryColor,
          ledColor: primaryColor,
          importance: NotificationImportance.High),
      NotificationChannel(
          playSound: false,
          channelKey: 'disable_channel',
          channelName: 'Iqamah  Basic Notifications',
          channelDescription: 'Notification channel for basic disable',
          defaultColor: primaryColor,
          ledColor: primaryColor,
          importance: NotificationImportance.Low)
    ],
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("🔔 Background Message Received: ${message.messageId}");
}

Future<void> checkFirebaseMessaging() async {
  bool isAllowed = await initFirebaseMessagingNoti();
  if (isAllowed) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🏁 Notification Clicked: ${message.notification?.title}");
      handleNotificationNavigation(message.data['type'] ?? "");
    });
  }
}

Future<bool> initFirebaseMessagingNoti() async {
  final messaging = FirebaseMessaging.instance;
  final notiReq = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  return notiReq.authorizationStatus == AuthorizationStatus.authorized;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  NotificationServices().initializeNotifications();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // Notification Scheduler
  await initNotifications();

  if (!sharedPreferences.containsKey("fajr")) {
    sharedPreferences.setBool("fajr", true);
  }

  if (!sharedPreferences.containsKey("dhuhr")) {
    sharedPreferences.setBool("dhuhr", true);
  }

  if (!sharedPreferences.containsKey("asr")) {
    sharedPreferences.setBool("asr", true);
  }

  if (!sharedPreferences.containsKey("maghrib")) {
    sharedPreferences.setBool("maghrib", true);
  }

  if (!sharedPreferences.containsKey("isha")) {
    sharedPreferences.setBool("isha", true);
  }

  if (!sharedPreferences.containsKey("selectedSound")) {
    sharedPreferences.setString("selectedSound", "makkah_channel");
  }

  if (!sharedPreferences.containsKey("fajrIqamah")) {
    sharedPreferences.setBool("fajrIqamah", true);
  }

  if (!sharedPreferences.containsKey("dhuhrIqamah")) {
    sharedPreferences.setBool("dhuhrIqamah", true);
  }

  if (!sharedPreferences.containsKey("asrIqamah")) {
    sharedPreferences.setBool("asrIqamah", true);
  }

  if (!sharedPreferences.containsKey("maghribIqamah")) {
    sharedPreferences.setBool("maghribIqamah", true);
  }

  if (!sharedPreferences.containsKey("ishaIqamah")) {
    sharedPreferences.setBool("ishaIqamah", true);
  }
  if (!sharedPreferences.containsKey("event")) {
    sharedPreferences.setBool("event", true);
  }
  if (!sharedPreferences.containsKey("annoucement")) {
    sharedPreferences.setBool("annoucement", true);
  }

  NotificationServices notificationServices = NotificationServices();
  notificationServices.initializeNotifications(); // ✅ Call this here

  // Check if Firebase Messaging is allowed
  await checkFirebaseMessaging();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    return GetMaterialApp(
      title: 'Rosenberg Community Center',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
