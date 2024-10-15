import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_islamic_app/model/project_model.dart';
import 'package:intl/intl.dart';

class ProjectController extends GetxController {
  var isContentVisibleIndex = Rx<int?>(null);
  var projectData = ProjectModel(code: 0, data: Data(x: [])).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjectApi(); // Fetch data when the controller is initialized
  }

  Future<void> fetchProjectApi() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://rosenbergcommunitycenter.org/api/projects?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'));
      if (response.statusCode == 200) {
        projectData.value = ProjectModel.fromJson(jsonDecode(response.body));
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void toggleContentVisibility(int index) {
    isContentVisibleIndex.value = isContentVisibleIndex.value == index ? null : index;
  }

  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return dateFormat.format(date);
  }
}
