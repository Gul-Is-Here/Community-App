import 'package:community_islamic_app/views/qibla_screen/qibla_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/color.dart';
import '../../model/prayer_times_static_model.dart';

class IqamaChangeTimeTable extends StatelessWidget {
  const IqamaChangeTimeTable({super.key});

  // Helper method to get the number of days in the current month
  int getDaysInMonth(int year, int month) {
    // Use DateTime(year, month + 1, 0) to get the last day of the month
    var lastDayDateTime = DateTime(year, month + 1, 0);
    return lastDayDateTime.day;
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Iqama Change Times",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
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
                // _buildHeaderText('Dhuhr'),
                _buildHeaderText('Asr'),
                // _buildHeaderText('Maghrib'),
                _buildHeaderText('Isha'),
              ],
            ),
          ),
          // List of iqama change times
          Expanded(
            child: ListView.builder(
              itemCount: iqamahTimings.length, // Dynamically set itemCount
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final timing = iqamahTimings[index];
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
                        _buildPrayerTimeText(formatDate(timing.startDate),
                            fontSize: 11, fontWeight: FontWeight.bold),
                        _buildPrayerTimeText(timing.fjar),
                        // _buildPrayerTimeText(timing.zuhr),
                        _buildPrayerTimeText(timing.asr),
                        // _buildPrayerTimeText(timing.magrib),
                        _buildPrayerTimeText(timing.isha),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          10.heightBox,
          Card(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dhuhr',
                          style: TextStyle(fontFamily: popinsSemiBold),
                        ),
                        Text(
                          'Iqama Time Always 2:00 PM',
                          style: TextStyle(fontFamily: popinsSemiBold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Magrib',
                          style: TextStyle(fontFamily: popinsSemiBold),
                        ),
                        Text(
                          'Sunset + 5 min',
                          style: TextStyle(fontFamily: popinsSemiBold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
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

  String formatDate(String date) {
    final parts = date.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    return "${day} ${getMonthName(month)}";
  }

  String getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }
}
