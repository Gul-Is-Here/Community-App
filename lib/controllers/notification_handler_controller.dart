import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_islamic_app/model/prayersmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHandlerController extends GetxController {
  static SharedPreferences? sharedPreferencess;
  Future<PrayerTimesModels?> fetchPrayerTimes() async {
    var url = Uri.parse(
        'https://rosenbergcommunitycenter.org/api/IqamahandPrayertimesMobileAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = prayerTimesModelFromJson(response.body);
      return data;
    } else {
      return null;
    }
  }

// Create Notification Method
  void createNotifications(
      {required String chnannelKey,
      required DateTime date,
      required String title,
      required String body,
      required int id}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          icon: 'resource://drawable/logo',
          largeIcon: 'resource://drawable/logo',
          id: id,
          channelKey: chnannelKey,
          actionType: ActionType.Default,
          title: title,
          body: body,
        ),
        actionButtons: [NotificationActionButton(key: 'mute', label: 'MUTE')],
        schedule: NotificationCalendar.fromDate(date: date));
  }

  Future<void> schedulePrayerTime(
      {required PrayerTimesModels prayerTimes}) async {
    sharedPreferencess ??= await SharedPreferences.getInstance();
    await AwesomeNotifications().cancelAll();
    // Prayer Times List
    var upCommingFajarTimes = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.fajr)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingDhuhrTimes = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.dhuhr)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingAsrTimes = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.asr)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingMaghribTimes = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.maghrib)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingIshaTimes = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.isha)
            .where((e) => e != null)
            .toList() ??
        [];

    // Prayer Times Iqamah List
    var upCommingFajarIqamah = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.fajrIqamah)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingDuhurIqamah = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.dhuhrIqamah)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingAsrIqamah = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.asrIqamah)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingMaghribIqamah = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.maghribIqamah)
            .where((e) => e != null)
            .toList() ??
        [];
    var upCommingIshaIqmah = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.ishaIqamah)
            .where((e) => e != null)
            .toList() ??
        [];

    // SunRise
    var upCommingSunRise = prayerTimes.data?.prayerTimingsUpcoming
            ?.map((e) => e.sunrise)
            .where((e) => e != null)
            .toList() ??
        [];
// Today Notification List

    var toDay = prayerTimes.data?.prayerTime;

    String sound = sharedPreferencess!.getString("selectedSound")!;

    // String sound = 'beep_channel';

