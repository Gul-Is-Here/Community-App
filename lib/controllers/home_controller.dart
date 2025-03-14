import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:alarm/alarm.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:community_islamic_app/controllers/prayerTimingsController.dart';
import 'package:community_islamic_app/model/prayer_times_model.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/prayer_model.dart';
import '../model/jumma_model.dart';
import '../model/prayer_times_static_model.dart';

import '../model/prayersmodel.dart';
import '../services/notification_service.dart';
import 'notificationEventandAnnouncemt_controller.dart';
import 'notification_handler_controller.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var prayerTime = Prayer(
    iqamahTimings: IqamahTimings(
      iqamahTimingId: 0,
      startDate: '',
      endDate: '',
      fajr: '',
      zuhr: '',
      asr: '',
      maghrib: '',
      isha: '',
    ),
    upcomingPrayerTimes: [],
    todayPrayerTime: PrayerTime(
      prayerTimesId: 0,
      date: '',
      fajr: '',
      sunrise: '',
      dhuhr: '',
      asr: '',
      sunset: '',
      maghrib: '',
      isha: '',
      hijriDayName: '',
      hijriDayDate: '',
      hijriMonth: '',
      hijriYear: '',
      gregorianDay: '',
      gregorianMonth: '',
      gregorianYear: '',
      jumuah: null,
    ),
  ).obs;

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
  PrayerTimesModels? prayerTimes;

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
    NotificationSettingsController().subscribeToDefaultTopics();

    await PrayerTimingController().fetchPrayerTimes();
    await setPrayerTimes();
    // getPrayers();
    // getPrayerTimesFromStorage();
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

  Future<void> setPrayerTimes() async {
    prayerTimes = await NotificationHandlerController().fetchPrayerTimes();

    if (prayerTimes != null) {
      await NotificationHandlerController()
          .schedulePrayerTime(prayerTimes: prayerTimes!);
    }
  }

  Future<void> startNextPrayerTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateTimeUntilNextPrayer(); // Update the countdown every second
      print('updating ------');
      getCurrentPhase();
      getNextPrayerTimeWithIqama();
      getCurrentPhase();
      heighlite.value = getCurrentPrayerForHeighlit();
      // getHeightliter();
    });
  }

  void updateTimeUntilNextPrayer() async {
    prayerTimes = await NotificationHandlerController().fetchPrayerTimes();
    final now = DateTime.now();
    final todayDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    var prayerData = PrayerTimingController().prayerData;
    print("🛠️ Full prayerData: $prayerData");

    if (prayerTimes == null || prayerTimes?.data?.prayerTime == null) {
      print("❌ Prayer times data is missing or not structured correctly!");
      return;
    }

    var todayTimings = prayerTimes?.data?.prayerTime;

    if (todayTimings == null) {
      print("❌ PrayerTime is missing or empty!");
      return;
    }

    try {
      print("✅ Today's prayer timings: $todayTimings");

      // Parse Azan timings
      final DateTime? fajrTime = todayTimings.fajr;
      final DateTime? dhuhrTime = todayTimings.dhuhr;
      final DateTime? asrTime = todayTimings.asr;
      final DateTime? maghribTime = todayTimings.maghrib;
      final DateTime? ishaTime = todayTimings.isha;

      // Parse Iqama timings
      final DateTime? fajrIqama = todayTimings.fajrIqamah;
      final DateTime? dhuhrIqama = todayTimings.duhurIqamah;
      final DateTime? asrIqama = todayTimings.asrIqamah;
      final DateTime? maghribIqama = todayTimings.maghribIqamah;
      final DateTime? ishaIqama = todayTimings.ishaIqamah;

      // Print parsed times for debugging
      print("🕰️ Parsed Times:");
      print("   Fajr: $fajrTime | Iqama: $fajrIqama");
      print("   Dhuhr: $dhuhrTime | Iqama: $dhuhrIqama");
      print("   Asr: $asrTime | Iqama: $asrIqama");
      print("   Maghrib: $maghribTime | Iqama: $maghribIqama");
      print("   Isha: $ishaTime | Iqama: $ishaIqama");

      // Combine Azan and Iqama times in order
      List<DateTime?> combinedTimes = [
        fajrTime,
        fajrIqama,
        dhuhrTime,
        dhuhrIqama,
        asrTime,
        asrIqama,
        maghribTime,
        maghribIqama,
        ishaTime,
        ishaIqama
      ];

      // Remove past times
      combinedTimes =
          combinedTimes.where((time) => time!.isAfter(now)).toList();

      if (combinedTimes.isEmpty) {
        print("⚠️ No valid upcoming prayer times found.");
        return;
      }

      // Sort times to ensure proper order
      combinedTimes.sort();

      // Find the next prayer or iqama time
      DateTime? nextTime = combinedTimes.first;

      print("⏳ Next prayer time: $nextTime");

      // Format the remaining time as HH:mm:ss
      final duration = nextTime?.difference(now);
      final String formattedTime =
          "${duration?.inHours.toString().padLeft(2, '0')}:${(duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

      // Update observable value (ensure it is RxString)
      timeUntilNextPrayer.value = formattedTime;
      print("✅ Updated timeUntilNextPrayer: $formattedTime");
    } catch (e) {
      print("❌ Error updating next prayer time: $e");
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}: ${minutes.toString().padLeft(2, '0')}: ${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> fetchPrayerTimes() async {
    const String apiUrl =
        'https://rosenbergcommunitycenter.org/api/IqamahandPrayertimesMobileAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332';

    try {
      print("Fetching prayer times from API...");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // 🔹 Debugging output
        print("API Response: $jsonResponse");

        if (jsonResponse.containsKey('data')) {
          dynamic data = jsonResponse['data'];

          // 🔹 Ensure `data` is a Map
          if (data is Map<String, dynamic>) {
            // 🔹 Fix the `Jumuah` field issue
            if (data.containsKey('PrayerTimingsUpcoming')) {
              List<dynamic> prayerTimes = data['PrayerTimingsUpcoming'];

              for (var prayer in prayerTimes) {
                if (prayer is Map<String, dynamic> &&
                    prayer.containsKey('Jumuah') &&
                    prayer['Jumuah'] is String &&
                    prayer['Jumuah'] == "") {
                  prayer['Jumuah'] =
                      null; // or use {} if you prefer an empty object
                }
              }
            }

            // Assuming `Prayer.fromJson()` handles the modified data correctly
            prayerTime.value = Prayer.fromJson(data);
            print("Prayer times updated successfully.");
          } else {
            print("Error: 'data' is not a valid JSON object.");
            throw FormatException("Invalid API response format.");
          }
        } else {
          print("Error: API response does not contain 'data' field.");
          throw FormatException("Invalid API response format.");
        }
      } else {
        throw HttpException(
            'Failed to load prayer times with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
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

  updateCurrentPrayer() {
    final now = DateTime.now();

    final todayString = "${now.day}/${now.month}";

    for (var timing in iqamahTiming) {
      if (_isDateInRange(todayString, timing.startDate, timing.endDate)) {
        if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
          final timings = prayerTime.value.todayPrayerTime;

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
            currentPrayerTitle.value = "Next: FAJR";
            return;
          }
          if (now.isBefore(fajrIqama)) {
            currentPrayerTitle.value = "FAJR";
            return;
          }

          if (now.isBefore(dhuhrTime)) {
            currentPrayerTitle.value = "Next: DHUHR";
            return;
          }
          if (now.isBefore(dhuhrIqama)) {
            currentPrayerTitle.value = "DHUHR";
            return;
          }

          if (now.isBefore(asrTime)) {
            currentPrayerTitle.value = "Next: ASR";
            return;
          }
          if (now.isBefore(asrIqama)) {
            currentPrayerTitle.value = "ASR";
            return;
          }

          if (now.isBefore(maghribTime)) {
            currentPrayerTitle.value = "Next: MAGHRIB";
            return;
          }
          if (now.isBefore(maghribIqama)) {
            currentPrayerTitle.value = "MAGHRIB";
            return;
          }

          if (now.isBefore(ishaTime)) {
            currentPrayerTitle.value = "Next: ISHA";
            return;
          }
          if (now.isBefore(ishaIqama)) {
            currentPrayerTitle.value = "ISHA";
            return;
          }

          // If all prayers for today have passed
          currentPrayerTitle.value = "Next: FAJR";
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
        if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
          final timings = prayerTime.value.todayPrayerTime;

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

    if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
      final timings = prayerTime.value.todayPrayerTime;
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
      return prayerTime.value.todayPrayerTime.fajr;
    } else if (currentPrayer.value == 'Dhuhr') {
      return prayerTime.value.todayPrayerTime.dhuhr;
    } else if (currentPrayer.value == 'Asr') {
      return prayerTime.value.todayPrayerTime.asr;
    } else if (currentPrayer.value == 'Maghrib') {
      return prayerTime.value.todayPrayerTime.maghrib;
    } else {
      return prayerTime.value.todayPrayerTime.isha;
    }
  }

// This Method is used to get Current Prayer
  String getCurrentPrayerTime() {
    final now = DateTime.now();
    final timeNow = DateFormat("HH:mm").format(now);
    final currentTime = DateFormat("HH:mm").parse(timeNow);

    if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
      final timings = prayerTime.value.todayPrayerTime;
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
    if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
      final timings = prayerTime.value.todayPrayerTime;

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
        if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
          final timings = prayerTime.value.todayPrayerTime;

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
        if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
          final timings = prayerTime.value.todayPrayerTime;

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
        if (prayerTime.value.todayPrayerTime.date.isNotEmpty) {
          final timings = prayerTime.value.todayPrayerTime;

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
