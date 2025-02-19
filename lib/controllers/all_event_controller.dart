import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../model/eventType_model.dart';
import '../model/home_events_model.dart';

class EventTypeController extends GetxController {
  RxList<Event> selectedEvents = <Event>[].obs;
  RxList<Eventtype> eventTypes = <Eventtype>[].obs;

  final String apiUrl =
      "https://rosenbergcommunitycenter.org/api/EventTypes?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332";

  @override
  void onInit() {
    super.onInit();
    fetchEventTypes();
  }

  // Fetch event types from API
  Future<void> fetchEventTypes() async {
    debugPrint('Fetching Event Types...');
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final eventType = EventType.fromRawJson(response.body);
        eventTypes.assignAll(eventType.data.eventtypes);
        debugPrint('Fetched Event Types: ${eventTypes.length}');
      } else {
        _showError(
            "Failed to fetch data (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  // Filter events based on selected date and event type
  List<Event> updateDisplayedEvents({
    required DateTime? selectedDate,
    required Map<DateTime, List<Event>> eventDates,
    required int selectedEventType,
  }) {
    // If no date is selected, flatten all events from the eventDates map
    if (selectedDate == null) {
      return eventDates.values
          .expand((events) => events)
          .where((event) =>
              selectedEventType == 1 ||
              event.eventhastype!.eventtypeId == selectedEventType)
          .toList();
    } else {
      // Otherwise, filter events by the selected date and event type
      return (eventDates[selectedDate] ?? [])
          .where((event) =>
              selectedEventType == 1 ||
              event.eventhastype!.eventtypeId == selectedEventType)
          .toList();
    }
  }

  // Show error messages
  void _showError(String message) {
    Get.snackbar("Error", message);
  }
}
