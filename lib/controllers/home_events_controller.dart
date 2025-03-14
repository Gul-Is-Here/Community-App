import 'dart:convert';

import 'package:community_islamic_app/model/alerts_model.dart';
import 'package:community_islamic_app/model/feeds_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/home_events_model.dart';

class HomeEventsController extends GetxController {
  RxInt? selectedEventType;
  var isLoading = false.obs; // Observable to track loading state
  Rxn events = Rxn<Events>(); // Observable to store the fetched events
  var feedsList = <Feed>[].obs; // Observable list to store the fetched feeds
  var alertsList = <Alert>[].obs; // Observable list of Alert objects
  var currentIndex = 0.obs;

  RxBool isHiddenFeature = true.obs;
  RxBool isHiddenServices = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchEventsData(); // Fetch events when the controller is initialized
    fetchFeedsData(); // Fetch feeds when the controller is initialized
    fetchAlertsData();

    feedsList;
  }

  // Method to fetch events and update the state

  void fetchEventsData() async {
    try {
      isLoading(true); // Set loading to true
      final Uri url = Uri.parse(
          'https://rosenbergcommunitycenter.org/api/allevents?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            // Parse the JSON safely
            events.value = Events.fromRawJson(response.body);
          } catch (e) {
            print("Error parsing JSON: $e");
          }
        } else {
          print("Error: API returned empty response");
        }
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading(false); // Set loading to false after data is fetched
    }
  }

  // Method to fetch Feeds and update the state
  void fetchFeedsData() async {
    try {
      isLoading(true); // Set loading to true
      final response = await http.get(
        Uri.parse(
            'https://rosenbergcommunitycenter.org/api/allfeeds?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body and map it to the Feed list
        final feeds = Feeds.fromRawJson(response.body);

        // Update the feedsList observable with the fetched feeds
        feedsList.assignAll(feeds.data.feeds);
        print('Feeds List : ${feedsList}');
      } else {
        print('Failed to load feeds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feeds: $e');
    } finally {
      isLoading(false); // Set loading to false after data is fetched
    }
  }

// Gets Allterts Api

  // Method to fetch Feeds and update the state
  void fetchAlertsData() async {
    try {
      isLoading(true); // Set loading to true
      final response = await http.get(
        Uri.parse(
            'https://rosenbergcommunitycenter.org/api/GetAlerts?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body and map it to the Alert list
        final alertsNotify = AlertsModel.fromRawJson(response.body);

        // Update the alertsList observable with the fetched alerts
        alertsList.assignAll(alertsNotify.data.alert);
        print('Alerts List: ${alertsList}');
      } else {
        print('Alerts List: ${alertsList}');
        print('Failed to load alerts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alerts: $e');
    } finally {
      isLoading(false); // Set loading to false after data is fetched
    }
  }

  String formatDateString(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString);

    // Define the desired format for both date and time
    String formattedDate = DateFormat('MMMM d, y (h a)').format(dateTime);

    return formattedDate; // e.g., "September 10, 2024 - 2:00 PM"
  }

  var selectedIndex = 0.obs;
  var selectedIndexAnnouncment = 0.obs;
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

// Second Method Update Announcement Index

  void updateSelectedAnnouncementIndex(int index) {
    selectedIndexAnnouncment.value = index;
  }
}
