import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/events_model.dart';
import '../model/gallary_images_video_model.dart';

class GalleryController extends GetxController {
  var galleryList = <GalleryModel>[].obs;
  var gallerySubcategories = <Subcategory>[].obs; // List of Subcategory model
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGalleryEvents();
  }

  void fetchGalleryEvents() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
            'https://rosenbergcommunitycenter.org/api/gallery_events?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332&cat_name=images'),
      );

      if (response.statusCode == 200) {
        var data = EventsModel.fromRawJson(response.body);
        gallerySubcategories.assignAll(data.data.subcategory);
      } else {
        print(
            'Error: Failed to fetch events. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchGalleryData(String catHash, String subcatHash) async {
    final url =
        'https://rosenbergcommunitycenter.org/api/gallery?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332&subcat_hash=$subcatHash&cat_name=$catHash';
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final galleryResponse =
            GalleryResponse.fromJson(jsonDecode(response.body));
        galleryList.assignAll(galleryResponse
            .galleryList); // Update observable list with gallery data
      } else {
        throw Exception('Failed to load gallery');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
