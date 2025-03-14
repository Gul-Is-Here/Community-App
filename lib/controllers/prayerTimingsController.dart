import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../model/prayerModelhome.dart'; // Ensure the correct model file is imported

class PrayerTimingController extends GetxController {
  Map<String, dynamic> prayerData = {};

  @override
  void onInit() {
    super.onInit();
    fetchPrayerTimes();
  }

// Global variable to store fetched prayer data

  Future<void> fetchPrayerTimes() async {
    const String apiUrl =
        'https://rosenbergcommunitycenter.org/api/IqamahandPrayertimesMobileAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332';

    try {
      print("Fetching prayer times from API...");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('data')) {
          dynamic data = jsonResponse['data'];

          if (data is Map<String, dynamic>) {
            // Ensure `Jumuah` field is properly formatted
            if (data.containsKey('PrayerTimingsUpcoming')) {
              List<dynamic> prayerTimes = data['PrayerTimingsUpcoming'];

              for (var prayer in prayerTimes) {
                if (prayer is Map<String, dynamic> &&
                    prayer.containsKey('Jumuah')) {
                  if (prayer['Jumuah'] == "") {
                    prayer['Jumuah'] = null;
                  } else if (prayer['Jumuah'] is! Map) {
                    prayer['Jumuah'] = {};
                  }
                }
              }
            }

            // Ensure `IqamahTimings` and `PrayerTime` exist
            data['IqamahTimings'] ??= {};
            data['PrayerTime'] ??= {};

            // Store the fetched data globally
            prayerData = data;

            print("Prayer times fetched and stored successfully.");
          } else {
            throw FormatException("Invalid API response format.");
          }
        } else {
          throw FormatException("API response does not contain 'data' field.");
        }
      } else {
        throw http.ClientException(
            'Failed to load prayer times with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
      prayerData = {}; // Reset to empty if fetch fails
    }
  }
}
