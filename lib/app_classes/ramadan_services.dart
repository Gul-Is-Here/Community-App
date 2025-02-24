import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ramadan_model.dart';
// import '../models/ramadan_model.dart';

class RamadanService {
  Future<RamadanResponse> fetchRamadanData() async {
    final response = await http.get(Uri.parse(
        "https://rosenbergcommunitycenter.org/api/RamadanAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332&start_date=2025-02-28&end_date=2025-03-01"));

    if (response.statusCode == 200) {
      return RamadanResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}
