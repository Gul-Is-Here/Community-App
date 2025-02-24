import 'package:get/get.dart';
import '../app_classes/ramadan_services.dart';
import '../model/ramadan_model.dart';
// import '../models/ramadan_model.dart';
// import '../services/ramadan_service.dart';

class RamadanController extends GetxController {
  var isLoading = true.obs;
  var ramadanData = RamadanResponse(
    ramadan: [],
    fullCalendar: [],
    todaysData: [],
    todaysDate: "",
  ).obs;

  @override
  void onInit() {
    fetchRamadanData();
    super.onInit();
  }

  void fetchRamadanData() async {
    try {
      isLoading(true);
      var data = await RamadanService().fetchRamadanData();
      ramadanData.value = data;
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
}
