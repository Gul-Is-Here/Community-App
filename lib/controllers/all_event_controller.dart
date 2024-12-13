import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/eventType_model.dart';

class EventTypeController extends GetxController {
  // RxList to hold the event types
  var eventTypes = <Eventtype>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEventTypes();
  }

  // API URL
  final String apiUrl =
      "https://rosenbergcommunitycenter.org/api/EventTypes?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332";

  // Method to fetch event types from API
  // Method to fetch data from the API
  Future<void> fetchEventTypes() async {
    print('Event Type Called');
    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl));
      print(response);
      if (response.statusCode == 200) {
        // Parse the response using your model
        final EventType eventType = EventType.fromRawJson(response.body);
        // Update the observable list
        eventTypes.value = eventType.data.eventtypes;
        print('Feeds List : $eventTypes');
      } else {
        Get.snackbar("Error", "Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
