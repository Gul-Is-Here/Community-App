import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Generate and store the initial token
  Future<void> generateAndStoreToken() async {
    try {
      // Request notification permissions (optional)
      await _firebaseMessaging.requestPermission();

      // Get the FCM token
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        // await postToken(token);
        await _storeToken(token);
      } else {
        print("Failed to generate token");
      }
    } catch (e) {
      print("Error storing token: $e"); 
    }
  }

  /// Handle token refresh
  void handleTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _storeToken(newToken);
    }).onError((err) {
      print("Error during token refresh: $err");
    });
  }

  /// Store or update the token in Firestore
  Future<void> _storeToken(String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('userTokens')
          .doc(token) // Use token as the document ID
          .set({
        'token': token,
        'createdAt': DateTime.now(),
        'lastRefreshed': DateTime.now()
      }, SetOptions(merge: true));
      await postToken(token);
      print(postToken(token));
      print("Token stored successfully: $token");
    } catch (e) {
      print("Error storing token: $e");
    }
  }

  static const String baseUrl =
      "https://rosenbergcommunitycenter.org/api/createtoken";

  Future<bool> postToken(String token) async {
    const String accessKey = "7b150e45-e0c1-43bc-9290-3c0bf6473a51332";

    try {
      final Uri uri = Uri.parse("$baseUrl?access=$accessKey");

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        print("Token posted successfully: ${response.body}");
        return true;
      } else {
        print("Failed to post token: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error posting token: $e");
      return false;
    }
  }
}
