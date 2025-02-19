import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RamadanController extends GetxController {
  var schedule = [].obs;
  var filteredSchedule = [].obs;
  var selectedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    String jsonString = await rootBundle.loadString('assets/ramadan_schedule.json');
    List<dynamic> jsonData = json.decode(jsonString);
    schedule.value = jsonData;
    filterByDate(DateTime.now().toString().split(' ')[0]); // Default to current date
  }

  void filterByDate(String date) {
    selectedDate.value = date;
    filteredSchedule.value = schedule.where((item) => item['Date'] == date).toList();
  }
}

