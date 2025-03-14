import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationSettingsController extends GetxController {
  RxBool eventNotificationsEnabled = true.obs;
  RxBool announcementNotificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    subscribeToDefaultTopics();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    eventNotificationsEnabled.value = prefs.getBool('Events') ?? true;
    announcementNotificationsEnabled.value = prefs.getBool('Alert') ?? true;
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Events', eventNotificationsEnabled.value);
    await prefs.setBool('Alert', announcementNotificationsEnabled.value);
  }

  Future<void> subscribeToDefaultTopics() async {
    await FirebaseMessaging.instance.subscribeToTopic('Events');
    await FirebaseMessaging.instance.subscribeToTopic('Alert');
  }

  void toggleEventNotifications(bool value) async {
    eventNotificationsEnabled.value = value;
    await _saveSettings();
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('Events');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('Events');
    }
  }

  void toggleAnnouncementNotifications(bool value) async {
    announcementNotificationsEnabled.value = value;
    await _saveSettings();
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('Alert');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('Alert');
    }
  }
}
