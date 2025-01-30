import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStreamController extends GetxController {
  var liveUrl = ''.obs; // Observable for live URL
  var isLoading = true.obs; // Loading indicator

  @override
  void onInit() {
    fetchLiveUrl(); // Fetch data when the controller is initialized
    super.onInit();
  }

  Future<void> fetchLiveUrl() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(
          "https://rosenbergcommunitycenter.org/api/GetLiveUrl?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        liveUrl.value = data['data']['live_url']['live_key_url'];
      } else {
        Get.snackbar("Error", "Failed to load URL");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
