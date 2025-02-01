import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _eventNotificationsEnabled = false;
  bool _announcementNotificationsEnabled = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
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
                    title: Text('Event Notifications'),
                    subtitle: Text('Enable or disable event notifications'),
                    value: _eventNotificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _eventNotificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Announcement Notifications'),
                    subtitle:
                        Text('Enable or disable announcement notifications'),
                    value: _announcementNotificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _announcementNotificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Manage your notification preferences here. Toggle the switches to enable or disable specific types of notifications.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}