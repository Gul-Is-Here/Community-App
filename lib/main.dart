// import 'package:alarm/alarm.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/qibla_controller.dart';
import 'package:community_islamic_app/firebase_options.dart';
import 'package:community_islamic_app/views/auth_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await NotificationServices().initializeNotification();

  await QiblahController().getLocation();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  HomeController();
  DateTime today = DateTime.now();

  if (sharedPreferences.containsKey("prayerTimesMonth")) {
    if (today.month != sharedPreferences.getInt("prayerTimesMonth")) {
      if (sharedPreferences.containsKey("prayerTimes")) {
        sharedPreferences.remove("prayerTimes");
      }
    }
  }

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
    sharedPreferences.setString("selectedSound", "Adhan - Makkah");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.maskType = EasyLoadingMaskType.black;
    return GetMaterialApp(
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
  