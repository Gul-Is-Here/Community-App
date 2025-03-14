import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/prayer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/myText.dart';

class YearlyNamazTimesScreen extends StatelessWidget {
  final PrayerController prayerController = Get.put(PrayerController());

  YearlyNamazTimesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        title: const MyText(
          'Yearly Prayer Times',
          style: TextStyle(fontFamily: popinsMedium, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          children: [
            // Month Selection Dropdown
            Obx(() => Container(
                  decoration: BoxDecoration(color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          iconEnabledColor: whiteColor,
                          dropdownColor: primaryColor,
                          value: prayerController.selectedMonth.value,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              prayerController.selectedMonth.value = newValue;
                              prayerController.selectedDate.value =
                                  ''; // Reset to full month view
                            }
                          },
                          items: List.generate(12, (index) {
                            return DropdownMenuItem(
                              value: (index + 1).toString().padLeft(2, '0'),
                              child: MyText(
                                prayerController.monthNames[index],
                                style: TextStyle(
                                    fontFamily: popinsMedium,
                                    color: whiteColor),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )),

            // Table Headers
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

            // Prayer Times List
            Expanded(
              child: Obx(() {
                if (prayerController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                var filteredData = prayerController.filteredPrayerTimes;
                if (filteredData.isEmpty) {
                  return const Center(
                      child: Text('No data available',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)));
                }

                return ListView.builder(
                  itemCount: filteredData.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    var dayData = filteredData[index];

                    return Card(
                      color: whiteColor,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPrayerTimeText(
                              dayData['GeorgeDay'],
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            _buildPrayerTimeText(dayData['Fajr']),
                            _buildPrayerTimeText(dayData['Dhuhr']),
                            _buildPrayerTimeText(dayData['Asr']),
                            _buildPrayerTimeText(dayData['Maghrib']),
                            _buildPrayerTimeText(dayData['Isha']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for header text styling
  Widget _buildHeaderText(String text) {
    return MyText(
      text,
      style: const TextStyle(
        fontFamily: popinsSemiBold,
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper widget for prayer time styling
  Widget _buildPrayerTimeText(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 11}) {
    return MyText(
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
