import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerController extends GetxController {
  var prayerTimes = [].obs;
  var selectedMonth = ''.obs;
  var selectedDate = ''.obs;
  var isLoading = false.obs;

  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void onInit() {
    super.onInit();
    selectedMonth.value = DateTime.now().month.toString().padLeft(2, '0'); // Default to current month
    selectedDate.value = ''; // Show full month initially
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://rosenbergcommunitycenter.org/api/IqamahandPrayertimesYearlyMobileAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is Map && data['data'].containsKey('PrayerTimingsUpcoming')) {
          List<dynamic> extractedData = data['data']['PrayerTimingsUpcoming'];
          prayerTimes.assignAll(extractedData);
        } else {
          throw Exception('Unexpected data format: "PrayerTimingsUpcoming" not found');
        }
      } else {
        throw Exception('Failed to load prayer times (Status: ${response.statusCode})');
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Filtered list based on month & date
  List<dynamic> get filteredPrayerTimes {
    return prayerTimes.where((entry) {
      String month = entry['GeorgeMonth'];
      String day = entry['GeorgeDay'].toString().padLeft(2, '0');

      bool monthMatches = monthNames.indexOf(month) + 1 == int.parse(selectedMonth.value);
      bool dateMatches = selectedDate.value.isEmpty || day == selectedDate.value;

      return monthMatches && dateMatches;
    }).toList();
  }
}
