import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/allEvents.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/announcements_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  static SharedPreferences? sharedPreferencess;

  void initializeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/logo',
      _notificationChannels(),
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "📩 Foreground notification received: \${message.notification?.title}");
      handleForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🏁 Notification Clicked: \${message.notification?.title}");
      handleNotificationNavigation(message.data['type'] ?? "");
    });
  }

  List<NotificationChannel> _notificationChannels() {
    return [
      NotificationChannel(
        channelKey: 'announcement_channel',
        channelName: 'Announcements',
        channelDescription: 'Notification channel for announcements',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        playSound: true,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'events_channel',
        channelName: 'Events',
        channelDescription: 'Notification channel for events',
        defaultColor: Colors.green,
        ledColor: Colors.green,
        playSound: true,
        importance: NotificationImportance.High,
      ),
    ];
  }

  void handleForegroundNotification(RemoteMessage message) {
    if (message.notification != null) {
      int notificationId = message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(100000);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          largeIcon: 'resource://drawable/logo',
          id: notificationId,
          channelKey: _getChannelKey(message),
          title: message.notification!.title,
          body: message.notification!.body,
          notificationLayout: NotificationLayout.Default,
          payload: {"type": message.data['type'] ?? ""},
        ),
      );
    }
  }

  String _getChannelKey(RemoteMessage message) {
    if (message.data['type'] == "Alert") {
      return 'announcement_channel';
    } else if (message.data['type'] == "Events") {
      return 'events_channel';
    }
    return 'events_channel';
  }

  Future<void> notificationsForAnnouncements(RemoteMessage message) async {
    if (sharedPreferencess?.getBool('annoucement') ?? false) {
      int notificationId = message.messageId?.hashCode ?? 1;
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'announcement_channel',
          title: '📢 ANNOUNCEMENT NOTIFICATION',
          body: message.notification?.body ??
              'This is an Announcement Notification',
          notificationLayout: NotificationLayout.Default,
          payload: {"type": "Alert"},
        ),
      );
    }
    debugPrint("Announcement notification sent.");
  }

  Future<void> notificationsForEvents(RemoteMessage message) async {
    if (sharedPreferencess?.getBool('event') ?? false) {
      int notificationId = message.messageId?.hashCode ?? 2;
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'events_channel',
          title: '🎉 EVENT NOTIFICATION',
          body: message.notification?.body ?? 'This is an Event Notification',
          notificationLayout: NotificationLayout.Default,
          payload: {"type": "Events"},
        ),
      );
    }
    debugPrint("Event notification sent.");
  }
}

void handleNotificationNavigation(String payload) {
  debugPrint("Received Payload: \$payload");

  if (payload == "Alert") {
    debugPrint("Navigating to AnnouncementsScreen");
    Get.offAll(() => AnnouncementsScreen());
  } else if (payload == "Events") {
    debugPrint("Navigating to AllEventsDatesScreen");
    Get.offAll(() => AllEventsDatesScreen());
  } else {
    debugPrint("Unknown Payload: \$payload");
  }
}
