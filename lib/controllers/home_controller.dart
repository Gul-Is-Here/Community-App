import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:alarm/alarm.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:community_islamic_app/model/prayer_times_model.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/prayer_model.dart';
import '../model/jumma_model.dart';
import '../model/prayer_times_static_model.dart';

import '../services/notification_service.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var prayerTime = Prayer().obs;
  var timePrayer = ''.obs;
  var jummaTimes = Jumma().obs;
  var isLoading = true.obs;
  int storeMonthPrayerTimes = 0;
  var prayerTimess;
  String? currentPrayerTime;
  PrayerTimesModel? prayerTimes;
  var currentIqamaTime;
  late NotchBottomBarController notchBottomBarController;

  var adjustment;
  var timeUntilNextPrayer = ''.obs; // Observable for remaining time

  final NotificationServices _notificationServices = NotificationServices();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    notchBottomBarController =
        NotchBottomBarController(index: selectedIndex.value);
    fetchJummaTimes();
    fetchPrayerTimes();
    getPrayers();
    getPrayerTimesFromStorage();
    startNextPrayerTimer(); // Start the countdown timer
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> startNextPrayerTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateTimeUntilNextPrayer(); // Update the countdown every second
    });
  }

  void updateTimeUntilNextPrayer() {
    final now = DateTime.now();

    // Ensure prayer times are properly adjusted with today's date
    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      // Parse the prayer times and combine them with today's date
      List<DateTime> prayerTimes = [
        DateTime(
            now.year,
            now.month,
            now.day,
            DateFormat("HH:mm").parse(timings.fajr).hour,
            DateFormat("HH:mm").parse(timings.fajr).minute),
        DateTime(
            now.year,
            now.month,
            now.day,
            DateFormat("HH:mm").parse(timings.dhuhr).hour,
            DateFormat("HH:mm").parse(timings.dhuhr).minute),
        DateTime(
            now.year,
            now.month,
            now.day,
            DateFormat("HH:mm").parse(timings.asr).hour,
            DateFormat("HH:mm").parse(timings.asr).minute),
        DateTime(
            now.year,
            now.month,
            now.day,
            DateFormat("HH:mm").parse(timings.maghrib).hour,
            DateFormat("HH:mm").parse(timings.maghrib).minute),
        DateTime(
            now.year,
            now.month,
            now.day,
            DateFormat("HH:mm").parse(timings.isha).hour,
            DateFormat("HH:mm").parse(timings.isha).minute),
      ];

      // Find the next prayer time
      DateTime? nextPrayerTime;
      for (var prayer in prayerTimes) {
        if (prayer.isAfter(now)) {
          nextPrayerTime = prayer;
          break;
        }
      }

      // If no future prayer found, set Fajr of the next day as the next prayer
      nextPrayerTime ??= prayerTimes.first.add(Duration(days: 1));

      // Calculate the remaining time for the next prayer
      final difference = nextPrayerTime.difference(now);
      timeUntilNextPrayer.value =
          formatDuration(difference); // Update observable value
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }

  Future<void> getPrayers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("prayerTimes")) {
      String jsonString = sharedPreferences.getString("prayerTimes")!;
      prayerTimes = prayerTimesFromJson(jsonString);
    } else {
      await getPrayerTimesFromNetwork();
      await setNotifications();
    }
  }

  Future<void> setNotifications() async {
    if (prayerTimes != null) {
      DateTime now = DateTime.now();

      for (Datum data in prayerTimes!.data) {
        DateTime fajrDateTime = prayerTimes!.getDateTime(
          data.timings.fajr,
          data.date.readable,
        );

        if (fajrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "It's Fajr time now",
            scheduleNotificationDateTime: fajrDateTime,
            payLoad: "fajr",
          );
        }

        DateTime dhuhrDateTime = prayerTimes!.getDateTime(
          data.timings.dhuhr,
          data.date.readable,
        );

        if (dhuhrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "It's Dhuhr time now",
            scheduleNotificationDateTime: dhuhrDateTime,
            payLoad: "dhuhr",
          );
        }

        DateTime asrDateTime = prayerTimes!.getDateTime(
          data.timings.asr,
          data.date.readable,
        );

        if (asrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "It's Asr time now",
            scheduleNotificationDateTime: asrDateTime,
            payLoad: "asr",
          );
        }

        DateTime maghribDateTime = prayerTimes!.getDateTime(
          data.timings.maghrib,
          data.date.readable,
        );

        if (maghribDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "It's Maghrib time now",
            scheduleNotificationDateTime: maghribDateTime,
            payLoad: "maghrib",
          );
        }

        DateTime ishaDateTime = prayerTimes!.getDateTime(
          data.timings.isha,
          data.date.readable,
        );

        if (ishaDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "It's Isha time now",
            scheduleNotificationDateTime: ishaDateTime,
            payLoad: "isha",
          );
        }
      }
    }
  }

  Future<void> getPrayerTimesFromNetwork() async {
    DateTime dateTime = DateTime.now();
    final url = Uri.parse(
      "https://api.aladhan.com/v1/calendarByCity/${dateTime.year}/${dateTime.month}?city=Sugar+Land&country=USA",
    );

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setString(
        "prayerTimes",
        response.body,
      );

      sharedPreferences.setInt(
        "prayerTimesMonth",
        dateTime.month,
      );

      prayerTimes = prayerTimesFromJson(
        response.body,
      );
    }
  }

  // get STored Prayer Times
  Future<void> getPrayerTimesFromStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Check if prayer times exist in SharedPreferences
    String? storedPrayerTimes = sharedPreferences.getString("prayerTimes");
    int? storedMonth = sharedPreferences.getInt("prayerTimesMonth");

    if (storedPrayerTimes != null && storedMonth != null) {
      // Prayer times and month are available in storage
      prayerTimess = prayerTimesFromJson(storedPrayerTimes);

      storeMonthPrayerTimes = storedMonth;

      print(
          "Prayer times loaded from SharedPreferences for month: $storeMonthPrayerTimes");
    } else {
      // No prayer times found in storage
      print("No stored prayer times found. Fetching from network...");
      await getPrayerTimesFromNetwork(); // Fetch from network if not found locally
    }
  }

  Future<void> fetchPrayerTimes() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/timingsByCity?city=Sugar+Land&country=USA&adjustment=$adjustment',
        ),
      );

      if (response.statusCode == 200) {
        prayerTime.value = Prayer.fromJson(json.decode(response.body));
      } else {
        throw HttpException(
            'Failed to load prayer times with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
      Get.snackbar('Error',
          'Failed to load prayer times. Please check your internet connection.');
    }
  }

  Future<void> fetchJummaTimes() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
          'https://rosenbergcommunitycenter.org/api/prayerconfig?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        jummaTimes.value = Jumma.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load prayer times');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load prayer times');
    } finally {
      isLoading(false);
    }
  }

  bool isTimeForPrayer(DateTime now, DateTime prayerTime) {
    return now.hour == prayerTime.hour &&
        now.minute == prayerTime.minute &&
        now.second == 0;
  }

  void changePage(int index) {
    selectedIndex.value = index;
    notchBottomBarController.jumpTo(index);
  }

  String formatTime(String time) {
    final dateFormat = DateFormat("HH:mm");
    final timeFormat = DateFormat("h:mm a");
    return timeFormat.format(dateFormat.parse(time));
  }

  DateTime parseTime(String time) {
    return DateFormat("HH:mm").parse(time).toLocal();
  }

  // void stopAzan() {
  //   _notificationServices.stopAzan();
  // }

  String getCurrentPrayer() {
    final now = DateTime.now();
    final timeNow = DateFormat("HH:mm").format(now);
    var newTime = DateFormat("HH:mm").parse(timeNow);
    print('New Time $newTime');

    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      if (newTime.isBefore(fajrTime)) {
        return newTime.isAfter(ishaTime) ? 'Isha' : 'Fajr';
      } else if (newTime.isBefore(dhuhrTime)) {
        return 'Dhuhr';
      } else if (newTime.isBefore(asrTime)) {
        return 'Asr';
      } else if (newTime.isBefore(maghribTime)) {
        return 'Maghrib';
      } else if (newTime.isBefore(ishaTime)) {
        return 'Isha';
      } else {
        return 'Fajr';
      }
    }
    return 'Isha';
  }

  // Function to find the current Iqama timings based on the current prayer time
  String getCurrentIqamaTime() {
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('d/M').format(now);
    DateTime currentDate = parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = parseDate(timing.startDate);
      DateTime endDate = parseDate(timing.endDate);

      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        String currentPrayer = getCurrentPrayer();

        switch (currentPrayer) {
          case 'Fajr':
            return timing.fjar;
          case 'Dhuhr':
            return timing.zuhr;
          case 'Asr':
            return timing.asr;
          case 'Maghrib':
            final maghribTime = now.add(const Duration(minutes: 5));
            return DateFormat("h:mm a").format(maghribTime);
          case 'Isha':
            return timing.isha;
          default:
            return "Invalid prayer time";
        }
      }
    }
    return "Iqama time not found";
  }

  // Function to parse a date string in "d/M" format to DateTime
  DateTime parseDate(String dateStr) {
    return DateFormat('d/M').parse(dateStr);
  }

  // Function to get prayer times
  Object? getPrayerTimes() {
    String currentPrayer = getCurrentPrayer();
    if (currentPrayer == 'Fajr') {
      return prayerTime.value.data?.timings.fajr;
    } else if (currentPrayer == 'Dhuhr') {
      return prayerTime.value.data?.timings.dhuhr;
    } else if (currentPrayer == 'Asr') {
      return prayerTime.value.data?.timings.asr;
    } else if (currentPrayer == 'Maghrib') {
      return prayerTime.value.data?.timings.maghrib;
    } else {
      return prayerTime.value.data?.timings.isha;
    }
  }

  // Function to format prayer time
  String formatPrayerTime(String time) {
    try {
      final dateTime = DateFormat("HH:mm").parse(time);
      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      return time;
    }
  }
}
