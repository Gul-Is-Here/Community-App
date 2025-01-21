import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReminderUtil {
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification response
      },
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

    final tz.TZDateTime tzReminderDateTime = tz.TZDateTime.from(
      reminderDateTime,
      tz.local,
    );

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'event_reminders',
      'Event Reminders',
      channelDescription: 'Reminders for upcoming events',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Use eventId as notification ID to uniquely identify each reminder
    await flutterLocalNotificationsPlugin.zonedSchedule(
      eventId.hashCode, // Unique ID for the notification
      title,
      details,
      tzReminderDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Save the reminder to local storage
    await saveReminderToStorage(eventId, reminderDateTime);
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
    await flutterLocalNotificationsPlugin.cancel(eventId.hashCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(eventId); // Remove the saved reminder from storage
  }

  static Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved reminders
  }
}
