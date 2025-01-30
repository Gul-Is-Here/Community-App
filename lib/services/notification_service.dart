import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static SharedPreferences? sharedPreferencess;

  Future<void> createPrayerNotificationChannels() async {
    AndroidFlutterLocalNotificationsPlugin? plugin =
        _flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    List<AndroidNotificationChannel> channels = [
      const AndroidNotificationChannel(
        'makkah_channel',
        'Makkah Notifications',
        description:
            'This channel is used for prayer notifications with makhah azan.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound("azan"),
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'madina_channel',
        'Madina Notifications',
        description:
            'This channel is used for prayer notifications with madina azan.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound("azanmadina"),
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'iqamah_channel',
        'Iqamah Notifications',
        description: 'This channel is used for Iqamah notifications.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound("iqamah"),
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description:
            'This channel is used for prayer notifications with Default sound.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound("beep"),
        playSound: true,
      ),
      const AndroidNotificationChannel(
        'disable_channel',
        'Disable Notifications',
        description:
            'This channel is used for prayer notifications with sound disabled.',
        importance: Importance.low,
        sound: null,
        playSound: false,
      ),
      const AndroidNotificationChannel(
        'events_channel',
        'Events Notifications',
        description: 'This channel is used for events and announcements .',
        importance: Importance.max,
        sound: null,
        playSound: false,
      ),
      const AndroidNotificationChannel(
        'announcement_channel',
        'Announcement Notifications',
        description: 'This channel is used for events and announcements .',
        importance: Importance.max,
        sound: null,
        playSound: false,
      ),
    ];

    for (var channel in channels) {
      await plugin?.createNotificationChannel(channel);
    }
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationPlugin.cancelAll();
  }

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
        if (response.actionId == "muteButton") {
          _flutterLocalNotificationPlugin.cancel(response.id ?? 0);
        }
      },
    );

    await _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    await _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();

    sharedPreferencess = await SharedPreferences.getInstance();

    List<AndroidNotificationChannel>? channelList =
        await _flutterLocalNotificationPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .getNotificationChannels();

    if (channelList == null || channelList.isEmpty) {
      await createPrayerNotificationChannels();
    }

    List<PendingNotificationRequest> pending =
        await _flutterLocalNotificationPlugin.pendingNotificationRequests();

    if (pending.isNotEmpty) {
      for (int i = 0; i < pending.length; i++) {
        debugPrint("Pending Not ${pending[i].body}");
      }
    }
  }

  NotificationDetails notificationDetails({required String title}) {
    String sound = sharedPreferencess!.getString("selectedSound")!;

    // Handle Iqamah notifications separately
    if (title.contains("Iqamah")) {
      sound = 'iqamah';
    } else {
      // Handle Adhan notifications
      sound = sound == 'Adhan - Makkah'
          ? "makkah"
          : sound == 'Adhan - Madina'
              ? "madina"
              : sound.toLowerCase();
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        sound == "disable" || sharedPreferencess!.getBool(title)!
            ? "${sound}_channel"
            : "default_channel",
        sound == "disable" || sharedPreferencess!.getBool(title)!
            ? "${sound.capitalizeFirst} Notifications"
            : 'Default Notifications',
        importance: sound == "disable" ? Importance.low : Importance.max,
        playSound:
            !(sharedPreferencess!.getString("selectedSound")! == "disable"),
        priority: Priority.high,
        sound: sound == 'iqamah'
            ? const RawResourceAndroidNotificationSound('iqamah')
            : sharedPreferencess!.getBool(title)!
                ? sharedPreferencess!.getString("selectedSound")! == "Disable"
                    ? null
                    : RawResourceAndroidNotificationSound(
                        sharedPreferencess!.getString("selectedSound")! ==
                                "Adhan - Makkah"
                            ? 'azan'
                            : sharedPreferencess!.getString("selectedSound")! ==
                                    "Adhan - Madina"
                                ? 'azanmadina'
                                : "beep")
                : const RawResourceAndroidNotificationSound('beep'),
        actions: [
          const AndroidNotificationAction("muteButton", "Mute"),
        ],
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  int getDayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }

  Future scheduleNotificationForAdhan({
    String title = "ATHAN REMINDER",
    String? body,
    required String payLoad,
    required DateTime scheduleNotificationDateTime,
  }) async {
    debugPrint(
      "Scheduling Notification for $payLoad Will run at ${scheduleNotificationDateTime.day}-${scheduleNotificationDateTime.month} ${scheduleNotificationDateTime.hour} : ${scheduleNotificationDateTime.minute}",
    );

    int flag = 0;

    if (payLoad == "fajr") {
      flag = 1;
    }

    if (payLoad == "dhuhr") {
      flag = 2;
    }

    if (payLoad == "asr") {
      flag = 3;
    }

    if (payLoad == "maghrib") {
      flag = 4;
    }

    if (payLoad == "isha") {
      flag = 5;
    }

    if (payLoad == "fajrIqamah") {
      flag = 6;
    }

    if (payLoad == "dhuhrIqamah") {
      flag = 7;
    }

    if (payLoad == "asrIqamah") {
      flag = 8;
    }

    if (payLoad == "maghribIqamah") {
      flag = 9;
    }

    if (payLoad == "ishaIqamah") {
      flag = 10;
    }

    int dayOfYear = getDayOfYear(scheduleNotificationDateTime);

    int uniqueId = dayOfYear * 10 + flag;

    await _flutterLocalNotificationPlugin.zonedSchedule(
      uniqueId,
      title,
      body,
      tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
      notificationDetails(
        title: payLoad,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint(
      "this is here",
    );
  }

  /// -------- Announcements------------------
  Future<void> notifcationsForAnnouncements(
    RemoteMessage message,
  ) async {
    if (sharedPreferencess?.getBool('annoucement') ?? false) {
      await _flutterLocalNotificationPlugin.show(
        1,
        message.notification?.title ?? 'Announcement Notification',
        message.notification?.body ?? 'This is Announcement Notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'announcement_channel',
            'Announcement Notifications',
            importance: Importance.max,
            playSound: false,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
    debugPrint(
      "this is here",
    );
  }

  ///------------ Events-----------
  Future<void> notifcationsForEvents(
    RemoteMessage message,
  ) async {
    if (sharedPreferencess?.getBool('event') ?? false) {
      await _flutterLocalNotificationPlugin.show(
        1,
        message.notification?.title ?? 'Event Notification',
        message.notification?.body ?? 'This is Event Notification',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'events_channel',
            'Events Notifications',
            importance: Importance.max,
            playSound: false,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }
}
