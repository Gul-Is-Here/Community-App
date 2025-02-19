import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  Future<bool> rateApp({
    required int rating,
    String? email,
    String? review,
    String? attachmentPath,
    required String complainType, // Added complain_type parameter
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://rosenbergcommunitycenter.org/api/RateAppAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332'),
      );

      request.fields['review_type'] = complainType; // Feedback / Complain
      request.fields['rating'] = rating.toString();
      request.fields['email'] = email ?? '';
      request.fields['review'] = review ?? '';

      // Attach image if available
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachment',
          attachmentPath,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }
}
