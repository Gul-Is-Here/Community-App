import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerController extends GetxController {
  var prayerTimes = [].obs;
  var selectedMonth = ''.obs;
  var selectedDate = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedMonth.value = DateTime.now().month.toString().padLeft(2, '0'); // Format month as "01", "02"
    selectedDate.value = ''; // Default to show the full month
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/calendarByCity/2025?city=Sugar+Land&country=USA'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debug: Print the full API response
        print("API Response: ${jsonEncode(data)}");

        if (data.containsKey('data') && data['data'] is Map) {
          List<dynamic> extractedData = [];

          // Extract each day's prayer times into a list
          data['data'].forEach((day, value) {
            if (value is List) {
              extractedData.addAll(value);
            }
          });

          prayerTimes.assignAll(extractedData);
          print("Extracted Prayer Times: ${jsonEncode(prayerTimes)}");
        } else {
          throw Exception('Unexpected data format: "data" is not a map');
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

  // Fix Filtering Logic
  List<dynamic> get filteredPrayerTimes {
    var filteredList = prayerTimes.where((entry) {
      // Extract month and day with correct formatting
      String month = entry['date']['gregorian']['month']['number'].toString().padLeft(2, '0');
      String day = entry['date']['gregorian']['day'].toString().padLeft(2, '0');

      bool monthMatches = month == selectedMonth.value;
      bool dateMatches = selectedDate.value.isEmpty || day == selectedDate.value;

      return monthMatches && dateMatches;
    }).toList();

    // Debug: Print what data is being filtered
    print("Filtered Prayer Times for Month ${selectedMonth.value} and Day ${selectedDate.value}: ${jsonEncode(filteredList)}");

    return filteredList;
  }
}
