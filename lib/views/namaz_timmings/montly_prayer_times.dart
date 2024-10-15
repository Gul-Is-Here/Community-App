import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyNamazTimeScreen extends StatelessWidget {
  MonthlyNamazTimeScreen({super.key});
  final homeController = Get.find<HomeController>();

  // Helper method to get the number of days in the current month
  int getDaysInMonth(int year, int month) {
    // Use DateTime(year, month + 1, 0) to get the last day of the month
    var lastDayDateTime = DateTime(year, month + 1, 0);
    return lastDayDateTime.day;
  }

  @override
  Widget build(BuildContext context) {
    // Get current year and month
    DateTime now = DateTime.now();
    int daysInMonth = getDaysInMonth(now.year, now.month);

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
        backgroundColor: primaryColor,
        title: const Text(
          'Monthly Prayer Times',
          style: TextStyle(fontFamily: popinsSemiBold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Headers with prayer names
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderText('Date'),
                _buildHeaderText('Fajr'),
                _buildHeaderText('Dhuhr'),
                _buildHeaderText('Asr'),
                _buildHeaderText('Maghrib'),
                _buildHeaderText('Isha'),
              ],
            ),
          ),
          // List of prayer times
          Expanded(
            child: ListView.builder(
              itemCount:
                  daysInMonth, // Use dynamic itemCount based on the days in the current month
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPrayerTimeText(
                          homeController.prayerTimes!.data[index].date.readable,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        _buildPrayerTimeText(homeController.formatPrayerTime(
                            homeController
                                .prayerTimes!.data[index].timings.fajr)),
                        _buildPrayerTimeText(homeController.formatPrayerTime(
                            homeController
                                .prayerTimes!.data[index].timings.dhuhr)),
                        _buildPrayerTimeText(homeController.formatPrayerTime(
                            homeController
                                .prayerTimes!.data[index].timings.asr)),
                        _buildPrayerTimeText(homeController.formatPrayerTime(
                            homeController
                                .prayerTimes!.data[index].timings.maghrib)),
                        _buildPrayerTimeText(homeController.formatPrayerTime(
                            homeController
                                .prayerTimes!.data[index].timings.isha)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for header text styling
  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: popinsSemiBold,
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper widget for prayer time styling
  Widget _buildPrayerTimeText(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 12}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: popinsRegulr,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black87,
      ),
    );
  }
}
