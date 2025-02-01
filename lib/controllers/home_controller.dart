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
  var timmngs = ''.obs;
  var jummaTimes = Jumma().obs;
  var isLoading = true.obs;
  RxString heighlite = ''.obs;
  RxString currentTime = ''.obs;
  int storeMonthPrayerTimes = 0;
  var prayerTimess;
  var currentPrayerTitle =
      ''.obs; // Reactive variable to store the current prayer
  var currentPrayerTimes = ''.obs;
  var currentPrayerIqama = ''.obs;
  RxString currentPrayerHeighliter = ''.obs;

  String? currentPrayerTime;
  PrayerTimesModel? prayerTimes;
  // var currentIqamaTime;
  late NotchBottomBarController notchBottomBarController;

  // ignore: prefer_typing_uninitialized_variables
  var adjustment;
  var timeUntilNextPrayer = ''.obs; // Observable for remaining time

  final NotificationServices _notificationServices = NotificationServices();
  Timer? _timer;

  @override
  void onInit() async {
    super.onInit();
    notchBottomBarController =
        NotchBottomBarController(index: selectedIndex.value);
    updateCurrentTime();
    notchBottomBarController =
        NotchBottomBarController(index: selectedIndex.value);
    fetchJummaTimes();
    fetchPrayerTimes();
    getPrayers();
    getPrayerTimesFromStorage();
    startNextPrayerTimer(); // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateCurrentPrayer();
      updateCurrentTime();

      getNextPrayerTimeWithIqama();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> startNextPrayerTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateTimeUntilNextPrayer(); // Update the countdown every second
      getCurrentPhase();
      getNextPrayerTimeWithIqama();
      getCurrentPhase();
      heighlite.value = getCurrentPrayerForHeighlit();
      // getHeightliter();
    });
  }

  void updateTimeUntilNextPrayer() {
    final now = DateTime.now();

    // Ensure prayer times are properly adjusted with today's date
    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      // Parse Azan timings
      final fajrTime = parseTimeWithDate("${timings.fajr} AM", now);
      final dhuhrTime = parseTimeWithDate("${timings.dhuhr} PM", now);
      final asrTime = parseTimeWithDate("${timings.asr} PM", now);
      final maghribTime = parseTimeWithDate(timings.maghrib, now);
      final ishaTime = parseTimeWithDate("${timings.isha} PM", now);

      // Locate Iqama timings from iqamahTiming
      final iqamaTiming = iqamahTiming.firstWhere(
        (timing) {
          final startDate = DateFormat("d/M").parse(timing.startDate);
          final endDate = DateFormat("d/M").parse(timing.endDate);

          return now.isAtSameMomentAs(startDate) ||
              (now.isAfter(startDate) && now.isBefore(endDate)) ||
              now.isAtSameMomentAs(endDate);
        },
        orElse: () {
          return iqamahTiming.first; // Fallback to the first timing
        },
      );

      // Parse Iqama timings
      final fajrIqama = parseTimeWithDate(iqamaTiming.fjar, now);
      final dhuhrIqama = parseTimeWithDate(iqamaTiming.zuhr, now);
      final asrIqama = parseTimeWithDate(iqamaTiming.asr, now);
      final maghribIqama = maghribTime
          .add(const Duration(minutes: 5)); // Maghrib Iqama = Azan + 5 minutes
      final ishaIqama = parseTimeWithDate(iqamaTiming.isha, now);

      // Combine Azan and Iqama times in order
      List<DateTime> combinedTimes = [
        fajrTime,
        fajrIqama,
        dhuhrTime,
        dhuhrIqama,
        asrTime,
        asrIqama,
        maghribTime,
        maghribIqama,
        ishaTime,
        ishaIqama,
      ];

      // Find the next prayer or iqama time
      DateTime? nextTime;
      for (var time in combinedTimes) {
        if (time.isAfter(now)) {
          nextTime = time;
          break;
        }
      }

      // If no future time found, set the first Azan of the next day as the next time
      nextTime ??= fajrTime.add(const Duration(days: 1));

      // Calculate the remaining time
      final difference = nextTime.difference(now);

      // Update observable value
      timeUntilNextPrayer.value = formatDuration(difference);
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}: ${minutes.toString().padLeft(2, '0')}: ${seconds.toString().padLeft(2, '0')}';
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

      StaticPrayarTime iqamahTime = iqamahTimings.firstWhere(
        (val) {
          DateTime iqamahStart = val.getDate();

          return now.month == iqamahStart.month && now.day >= iqamahStart.day;
        },
      );

      for (Datum data in prayerTimes!.data) {
        DateTime fajrDateTime = prayerTimes!.getDateTime(
          data.timings.fajr,
          data.date.readable,
        );

        DateTime fajrDateTimeIqamah =
            iqamahTime.getNamazTime("fajr", fajrDateTime);

        if (fajrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "Its Fajr Athan Time",
            scheduleNotificationDateTime: fajrDateTime,
            payLoad: "fajr",
          );
        }

        if (fajrDateTimeIqamah.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            title: "IQAMAH REMINDER",
            body: "Its Fajr Iqamah Time",
            scheduleNotificationDateTime: fajrDateTimeIqamah,
            payLoad: "fajrIqamah",
          );
        }

        DateTime dhuhrDateTime = prayerTimes!.getDateTime(
          data.timings.dhuhr,
          data.date.readable,
        );

        DateTime dhuhrDateTimeIqamah =
            iqamahTime.getNamazTime("dhuhr", dhuhrDateTime);

        if (dhuhrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "Its Zuhr Athan Time",
            scheduleNotificationDateTime: dhuhrDateTime,
            payLoad: "dhuhr",
          );
        }

        if (dhuhrDateTimeIqamah.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            title: "IQAMAH REMINDER",
            body: "Its Zuhr Iqamah Time",
            scheduleNotificationDateTime: dhuhrDateTimeIqamah,
            payLoad: "dhuhrIqamah",
          );
        }

        DateTime asrDateTime = prayerTimes!.getDateTime(
          data.timings.asr,
          data.date.readable,
        );

        DateTime asrDateTimeIqamah =
            iqamahTime.getNamazTime("asr", asrDateTime);

        if (asrDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "Its Asr Athan Time",
            scheduleNotificationDateTime: asrDateTime,
            payLoad: "asr",
          );
        }

        if (asrDateTimeIqamah.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            title: "IQAMAH REMINDER",
            body: "Its Asr Iqamah Time",
            scheduleNotificationDateTime: asrDateTimeIqamah,
            payLoad: "asrIqamah",
          );
        }

        DateTime maghribDateTime = prayerTimes!.getDateTime(
          data.timings.maghrib,
          data.date.readable,
        );

        DateTime maghribDateTimeIqamah = maghribDateTime.add(
          const Duration(minutes: 5),
        );

        if (maghribDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "Its Maghrib Athan Time",
            scheduleNotificationDateTime: maghribDateTime,
            payLoad: "maghrib",
          );
        }

        if (maghribDateTimeIqamah.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            title: "IQAMAH REMINDER",
            body: "Its Maghrib Iqamah Time",
            scheduleNotificationDateTime: maghribDateTimeIqamah,
            payLoad: "maghribIqamah",
          );
        }

        DateTime ishaDateTime = prayerTimes!.getDateTime(
          data.timings.isha,
          data.date.readable,
        );

        DateTime ishaDateTimeIqamah =
            iqamahTime.getNamazTime("isha", ishaDateTime);

        if (ishaDateTime.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            body: "Its Isha Athan Time",
            scheduleNotificationDateTime: ishaDateTime,
            payLoad: "isha",
          );
        }

        if (ishaDateTimeIqamah.isAfter(now)) {
          await _notificationServices.scheduleNotificationForAdhan(
            title: "IQAMAH REMINDER",
            body: "Its Isha Iqamah Time",
            scheduleNotificationDateTime: ishaDateTimeIqamah,
            payLoad: "ishaIqamah",
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
    } else {
      // No prayer times found in storage
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

  void updateCurrentPrayer() {
    final now = DateTime.now();

    final todayString = "${now.day}/${now.month}";

    for (var timing in iqamahTiming) {
      if (_isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.data?.timings != null) {
          final timings = prayerTime.value.data!.timings;

          // Parse Azan timings from API
          final fajrTime = parseTimeWithDate(timings.fajr, now);
          final dhuhrTime = parseTimeWithDate(timings.dhuhr, now);
          final asrTime = parseTimeWithDate(timings.asr, now);
          final maghribTime = parseTimeWithDate(timings.maghrib, now);
          final ishaTime = parseTimeWithDate(timings.isha, now);

          // Parse Iqama timings from static list
          final fajrIqama = parseTimeWithDate(timing.fjar, now);
          final dhuhrIqama = parseTimeWithDate(timing.zuhr, now);
          final asrIqama = parseTimeWithDate(timing.asr, now);
          final maghribIqama = maghribTime.add(const Duration(minutes: 5));
          final ishaIqama = parseTimeWithDate(timing.isha, now);

          // Determine the current or next prayer
          if (now.isBefore(fajrTime)) {
            currentPrayerTitle.value = "Next: Fajr";
            return;
          }
          if (now.isBefore(fajrIqama)) {
            currentPrayerTitle.value = "Fajr";
            return;
          }

          if (now.isBefore(dhuhrTime)) {
            currentPrayerTitle.value = "Next: Dhuhr";
            return;
          }
          if (now.isBefore(dhuhrIqama)) {
            currentPrayerTitle.value = "Dhuhr";
            return;
          }

          if (now.isBefore(asrTime)) {
            currentPrayerTitle.value = "Next: Asr";
            return;
          }
          if (now.isBefore(asrIqama)) {
            currentPrayerTitle.value = "Asr";
            return;
          }

          if (now.isBefore(maghribTime)) {
            currentPrayerTitle.value = "Next: Maghrib";
            return;
          }
          if (now.isBefore(maghribIqama)) {
            currentPrayerTitle.value = "Maghrib";
            return;
          }

          if (now.isBefore(ishaTime)) {
            currentPrayerTitle.value = "Next: Isha";
            return;
          }
          if (now.isBefore(ishaIqama)) {
            currentPrayerTitle.value = "Isha";
            return;
          }

          // If all prayers for today have passed
          currentPrayerTitle.value = "Next: Fajr";
          return;
        }
      }
    }

    // Default if no timings match
    currentPrayerTitle.value = " ";
  }

  RxString getCurrentPrayer() {
    final now = DateTime.now();
    final todayString = "${now.day}/${now.month}";

    for (var timing in iqamahTiming) {
      if (_isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.data?.timings != null) {
          final timings = prayerTime.value.data!.timings;

          // Parse Azan timings from API
          final fajrTime = parseTimeWithDate(timings.fajr, now);
          final dhuhrTime = parseTimeWithDate(timings.dhuhr, now);
          final asrTime = parseTimeWithDate(timings.asr, now);
          final maghribTime = parseTimeWithDate(timings.maghrib, now);
          final ishaTime = parseTimeWithDate(timings.isha, now);

          // Parse Iqama timings from static list
          final fajrIqama = parseTimeWithDate(timing.fjar, now);
          final dhuhrIqama = parseTimeWithDate(timing.zuhr, now);
          final asrIqama = parseTimeWithDate(timing.asr, now);
          final maghribIqama = maghribTime.add(
              const Duration(minutes: 5)); // Maghrib Iqama = Azan + 5 minutes
          final ishaIqama = parseTimeWithDate(timing.isha, now);
          if (now.isBefore(fajrTime)) {
            return "Next: Fajr".obs;
          }
          if (now.isBefore(fajrIqama)) {
            return "Iqama: Fajr".obs;
          }

          // Check for Dhuhr
          if (now.isBefore(dhuhrTime)) {
            return "Next: Dhuhr".obs;
          }
          if (now.isBefore(dhuhrIqama)) {
            return "Iqama: Dhuhr".obs;
          }

          // Check for Asr
          if (now.isBefore(asrTime)) {
            // print('Asr Namaz Time : $asrTime');
            return "Next: Asr".obs;
          }
          if (now.isBefore(asrIqama)) {
            // print('asr Iqama Time : $asrIqama');
            return "Iqama: Asr".obs;
          }

          // Check for Maghrib
          if (now.isBefore(maghribTime)) {
            // print('Maghribjr Namaz Time : $maghribTime');
            return "Next: Maghrib".obs;
          }
          if (now.isBefore(maghribIqama)) {
            // print('Maghrib iqama Time: $maghribIqama');
            return "Iqama: Maghrib".obs;
          }

          // Check for Isha
          if (now.isBefore(ishaTime)) {
            // print('isha Namaz Time : $ishaTime');
            return "Next: Isha".obs;
          }
          if (now.isBefore(ishaIqama)) {
            // print('Isha Iqama Time : $ishaIqama');
            return "Iqama: Isha".obs;
          }

          // All prayers for today have passed; show next day's Fajr
          return "Next: Fajr".obs;
        }
      }
    }

    return "".obs;
  }

  String getCurrentPrayerCurrent() {
    final now = DateTime.now();
    final timeNow = DateFormat("HH:mm").format(now);
    final currentTime = DateFormat("HH:mm").parse(timeNow);

    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      // Check which prayer is current based on time ranges
      if (currentTime.isAfter(fajrTime) && currentTime.isBefore(dhuhrTime)) {
        return 'Fajr';
      } else if (currentTime.isAfter(dhuhrTime) &&
          currentTime.isBefore(asrTime)) {
        return 'Dhuhr';
      } else if (currentTime.isAfter(asrTime) &&
          currentTime.isBefore(maghribTime)) {
        return 'Asr';
      } else if (currentTime.isAfter(maghribTime) &&
          currentTime.isBefore(ishaTime)) {
        return 'Maghrib';
      } else if (currentTime.isAfter(ishaTime) ||
          currentTime.isBefore(fajrTime)) {
        return 'Isha';
      }
    }

    // Default value if timings are null or no prayer matches
    return 'Fajr';
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
        RxString currentPrayer = getCurrentPrayer();

        switch (currentPrayer.value) {
          case 'Fajr':
            return timing.fjar;
          case 'Dhuhr':
            // Ensure that Zuhr time is always in PM format
            String zuhrTime = timing.zuhr.contains('AM') ||
                    timing.zuhr.contains('PM')
                ? timing.zuhr
                : "${timing.zuhr} PM"; // Append "PM" if not already specified

            // Parse and format Zuhr time with "PM"
            DateTime parsedZuhrTime = DateFormat("h:mm a").parse(zuhrTime);
            return DateFormat("h:mm a")
                .format(parsedZuhrTime); // Format with AM/PM
          case 'Asr':
            return timing.asr;
          case 'Maghrib':
            final maghribTime = now.add(const Duration(minutes: 5));
            return DateFormat("h:mm a").format(maghribTime);
          case 'Isha':
            return timing.isha;
          default:
            return "Invalid";
        }
      }
    }
    return "";
  }

  // Function to parse a date string in "d/M" format to DateTime
  DateTime parseDate(String dateStr) {
    return DateFormat('d/M').parse(dateStr);
  }

  // Function to get prayer times
  Object? getPrayerTimes() {
    RxString currentPrayer = getCurrentPrayer();
    if (currentPrayer.value == 'Fajr') {
      return prayerTime.value.data?.timings.fajr;
    } else if (currentPrayer.value == 'Dhuhr') {
      return prayerTime.value.data?.timings.dhuhr;
    } else if (currentPrayer.value == 'Asr') {
      return prayerTime.value.data?.timings.asr;
    } else if (currentPrayer.value == 'Maghrib') {
      return prayerTime.value.data?.timings.maghrib;
    } else {
      return prayerTime.value.data?.timings.isha;
    }
  }

