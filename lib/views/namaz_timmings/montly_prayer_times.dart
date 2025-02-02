import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/prayer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearlyNamazTimesScreen extends StatelessWidget {
  final PrayerController prayerController = Get.put(PrayerController());
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  YearlyNamazTimesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        title: const Text(
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
                          // style: TextStyle(color: primaryColor),
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
                              child: Text(
                                monthNames[index],
                                style: TextStyle(
                                    fontFamily: popinsMedium,
                                    color: whiteColor),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Obx(() => DropdownButton<String>(
                              dropdownColor: primaryColor,
                              iconEnabledColor: whiteColor,
                              value: prayerController.selectedDate.value.isEmpty
                                  ? null
                                  : prayerController.selectedDate.value
                                      .padLeft(2, '0'),
                              hint: Text(
                                "Select Date (optional)",
                                style: TextStyle(
                                    fontFamily: popinsRegulr,
                                    color: whiteColor),
                              ),
                              onChanged: (newValue) {
                                prayerController.selectedDate.value =
                                    newValue ?? '';
                              },
                              items: prayerController.filteredPrayerTimes
                                  .map((entry) {
                                String readableDate = entry['date']
                                    ['readable']; // Extract "01 Jan 2025"
                                String day = entry['date']['gregorian']['day']
                                    .toString()
                                    .padLeft(2, '0'); // "01"

                                return DropdownMenuItem(
                                  value: day,
                                  child: Text(
                                    readableDate, // Show full date e.g., "01 January 2025"
                                    style: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            )),
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
                    var timings = dayData['timings'];

                    return Card(
                      color: whiteColor,
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
                              dayData['date']['readable'],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            _buildPrayerTimeText(
                                AppClass().formatPrayerTime(timings['Fajr'])),
                            _buildPrayerTimeText(
                                AppClass().formatPrayerTime(timings['Dhuhr'])),
                            _buildPrayerTimeText(
                                AppClass().formatPrayerTime(timings['Asr'])),
                            _buildPrayerTimeText(AppClass()
                                .formatPrayerTime(timings['Maghrib'])),
                            _buildPrayerTimeText(
                                AppClass().formatPrayerTime(timings['Isha'])),
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
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "popinsSemiBold",
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
        fontFamily: "popinsRegular",
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black87,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/prayer_controller.dart';

// class YearlyNamazTimesScreen extends StatelessWidget {
//   final PrayerController prayerController = Get.put(PrayerController());
//   final List<String> monthNames = [
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December'
//   ];

//   YearlyNamazTimesScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Prayer Times')),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Obx(() => DropdownButton<String>(
//                   value: prayerController.selectedMonth.value,
//                   onChanged: (newValue) {
//                     if (newValue != null) {
//                       prayerController.selectedMonth.value = newValue;
//                       prayerController.selectedDate.value =
//                           ''; // Reset to full month view
//                     }
//                   },
//                   items: List.generate(12, (index) {
//                     return DropdownMenuItem(
//                       value: (index + 1).toString().padLeft(2, '0'),
//                       child: Text(monthNames[index]),
//                     );
//                   }),
//                 )),
//             const SizedBox(height: 10),
//             Obx(() => DropdownButton<String>(
//                   value: prayerController.selectedDate.value.isEmpty
//                       ? null
//                       : prayerController.selectedDate.value.padLeft(2, '0'),
//                   hint: const Text("Select Date (optional)"),
//                   onChanged: (newValue) {
//                     prayerController.selectedDate.value = newValue ?? '';
//                   },
//                   items: List.generate(31, (index) {
//                     return DropdownMenuItem(
//                       value: (index + 1).toString().padLeft(2, '0'),
//                       child: Text('Day ${index + 1}'),
//                     );
//                   }),
//                 )),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Obx(() {
//                 if (prayerController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 var filteredData = prayerController.filteredPrayerTimes;
//                 if (filteredData.isEmpty) {
//                   return const Center(
//                       child: Text('No data available',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)));
//                 }

//                 return ListView.builder(
//                   itemCount: filteredData.length,
//                   itemBuilder: (context, index) {
//                     var dayData = filteredData[index];
//                     var timings = dayData['timings'];

//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                       elevation: 5,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 5),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Date: ${dayData['date']['readable']}',
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blue)),
//                             const SizedBox(height: 10),
//                             ...timings.entries.map((e) => Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 4.0),
//                                   child: Text('${e.key}: ${e.value}',
//                                       style: const TextStyle(fontSize: 16)),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
