import 'package:community_islamic_app/model/feeds_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/home_events_model.dart';

class HomeEventsController extends GetxController {
  var isLoading = false.obs; // Observable to track loading state
  var events = Rxn<Events>(); // Observable to store the fetched events
  var feedsList = <Feed>[].obs; // Observable list to store the fetched feeds
  var currentIndex = 0.obs;
  final String baseUrl = 'https://rosenbergcommunitycenter.org/api/allevents';
  final String accessKey = '7b150e45-e0c1-43bc-9290-3c0bf6473a51332';

  @override
  void onInit() {
    super.onInit();
    fetchEventsData(); // Fetch events when the controller is initialized
    fetchFeedsData(); // Fetch feeds when the controller is initialized
  }

  // Method to fetch events and update the state
  void fetchEventsData() async {
    try {
      isLoading(true); // Set loading to true
      final Uri url = Uri.parse('$baseUrl?access=$accessKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON and update the events observable
        events.value = Events.fromRawJson(response.body);
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

  String formatDateString(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString);

    // Define the desired format
    String formattedDate = DateFormat('MMMM d, y').format(dateTime);

    return formattedDate; // e.g., "September 10, 2024"
  }
}
