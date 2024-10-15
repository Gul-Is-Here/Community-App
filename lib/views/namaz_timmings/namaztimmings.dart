import 'package:community_islamic_app/views/namaz_timmings/iqama_chnage_timetbale.dart';
import 'package:community_islamic_app/views/namaz_timmings/montly_prayer_times.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controllers/home_controller.dart';
import '../../model/prayer_times_static_model.dart';
import '../../constants/color.dart';
import '../../widgets/jumma_widget.dart';

class NamazTimingsScreen extends StatelessWidget {
  const NamazTimingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
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
      ),
      body: Obx(() {
        if (homeController.prayerTime.value.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final timings = homeController.prayerTime.value.data!.timings;
        final sunrise = homeController.prayerTime.value.data!.timings.sunrise;
        final sunset = homeController.prayerTime.value.data!.timings.sunset;
        var iqamatimes = getAllIqamaTimes();
        final currentPrayer = getCurrentPrayer(homeController);

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              "Today's Prayer Timings",
              style: TextStyle(fontFamily: popinsSemiBold),
            ),
            5.heightBox,
            _buildPrayerTile(
                'Fajr', timings.fajr, iqamatimes['Fajr']!, currentPrayer),
            5.heightBox,
            _buildPrayerTile('Sunrise', sunrise, '', currentPrayer),
            5.heightBox,
            _buildPrayerTile(
                'Dhuhr', timings.dhuhr, iqamatimes['Dhuhr']!, currentPrayer),
            5.heightBox,
            _buildPrayerTile(
                'Asr', timings.asr, iqamatimes['Asr']!, currentPrayer),
            5.heightBox,
            _buildPrayerTile('Maghrib', timings.maghrib,
                _calculateIqamaTime(timings.maghrib), currentPrayer),

            5.heightBox,
            _buildPrayerTile('Sunset', sunset, '', currentPrayer),

            5.heightBox,
            _buildPrayerTile(
                'Isha', timings.isha, iqamatimes['Isha']!, currentPrayer),

            // Jumma section
            const SizedBox(height: 20),
            const JummaPrayerTile(),
            10.heightBox,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Get.to(() => MonthlyNamazTimeScreen());
                },
                child: Text(
                  'View Monthly Prayer Timings',
                  style: TextStyle(
                      fontFamily: popinsSemiBold, color: primaryColor),
                )),
            10.heightBox,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Get.to(() => IqamaChangeTimeTable());
                },
                child: Text(
                  'View Iqama Change Time Table',
                  style: TextStyle(
                      fontFamily: popinsSemiBold, color: primaryColor),
                ))
          ],
        );
      }),
    );
  }

  String _calculateIqamaTime(String maghribAzanTime) {
    DateTime maghribTime = DateFormat("HH:mm").parse(maghribAzanTime);
    DateTime iqamaTime = maghribTime.add(const Duration(minutes: 5));
    return DateFormat("hh:mm a").format(iqamaTime);
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
                      formatPrayerTime(prayerTime),
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

  String formatPrayerTime(String prayerTime) {
    return DateFormat('h:mm a').format(DateFormat('HH:mm').parse(prayerTime));
  }

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

    if (homeController.prayerTime.value.data?.timings != null) {
      final timings = homeController.prayerTime.value.data!.timings;
      final fajrTime = DateFormat("HH:mm").parse(timings.fajr);
      final dhuhrTime = DateFormat("HH:mm").parse(timings.dhuhr);
      final asrTime = DateFormat("HH:mm").parse(timings.asr);
      final maghribTime = DateFormat("HH:mm").parse(timings.maghrib);
      final ishaTime = DateFormat("HH:mm").parse(timings.isha);

      if (newTime.isBefore(fajrTime)) {
        return 'Fajr';
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
}

String formatPrayerTime(String prayerTime) {
  return DateFormat('h:mm a').format(DateFormat('HH:mm').parse(prayerTime));
}
