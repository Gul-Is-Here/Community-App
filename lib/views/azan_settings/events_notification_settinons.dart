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
  bool _eventNotificationsEnabled = false;
  bool _announcementNotificationsEnabled = false;
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _eventNotificationsEnabled = prefs.getBool('event') ?? false;
      _announcementNotificationsEnabled = prefs.getBool('annoucement') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('event', _eventNotificationsEnabled);
    await prefs.setBool('annoucement', _announcementNotificationsEnabled);
  }

  void _toggleEventNotifications(bool value) async {
    setState(() {
      _eventNotificationsEnabled = value;
    });
    await _saveSettings();

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
    await _saveSettings();

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
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            )),
        title: Text(
          'Notification Settings',
          style: TextStyle(fontFamily: popinsMedium, color: whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text(
                      'Event Notifications',
                      style: TextStyle(fontFamily: popinsRegulr),
                    ),
                    subtitle: const Text(
                        'Enable or disable event notifications',
                        style: TextStyle(fontFamily: popinsRegulr)),
                    value: _eventNotificationsEnabled,
                    onChanged: _toggleEventNotifications,
                  ),
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Announcement Notifications',
                        style: TextStyle(fontFamily: popinsRegulr)),
                    subtitle: const Text(
                        'Enable or disable announcement notifications',
                        style: TextStyle(fontFamily: popinsRegulr)),
                    value: _announcementNotificationsEnabled,
                    onChanged: _toggleAnnouncementNotifications,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Manage your notification preferences here. Toggle the switches to enable or disable specific types of notifications.',
              style: TextStyle(color: Colors.grey, fontFamily: popinsRegulr),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
