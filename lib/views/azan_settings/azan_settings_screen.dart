import 'package:audioplayers/audioplayers.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzanSettingsScreen extends StatefulWidget {
  const AzanSettingsScreen({super.key});

  @override
  _AzanSettingsScreenState createState() =>
      _AzanSettingsScreenState();
}

class _AzanSettingsScreenState
    extends State<AzanSettingsScreen> {
  String _selectedAzan = 'Adhan - Makkah';

  Map<String, bool> _azanTimes = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  Map<String, bool> _iqamahTimes = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  bool _eventNotificationsEnabled = false;
  bool _announcementNotificationsEnabled = false;

  SharedPreferences? sharedPreferences;
  final AudioPlayer player = AudioPlayer();
  final NotificationServices notificationServices = NotificationServices();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    screenInit();
  }

  Future<void> screenInit() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _selectedAzan = sharedPreferences!.getString("selectedSound") ?? 'Adhan - Makkah';
        _eventNotificationsEnabled = sharedPreferences!.getBool('event') ?? false;
        _announcementNotificationsEnabled = sharedPreferences!.getBool('announcement') ?? false;
      });
    }
  }

  Future<void> _saveNotificationSettings() async {
    sharedPreferences!.setBool('event', _eventNotificationsEnabled);
    sharedPreferences!.setBool('announcement', _announcementNotificationsEnabled);
  }

  void _toggleEventNotifications(bool value) async {
    setState(() {
      _eventNotificationsEnabled = value;
    });
    await _saveNotificationSettings();

    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('events');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('events');
    }
  }

  void _toggleAnnouncementNotifications(bool value) async {
    setState(() {
      _announcementNotificationsEnabled = value;
    });
    await _saveNotificationSettings();

    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('announcements');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('announcements');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Prayer & Notification Settings",
          style: TextStyle(fontSize: 20, fontFamily: popinsSemiBold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          _buildAzanSelection(),
          const SizedBox(height: 20),
          _buildAzanTimeTable(),
          const SizedBox(height: 20),
          _buildNotificationSettings(),
        ],
      ),
    );
  }

  Widget _buildAzanSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Azan Sound", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Column(
          children: ['Disable', 'Default', 'Adhan - Makkah', 'Adhan - Madina'].map((title) {
            return ListTile(
              leading: Radio<String>(
                activeColor: primaryColor,
                value: title,
                groupValue: _selectedAzan,
                onChanged: (String? value) async {
                  sharedPreferences?.setString("selectedSound", value!);
                  setState(() {
                    _selectedAzan = value!;
                  });
                  await homeController.setNotifications();
                },
              ),
              title: Text(title),
            );
          }).toList(),
        ),
      ],
    );
  }
Widget _buildAzanTimeTable() {
    // Your Azan time selection code (unchanged)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Prayer Time',
                  style: TextStyle(
                    fontFamily: popinsMedium,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(
                    fontFamily: popinsMedium,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                'Adhan',
                style: TextStyle(
                  fontFamily: popinsMedium,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Iqamah',
                style: TextStyle(
                  fontFamily: popinsMedium,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(),
          Column(
            children: homeController.prayerTimes!
                .getTodayPrayerTimes()!
                .toJson()
                .entries
                .map((MapEntry<String, dynamic> time) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      time.key,
                      style: TextStyle(
                        fontFamily: popinsRegulr,
                        color:
                            time.key == "Sunrise" ? primaryColor : Colors.black,
                        fontWeight: time.key == "Sunrise"
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      homeController.prayerTimes!
                          .convertTimeFormat(time.value.toString()),
                      style: TextStyle(
                        fontFamily: popinsRegulr,
                        color:
                            time.key == "Sunrise" ? primaryColor : Colors.black,
                        fontWeight: time.key == "Sunrise"
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: _azanTimes[time.key]!,
                    activeColor: primaryColor,
                    onChanged: (bool? value) async {
                      setState(() {
                        _azanTimes[time.key] = value!;
                      });

                      sharedPreferences!
                          .setBool(time.key.toLowerCase(), value!);

                      await NotificationServices().cancelAll();

                      await homeController.setNotifications();
                    },
                  ),
                  Checkbox(
                    value: _iqamahTimes[time.key]!,
                    activeColor: primaryColor,
                    onChanged: (bool? value) async {
                      setState(() {
                        _iqamahTimes[time.key] = value!;
                      });

                      sharedPreferences!
                          .setBool(time.key.toLowerCase() + "Iqamah", value!);

                      await NotificationServices().cancelAll();

                      await homeController.setNotifications();
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("General Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SwitchListTile(
          activeColor: primaryColor,
          title: const Text("Event Notifications"),
          value: _eventNotificationsEnabled,
          onChanged: _toggleEventNotifications,
        ),
        SwitchListTile(
          activeColor: primaryColor,
          title: const Text("Announcement Notifications"),
          value: _announcementNotificationsEnabled,
          onChanged: _toggleAnnouncementNotifications,
        ),
      ],
    );
  }
}
