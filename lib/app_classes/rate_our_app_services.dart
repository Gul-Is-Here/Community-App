import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      "https://rosenbergcommunitycenter.org/api/RateAppAPI?access=7b150e45-e0c1-43bc-9290-3c0bf6473a51332";

  Future<bool> rateApp({
    required int rating,
    String? email,
    String? review,
    String? attachmentPath, // Optional attachment (currently not supported in `http`)
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      // Add fields
      request.fields['rating'] = rating.toString();
      request.fields['email'] = email ?? "";
      request.fields['review'] = review ?? "";
      
      // If there's an attachment, add it
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('attachment', attachmentPath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Success: ${response.body}");
        return true;
      } else {
        print("Failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending rating: $e");
      return false;
    }
  }
}