// This Method is used to get Current Prayer
  String getCurrentPrayerTime() {
    final now = DateTime.now();
    final timeNow = DateFormat("HH:mm").format(now);
    final currentTime = DateFormat("HH:mm").parse(timeNow);

    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      if (currentTime.isAfter(fajrTime) && currentTime.isBefore(dhuhrTime)) {
        return DateFormat("hh:mm ").format(fajrTime);
      } else if (currentTime.isAfter(dhuhrTime) &&
          currentTime.isBefore(asrTime)) {
        return DateFormat("hh:mm").format(dhuhrTime);
      } else if (currentTime.isAfter(asrTime) &&
          currentTime.isBefore(maghribTime)) {
        return DateFormat("hh:mm").format(asrTime);
      } else if (currentTime.isAfter(maghribTime) &&
          currentTime.isBefore(ishaTime)) {
        return DateFormat("hh:mm").format(maghribTime);
      } else if (currentTime.isAfter(ishaTime) ||
          currentTime.isBefore(fajrTime)) {
        return DateFormat("hh:mm").format(ishaTime);
      }
    }

    return '6:30';
  }

  String formateAMandPM(DateTime prayerTime, bool isFajr) {
    // Format time as hh:mm AM/PM
    String formattedTime = DateFormat("hh:mm a").format(prayerTime);

    if (isFajr) {
      // For Fajr, ensure it shows AM even if it's after midnight
      formattedTime = formattedTime.replaceAll('PM', 'AM');
    }

    return formattedTime;
  }

  String getNextPrayerTime() {
    final now = DateTime.now();
    final timeNow = DateFormat("HH:mm").format(now);
    final currentTime = DateFormat("HH:mm").parse(timeNow);

    if (prayerTime.value.data?.timings != null) {
      final timings = prayerTime.value.data!.timings;

      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      if (currentTime.isBefore(fajrTime)) {
        return DateFormat("hh:mm").format(fajrTime);
      } else if (currentTime.isBefore(dhuhrTime)) {
        return DateFormat("hh:mm").format(dhuhrTime);
      } else if (currentTime.isBefore(asrTime)) {
        return DateFormat("hh:mm a").format(asrTime);
      } else if (currentTime.isBefore(maghribTime)) {
        return DateFormat("hh:mm").format(maghribTime);
      } else if (currentTime.isBefore(ishaTime)) {
        return DateFormat("hh:mm").format(ishaTime);
      } else {
        return DateFormat("hh:mm").format(fajrTime); // The next day's Fajr time
      }
    }

    return 'Fajr';
  }

  // Function to format prayer time
  String formatPrayerTime(String time) {
    try {
      // Parsing the input time string in "HH:mm:ss" format
      final dateTime = DateFormat("HH:mm").parse(time);
      // Formatting the time in "h:mm:ss a" format to include seconds and AM/PM
      return DateFormat("h:mm a").format(dateTime);
    } catch (e) {
      // If parsing fails, return the original input time
      return time;
    }
  }

  // Method to update current time
  void updateCurrentTime() {
    final now = DateTime.now();
    currentTime.value = getCurrentFormattedTime(now); // Pass DateTime object
  }

  String getCurrentFormattedTime(DateTime now) {
    // Formatting the current time to "h:mm:ss a" format
    return DateFormat('h:mm:s a').format(now);
  }

  // Method to format the Duration into a string "HH:mm:ss"
  String formatDurationRemaing(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    // Return formatted string in "HH:mm:ss" format
    return "$hours:$minutes:$seconds";
  }

  String formatPrayerTimeToAmPm(String time) {
    try {
      // Parse the input time from "HH:mm" format (24-hour format)
      final dateTime = DateFormat("HH:mm").parse(time);

      // Format it to "hh:mm a" (12-hour format with AM/PM)
      String formattedTime = DateFormat("hh:mm a").format(dateTime);

      return formattedTime;
    } catch (e) {
      return 'Invalid time'; // Return a default message for invalid input
    }
  }

  void getNextPrayerTimeWithIqama() {
    final now = DateTime.now();
    final todayString = "${now.day}/${now.month}";

    for (var timing in iqamahTiming) {
      if (_isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.data?.timings != null) {
          final timings = prayerTime.value.data!.timings;

          // Parse Azan timings from API
          final fajrTime = parseTimeWithDate(timings.fajr, now);
          final dhuhrTime = parseTimeWithDate(timings.dhuhr, now);
          final asrTime = parseTimeWithDate(timings.asr, now);
          final maghribTime = parseTimeWithDate(timings.maghrib, now);
          final ishaTime = parseTimeWithDate(timings.isha, now);

          // Parse Iqama timings from static list
          final fajrIqama = parseTimeWithDate(timing.fjar, now);
          final dhuhrIqama = parseTimeWithDate(timing.zuhr, now);
          final asrIqama = parseTimeWithDate(timing.asr, now);
          final maghribIqama =
              maghribTime.add(const Duration(minutes: 5)); // Azan + 5 minutes
          final ishaIqama = parseTimeWithDate(timing.isha, now);

          // Check timings for the current day
          if (now.isBefore(fajrTime)) {
            currentPrayerTimes.value = _formatTime(fajrTime);
            return;
          }
          if (now.isBefore(fajrIqama)) {
            currentPrayerTimes.value = _formatTime(fajrIqama);
            return;
          }

          if (now.isBefore(dhuhrTime)) {
            currentPrayerTimes.value = _formatTime(dhuhrTime);
            return;
          }
          if (now.isBefore(dhuhrIqama)) {
            currentPrayerTimes.value = _formatTime(dhuhrIqama);
            return;
          }

          if (now.isBefore(asrTime)) {
            currentPrayerTimes.value = _formatTime(asrTime);
            return;
          }
          if (now.isBefore(asrIqama)) {
            currentPrayerTimes.value = _formatTime(asrIqama);
            return;
          }

          if (now.isBefore(maghribTime)) {
            currentPrayerTimes.value = _formatTime(maghribTime);
            return;
          }
          if (now.isBefore(maghribIqama)) {
            currentPrayerTimes.value = _formatTime(maghribIqama);
            return;
          }

          if (now.isBefore(ishaTime)) {
            currentPrayerTimes.value = _formatTime(ishaTime);
            return;
          }
          if (now.isBefore(ishaIqama)) {
            currentPrayerTimes.value = _formatTime(ishaIqama);
            return;
          }

          // All prayers for today have passed; calculate next day's Fajr
          final tomorrow = now.add(const Duration(days: 1));
          final nextFajrTime = parseTimeWithDate(timings.fajr, tomorrow);
          currentPrayerTimes.value = _formatTime(nextFajrTime);
          return;
        }
      }
    }

    // Default if no timings match
    currentPrayerTimes.value = "No Data Available";
  }