// Prayer Notification Sxchedule

    if (toDay?.fajr != null &&
        (toDay?.fajr?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('fajr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable
              ? sound.contains('makkah_channel')
                  ? 'makkah_fajar_channel'
                  : sound.contains('madina_channel')
                      ? 'madina_fajar_channel'
                      : sound
              : 'disable_channel',
          date: toDay!.fajr!,
          title: 'ADHAN REMINDER',
          body: 'Its Fajr Adhan Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.dhuhr != null &&
        (toDay?.dhuhr?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('dhuhr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: toDay!.dhuhr!,
          title: 'ADHAN REMINDER',
          body: 'Its Dhuhr Adhan Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.asr != null && (toDay?.asr?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('asr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: toDay!.asr!,
          title: 'ADHAN REMINDER',
          body: 'Its Asr Adhan Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.maghrib != null &&
        (toDay?.maghrib?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('maghrib') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: toDay!.maghrib!,
          title: 'ADHAN REMINDER',
          body: 'Its Maghrib Adhan Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.isha != null &&
        (toDay?.isha?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('isha') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: toDay!.isha!,
          title: 'ADHAN REMINDER',
          body: 'Its Isha Adhan Time',
          id: Random().nextInt(999999));
    }

    // Todays Iqamah Time
    if (toDay?.fajrIqamah != null &&
        (toDay?.fajrIqamah?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('fajrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: toDay!.fajrIqamah!,
          title: 'IQAMAH REMINDER',
          body: 'Its Fajr Iqamah Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.duhurIqamah != null &&
        (toDay?.duhurIqamah?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('dhuhrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: toDay!.duhurIqamah!,
          title: 'IQAMAH REMINDER',
          body: 'Its Dhuhr Iqamah Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.asrIqamah != null &&
        (toDay?.asrIqamah?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('asrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: toDay!.asrIqamah!,
          title: 'IQAMAH REMINDER',
          body: 'Its Asr Iqamah Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.maghribIqamah != null &&
        (toDay?.maghribIqamah?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('maghribIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: toDay!.maghribIqamah!,
          title: 'IQAMAH REMINDER',
          body: 'Its Maghrib Iqamah Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.ishaIqamah != null &&
        (toDay?.ishaIqamah?.isAfter(DateTime.now()) ?? false)) {
      bool isNotDisable = sharedPreferencess!.getBool('ishaIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: toDay!.ishaIqamah!,
          title: 'IQAMAH REMINDER',
          body: 'Its Isha Iqamah Time',
          id: Random().nextInt(999999));
    }
    if (toDay?.sunrise != null &&
        (toDay?.sunrise?.isAfter(DateTime.now()) ?? false)) {
      createNotifications(
          chnannelKey: 'disable_channel',
          date: toDay!.ishaIqamah!,
          title: 'Sunrise',
          body: 'Sunrise Time',
          id: Random().nextInt(999999));
    }

    // UpComming Notifications Schedule
    for (var date in upCommingSunRise) {
      createNotifications(
          chnannelKey: 'disable_channel',
          date: date!,
          title: 'Sunrise',
          body: 'Its Time for Sunrise',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingFajarTimes) {
      bool isNotDisable = sharedPreferencess!.getBool('fajr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable
              ? sound.contains('makkah_channel')
                  ? 'makkah_fajar_channel'
                  : sound.contains('madina_channel')
                      ? 'madina_fajar_channel'
                      : sound
              : 'disable_channel',
          date: date!,
          title: 'ADHAN REMINDER',
          body: 'Its Fajr Adhan Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingDhuhrTimes) {
      bool isNotDisable = sharedPreferencess!.getBool('dhuhr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: date!,
          title: 'ADHAN REMINDER',
          body: 'Its Dhuhr Adhan Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingAsrTimes) {
      bool isNotDisable = sharedPreferencess!.getBool('asr') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: date!,
          title: 'ADHAN REMINDER',
          body: 'Its Asr Adhan Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingMaghribTimes) {
      bool isNotDisable = sharedPreferencess!.getBool('maghrib') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: date!,
          title: 'ADHAN REMINDER',
          body: 'Its Maghrib Adhan Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingIshaTimes) {
      bool isNotDisable = sharedPreferencess!.getBool('isha') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? sound : 'disable_channel',
          date: date!,
          title: 'ADHAN REMINDER',
          body: 'Its Isha Adhan Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingFajarIqamah) {
      bool isNotDisable = sharedPreferencess!.getBool('fajrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: date!,
          title: 'IQAMAH REMINDER',
          body: 'Its Fajr Iqamah Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingDuhurIqamah) {
      bool isNotDisable = sharedPreferencess!.getBool('dhuhrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: date!,
          title: 'IQAMAH REMINDER',
          body: 'Its Duhur Iqamah Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingAsrIqamah) {
      bool isNotDisable = sharedPreferencess!.getBool('asrIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: date!,
          title: 'IQAMAH REMINDER',
          body: 'Its Asr Iqamah Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingMaghribIqamah) {
      bool isNotDisable = sharedPreferencess!.getBool('maghribIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: date!,
          title: 'IQAMAH REMINDER',
          body: 'Its Maghrib Iqamah Time',
          id: Random().nextInt(999999));
    }
    for (var date in upCommingIshaIqmah) {
      bool isNotDisable = sharedPreferencess!.getBool('ishaIqamah') ?? false;
      createNotifications(
          chnannelKey: isNotDisable ? 'iqamah_channel' : 'disable_channel',
          date: date!,
          title: 'IQAMAH REMINDER',
          body: 'Its Isha Iqamah Time',
          id: Random().nextInt(999999));
    }
  }
}
