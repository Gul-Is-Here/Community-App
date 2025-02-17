import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _eventNotificationsEnabled = true;
  bool _announcementNotificationsEnabled = true;

  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _subscribeToDefaultTopics();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _eventNotificationsEnabled = prefs.getBool('Events') ?? true;
      _announcementNotificationsEnabled = prefs.getBool('Alert') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Events', _eventNotificationsEnabled);
    await prefs.setBool('Alert', _announcementNotificationsEnabled);
  }

  Future<void> _subscribeToDefaultTopics() async {
    await FirebaseMessaging.instance.subscribeToTopic('Events');
    await FirebaseMessaging.instance.subscribeToTopic('Alert');
  }

  void _toggleEventNotifications(bool value) async {
    setState(() {
      _eventNotificationsEnabled = value;
    });
    await _saveSettings();

    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('Events');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('Events');
    }
  }

  void _toggleAnnouncementNotifications(bool value) async {
    setState(() {
      _announcementNotificationsEnabled = value;
    });
    await _saveSettings();

    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('Alert');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('Alert');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 20,
            )),
        title: Text(
          'Notification Settings',
          style: TextStyle(
              fontFamily: popinsSemiBold, color: whiteColor, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: whiteColor,
              elevation: 4.0,
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text(
                      'Event Notifications',
                      style: TextStyle(fontFamily: popinsMedium, fontSize: 14),
                    ),
                    subtitle: const Text(
                        'Enable or disable event notifications',
                        style:
                            TextStyle(fontFamily: popinsRegulr, fontSize: 12)),
                    value: _eventNotificationsEnabled,
                    onChanged: _toggleEventNotifications,
                  ),
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Announcement Notifications',
                        style:
                            TextStyle(fontFamily: popinsMedium, fontSize: 14)),
                    subtitle: const Text(
                        'Enable or disable announcement notifications',
                        style:
                            TextStyle(fontFamily: popinsRegulr, fontSize: 12)),
                    value: _announcementNotificationsEnabled,
                    onChanged: _toggleAnnouncementNotifications,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Manage your notification preferences here. Toggle the switches to enable or disable specific types of notifications.',
              style: TextStyle(
                  color: Colors.grey, fontFamily: popinsRegulr, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