// Helper function to parse time with today's date
  DateTime parseTimeWithDate(String timeString, DateTime referenceDate) {
    try {
      final format24Hour = DateFormat("HH:mm");
      final format12Hour = DateFormat("hh:mm a");

      DateTime parsedTime;
      if (timeString.contains("AM") || timeString.contains("PM")) {
        parsedTime = format12Hour.parse(timeString);
      } else {
        parsedTime = format24Hour.parse(timeString);
      }

      return DateTime(referenceDate.year, referenceDate.month,
          referenceDate.day, parsedTime.hour, parsedTime.minute);
    } catch (e) {
      return referenceDate;
    }
  }

// Helper function to format DateTime to a string
  String _formatTime(DateTime dateTime) {
    final format = DateFormat("hh:mm");
    return format.format(dateTime);
  }

// Helper function to check if today falls in the given date range
  bool _isDateInRange(String today, String start, String end) {
    final format = DateFormat("d/M");
    final todayDate = format.parse(today);
    final startDate = format.parse(start);
    final endDate = format.parse(end);

    return todayDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        todayDate.isBefore(endDate.add(const Duration(days: 1)));
  }

  // Getting azan time and Iqama Time Text
  void getCurrentPhase() {
    final now = DateTime.now();
    final todayString = "${now.day}/${now.month}";
    for (var timing in iqamahTiming) {
      // print(
      //     "Checking range: ${timing.startDate} - ${timing.endDate}"); // Log date ranges
      if (_isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.data?.timings != null) {
          final timings = prayerTime.value.data!.timings;

          // Parse Azan timings
          final fajrTime = parseTimeWithDate(timings.fajr, now);
          final dhuhrTime = parseTimeWithDate(timings.dhuhr, now);
          final asrTime = parseTimeWithDate(timings.asr, now);
          final maghribTime = parseTimeWithDate(timings.maghrib, now);
          final ishaTime = parseTimeWithDate(timings.isha, now);

          // Parse Iqama timings
          final fajrIqama = parseTimeWithDate(timing.fjar, now);
          final dhuhrIqama = parseTimeWithDate(timing.zuhr, now);
          final asrIqama = parseTimeWithDate(timing.asr, now);
          final maghribIqama = maghribTime.add(const Duration(minutes: 5));
          final ishaIqama = parseTimeWithDate(timing.isha, now);

          // Log parsed times for debugging

          // Determine the next prayer time
          if (now.isBefore(fajrTime)) {
            currentPrayerIqama.value = "Adhan Time";
            return;
          } else if (now.isBefore(fajrIqama)) {
            currentPrayerIqama.value = "Iqamah Time";
            return;
          } else if (now.isBefore(dhuhrTime)) {
            currentPrayerIqama.value = "Adhan Time";
            return;
          } else if (now.isBefore(dhuhrIqama)) {
            currentPrayerIqama.value = "Iqamah Time";
            return;
          } else if (now.isBefore(asrTime)) {
            currentPrayerIqama.value = "Adhan Time";
            return;
          } else if (now.isBefore(asrIqama)) {
            currentPrayerIqama.value = "Iqamah Time";
            return;
          } else if (now.isBefore(maghribTime)) {
            currentPrayerIqama.value = "Adhan Time";
            return;
          } else if (now.isBefore(maghribIqama)) {
            currentPrayerIqama.value = "Iqamah Time";
            return;
          } else if (now.isBefore(ishaTime)) {
            currentPrayerIqama.value = "Adhan Time";
            return;
          } else if (now.isBefore(ishaIqama)) {
            currentPrayerIqama.value = "Iqamah Time";
            return;
          } else {
            // If all prayers for today have passed, calculate the next day's Fajr
            final tomorrow = now.add(const Duration(days: 1));
            parseTimeWithDate(timings.fajr, tomorrow);

            currentPrayerIqama.value = "Adhan Time";
            return;
          }
        } else {
          currentPrayerIqama.value = "";
          return;
        }
      }
    }

    currentPrayerIqama.value = "";
  }

  bool isDateInRange(String today, String start, String end) {
    final format = DateFormat("d/M");
    final todayDate = format.parse(today);
    final startDate = format.parse(start);
    final endDate = format.parse(end);

    return todayDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        todayDate.isBefore(endDate.add(const Duration(days: 1)));
  }

  String getCurrentPrayerForHeighlit() {
    final now = DateTime.now();
    final todayString = "${now.day}/${now.month}";

    for (var timing in iqamahTiming) {
      if (isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.data?.timings != null) {
          final timings = prayerTime.value.data!.timings;

          // Parse Azan timings from API
          final fajrTime = parseTimeWithDate("${timings.fajr} AM", now);
          final dhuhrTime = parseTimeWithDate("${timings.dhuhr} PM", now);
          final asrTime = parseTimeWithDate("${timings.asr} PM", now);
          final maghribTime = parseTimeWithDate("${timings.maghrib}", now);
          final ishaTime = parseTimeWithDate("${timings.isha} PM", now);

          // Parse Iqama timings from static list
          final fajrIqama = parseTimeWithDate(timing.fjar, now);
          final dhuhrIqama = parseTimeWithDate(timing.zuhr, now);
          final asrIqama = parseTimeWithDate(timing.asr, now);
          final maghribIqama = maghribTime.add(
              const Duration(minutes: 1)); // Maghrib Iqama = Azan + 5 minutes
          final ishaIqama = parseTimeWithDate(timing.isha, now);

          // Check for Fajr
          if (now.isBefore(fajrTime)) {
            // print('Fajr Namaz Time : $fajrTime');
            return "Fajr";
          }
          if (now.isBefore(fajrIqama)) {
            // print('Fajr Iqama Time : $fajrIqama');
            return "Fajr";
          }

          // Check for Dhuhr
          if (now.isBefore(dhuhrTime)) {
            return 'Dhuhr';
          }
          if (now.isBefore(dhuhrIqama)) {
            // print('Dhuhr Iqama Time : $dhuhrIqama');
            return 'Dhuhr';
          }

          // Check for Asr
          if (now.isBefore(asrTime)) {
            // print('Asr Namaz Time : $asrTime');
            return 'Asr';
          }
          if (now.isBefore(asrIqama)) {
            // print('Asr Iqama Time : $asrIqama');
            return 'Asr';
          }

          // Check for Maghrib
          if (now.isBefore(maghribTime)) {
            // print('Maghrib Namaz Time : $maghribTime');
            return "Maghrib";
          }
          if (now.isBefore(maghribIqama)) {
            // print('Maghrib Iqama Time: $maghribIqama');
            return "Maghrib";
          }

          // Check for Isha
          if (now.isBefore(ishaTime)) {
            // print('Isha Namaz Time : $ishaTime');
            return "Isha";
          }
          if (now.isBefore(ishaIqama)) {
            // print('Isha Iqama Time : $ishaIqama');
            return "Isha";
          }

          // All prayers for today have passed; show next day's Fajr Azan
          fajrTime.add(const Duration(days: 1));
          // print("Next Day Fajr: ${_formatTime(nextDayFajr)}");
          return "Fajr";
        }
      }
    }

    // Default to Fajr if no timings match
    return "Fajr";
  }
}
