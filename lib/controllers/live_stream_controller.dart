import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart'; // To parse the iframe HTML

class LiveStreamController extends GetxController {
  var liveUrl = ''.obs; // Extracted Live URL
  var isLive = false.obs; // Check if live
  var isLoading = true.obs; // Loading indicator

  @override
  void onInit() {
    fetchLiveUrl();
    super.onInit();
  }

  Future<void> fetchLiveUrl() async {
    try {
      isLoading(true);
      print("Fetching live URL...");

      var response = await http.get(Uri.parse(
          "https://rosenbergcommunitycenter.org/api/GetLiveUrl?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("API Response: $data");

        String iframeHtml = data['data']['live_url']['live_key_url'];
        print("Extracted iframe HTML: $iframeHtml");

        // Extract src URL from iframe
        String? extractedUrl = _extractIframeSrc(iframeHtml);
        print("Extracted Live URL: $extractedUrl");

        if (extractedUrl != null && extractedUrl.isNotEmpty) {
          liveUrl.value = extractedUrl;
          isLive.value = true;
        } else {
          isLive.value = false;
        }
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load live URL");
        isLive.value = false;
      }
    } catch (e) {
      print("Error fetching live URL: $e");
      Get.snackbar("Error", e.toString());
      isLive.value = false;
    } finally {
      isLoading(false);
    }
  }

  // Function to extract src URL from iframe
  String? _extractIframeSrc(String iframeHtml) {
    try {
      var document = parse(iframeHtml);
      var iframe = document.getElementsByTagName("iframe").first;
      return iframe.attributes['src'];
    } catch (e) {
      print("Error extracting iframe src: $e");
      return null;
    }
  }
}
