import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderUtil {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/logo', // Use app icon for notifications
      [
        NotificationChannel(
          channelKey: 'event_reminders',
          channelName: 'Event Reminders',
          channelDescription: 'Reminders for upcoming events',
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          defaultColor: primaryColor,
          ledColor: Colors.white,
        ),
      ],
      debug: true,
    );
  }

  static Future<void> setReminder({
    required String eventId, // Unique identifier for each event
    required String title,
    required String details,
    required DateTime reminderDateTime,
  }) async {
    if (reminderDateTime.isBefore(DateTime.now())) {
      throw Exception('Reminder time has already passed.');
    }

    // Convert the DateTime to TZ format
    final tz.TZDateTime tzReminderDateTime = tz.TZDateTime.from(
      reminderDateTime,
      tz.local,
    );

    // Schedule the notification
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar.fromDate(
        date: tzReminderDateTime,
        preciseAlarm: true, // Ensures it fires exactly at the time
      ),
      content: NotificationContent(
        id: eventId.hashCode, // Unique ID based on event
        channelKey: 'event_reminders',
        title: title,
        body: details,
        notificationLayout: NotificationLayout.Default,
        payload: {"eventId": eventId},
      ),
    );

    // Save the reminder locally
    await saveReminderToStorage(eventId, reminderDateTime);

    print("Reminder set for $title at $reminderDateTime");
  }

  static Future<void> saveReminderToStorage(String eventId, DateTime reminderDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(eventId, reminderDateTime.toIso8601String());
  }

  static Future<DateTime?> loadReminderFromStorage(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final reminderString = prefs.getString(eventId);
    if (reminderString != null) {
      return DateTime.parse(reminderString);
    }
    return null;
  }

  static Future<void> cancelReminder(String eventId) async {
    await AwesomeNotifications().cancel(eventId.hashCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(eventId); // Remove from storage
    print("Reminder canceled for Event ID: $eventId");
  }

  static Future<void> cancelAllReminders() async {
    await AwesomeNotifications().cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all reminders
    print("All reminders have been canceled.");
  }
}
