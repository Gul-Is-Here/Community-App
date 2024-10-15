import 'package:community_islamic_app/constants/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordController extends GetxController {
  var isLoading = false.obs;

  Future<void> updatePassword(
      String oldPass, String newPass, String confirmPass) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse('https://rosenbergcommunitycenter.org/api/UpdatePasswordAPI'),
        headers: {
          'Authorization':
              'Bearer ${globals.accessToken.value}', // Ensure 'Bearer ' is prefixed if needed
        },
        body: {
          'id': globals.userId.value,
          'oldpass': oldPass,
          'newpass': newPass,
          'confirmpass': confirmPass,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password updated successfully');
      } else if (response.statusCode == 400) {
        Get.snackbar('Error', 'Old password is incorrect');
      } else {
        Get.snackbar('Error', 'Failed to update password');
      }
    } catch (e) {
      print('Error: $e'); // Debugging purpose
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading(false);
    }
  }
}
