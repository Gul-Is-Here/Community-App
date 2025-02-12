import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ContactFormController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendContactForm({
    required String name,
    required String number,
    required String email,
    required String message,
  }) async {
    try {
      isLoading(true);
      
      var url = Uri.parse(
          "https://rosenbergcommunitycenter.org/api/ContactFormAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332");

      var request = http.MultipartRequest("POST", url)
        ..fields['name'] = name
        ..fields['number'] = number
        ..fields['email'] = email
        ..fields['message'] = message;

      var response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Message sent successfully!");
      } else {
        Get.snackbar("Error", "Failed to send message");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
