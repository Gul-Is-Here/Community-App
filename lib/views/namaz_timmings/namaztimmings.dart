import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/controllers/prayerTimingsController.dart';
import 'package:community_islamic_app/model/prayersmodel.dart';
import 'package:community_islamic_app/views/namaz_timmings/iqama_chnage_timetbale.dart';
import 'package:community_islamic_app/views/namaz_timmings/montly_prayer_times.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:share/share.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/home_controller.dart';
import '../../model/prayer_times_static_model.dart';
import '../../constants/color.dart';
import '../../widgets/jumma_widget.dart';

class NamazTimingsScreen extends StatelessWidget {
  const NamazTimingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final prayerController = Get.put(PrayerTimingController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Prayer Timings',
          style: TextStyle(
            color: Colors.white,
            fontFamily: popinsSemiBold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                // Fetch the latest prayer times from the controller
                final prayerTimes = homeController.prayerTime.value;
                final timings = prayerTimes.todayPrayerTime;

                // Ensure that timings exist
                if (timings.date.isNotEmpty) {
                  final iqamaTimes = getAllIqamaTimes();
                  String shareContent =
                      generateShareContent(timings, iqamaTimes);

                  // Sharing the prayer times
                  await Share.share(shareContent, subject: 'Namaz Timings');
                } else {
                  Get.snackbar(
                    'Error',
                    'Prayer timings are not available.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                print("Error sharing prayer times: $e");
                Get.snackbar(
                  'Error',
                  'Failed to share prayer timings.',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.prayerTime.value.todayPrayerTime.date.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final timing = prayerController.prayerData['PrayerTime'];
        final sunrise = prayerController.prayerData['PrayerTime']['Sunrise'];
        final sunset = prayerController.prayerData['PrayerTime']['Sunset'];

        final currentPrayer = getCurrentPrayer(homeController);

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "Today's Prayer Timings",
              style: TextStyle(fontFamily: popinsSemiBold),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: whiteColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                color: primaryColor,
                                size: 24,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Sunrise',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: popinsSemiBold,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    sunrise,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontFamily: popinsRegulr,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: whiteColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                color: primaryColor,
                                size: 24,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Sunset',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: popinsSemiBold,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    sunset,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontFamily: popinsRegulr,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _buildPrayerTile('Fajr', timing == null ? '' : timing['Fajr'],
                timing == null ? '' : timing['FajrIqamah']!, currentPrayer),

            const SizedBox(
              height: 5,
            ),
            _buildPrayerTile(
                'Duhur',
                timing == null
                    ? '01:30 PM'
                    // ignore: prefer_if_null_operators
                    : timing['Dhuhr'] == null
                        ? '01:32 PM'
                        // ignore: prefer_if_null_operators

                        : timing['Dhuhr'],
                timing == null
                    ? '02:00 PM'
                    // ignore: prefer_if_null_operators
                    : timing['DuhurIqamah'] == null
                        ? '02:00 PM'
                        : timing['DuhurIqamah'],
                currentPrayer),

            const SizedBox(
              height: 5,
            ),
            _buildPrayerTile('Asr', timing == null ? '' : timing['Asr'],
                timing == null ? '' : timing['AsrIqamah']!, currentPrayer),
            const SizedBox(
              height: 5,
            ),
            _buildPrayerTile('Maghrib', timing == null ? '' : timing['Maghrib'],
                timing == null ? '' : timing['MaghribIqamah']!, currentPrayer),

            const SizedBox(
              height: 5,
            ),
            _buildPrayerTile('Fajr', timing == null ? '' : timing['Isha'],
                timing == null ? '' : timing['IshaIqamah']!, currentPrayer),

            // Jumma section
            const SizedBox(height: 20),
            const JummaPrayerTile(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Get.to(() => YearlyNamazTimesScreen());
                },
                child: Text(
                  'View Monthly Prayer Timings',
                  style: TextStyle(
                      fontFamily: popinsSemiBold, color: primaryColor),
                )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  Get.to(() => const IqamaChangeTimeTable());
                },
                child: Text(
                  'View Iqamah Change Time Table',
                  style: TextStyle(
                      fontFamily: popinsSemiBold, color: primaryColor),
                ))
          ],
        );
      }),
    );
  }

  /// Helper function to generate the share content
  String generateShareContent(dynamic timings, Map<String, String> iqamaTimes) {
    return '''
📿 *Today's Prayer Timings* 📿

🌅 Fajr: ${(timings.fajr)} | Iqamah: ${iqamaTimes['Fajr']}
🌞 Dhuhr: ${(timings.dhuhr)} | Iqamah: ${iqamaTimes['Dhuhr']}
🌥️ Asr: ${(timings.asr)} | Iqamah: ${iqamaTimes['Asr']}
🌇 Maghrib: ${(timings.maghrib)} | Iqamah: ${AppClass().calculateIqamaTime(timings.maghrib)}
🌌 Isha: ${(timings.isha)} | Iqamah: ${iqamaTimes['Isha']}

*Shared from Rosenberg Community Center App*
    ''';
  }

  Widget _buildPrayerTile(
      String title, String prayerTime, String iqamaTime, String currentPrayer) {
    bool isCurrent = title == currentPrayer;

    return Container(
      decoration: BoxDecoration(
        gradient: isCurrent
            ? LinearGradient(
                colors: [Colors.teal.shade100, Colors.teal.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prayer Icon
            Icon(
              Icons.access_time_filled,
              color: isCurrent ? Colors.teal : primaryColor,
              size: 24,
            ),

            const SizedBox(width: 10),

            // Prayer Title and Times
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prayer Title
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: popinsSemiBold,
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.teal.shade800 : primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Prayer Time
                  Expanded(
                    child: Text(
                      prayerTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontFamily: popinsRegulr,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Iqama Time
                  Expanded(
                    child: Text(
                      iqamaTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: popinsRegulr,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Current Prayer Indicator (Optional)
            if (isCurrent)
              const Icon(
                Icons.check_circle,
                color: Colors.teal,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // String formatPrayerTime(String prayerTime) {
  //   return DateFormat('h:mm a').format(DateFormat('HH:mm ').parse(prayerTime));
  // }

  Map<String, String> getAllIqamaTimes() {
    DateTime now = DateTime.now();
    String currentDateStr = DateFormat('d/M').format(now);
    DateTime currentDate = parseDate(currentDateStr);

    for (var timing in iqamahTiming) {
      DateTime startDate = parseDate(timing.startDate);
      DateTime endDate = parseDate(timing.endDate);

      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        return {
          'Fajr': timing.fjar,
          'Dhuhr': timing.zuhr,
          'Asr': timing.asr,
          'Maghrib':
              DateFormat("h:mm a").format(now.add(const Duration(minutes: 5))),
          'Isha': timing.isha,
        };
      }
    }

    return {
      'Fajr': 'Not available',
      'Dhuhr': 'Not available',
      'Asr': 'Not available',
      'Maghrib': 'Not available',
      'Isha': 'Not available',
    };
  }

  DateTime parseDate(String dateStr) {
    return DateFormat('d/M').parse(dateStr);
  }

  String getCurrentPrayer(HomeController homeController) {
    final now = DateTime.now();
    final timeNow =
        DateFormat("HH:mm").format(now); // Formatting the current time
    var newTime = DateFormat("HH:mm").parse(timeNow);

    if (homeController.prayerTime.value.todayPrayerTime.date.isNotEmpty) {
      final timings = homeController.prayerTime.value.todayPrayerTime;
      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      if (newTime.isBefore(fajrTime)) {
        return 'fajr';
      } else if (newTime.isBefore(dhuhrTime)) {
        return 'zuhr';
      } else if (newTime.isBefore(asrTime)) {
        return 'asr';
      } else if (newTime.isBefore(maghribTime)) {
        return 'maghrib';
      } else if (newTime.isBefore(ishaTime)) {
        return 'isha';
      } else {
        return 'fajr';
      }
    }
    return 'isha';
  }
}
