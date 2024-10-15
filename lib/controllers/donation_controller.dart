import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/donation_model.dart';

class DonationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchDonationData();
  }

//  late Future<Donation> futureDonationData;
  Future<Donation> fetchDonationData() async {
    final response = await http.get(Uri.parse(
        'https://rosenbergcommunitycenter.org/api/donate?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Donation.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load donation data');
    }
  }
}
