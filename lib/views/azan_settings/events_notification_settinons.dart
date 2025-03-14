import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notificationEventandAnnouncemt_controller.dart';

class NotificationSettingsPage extends StatelessWidget {
  NotificationSettingsPage({super.key});

  final NotificationSettingsController controller =
      Get.put(NotificationSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 20,
            )),
        title: Text(
          'Notification Settings',
          style: TextStyle(
              fontFamily: popinsSemiBold, color: whiteColor, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: whiteColor,
              elevation: 4.0,
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                        activeColor: primaryColor,
                        title: const Text(
                          'Event Notifications',
                          style:
                              TextStyle(fontFamily: popinsMedium, fontSize: 14),
                        ),
                        subtitle: const Text(
                            'Enable or disable event notifications',
                            style: TextStyle(
                                fontFamily: popinsRegulr, fontSize: 12)),
                        value: controller.eventNotificationsEnabled.value,
                        onChanged: controller.toggleEventNotifications,
                      )),
                  Obx(() => SwitchListTile(
                        activeColor: primaryColor,
                        title: const Text('Announcement Notifications',
                            style: TextStyle(
                                fontFamily: popinsMedium, fontSize: 14)),
                        subtitle: const Text(
                            'Enable or disable announcement notifications',
                            style: TextStyle(
                                fontFamily: popinsRegulr, fontSize: 12)),
                        value:
                            controller.announcementNotificationsEnabled.value,
                        onChanged: controller.toggleAnnouncementNotifications,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Manage your notification preferences here. Toggle the switches to enable or disable specific types of notifications.',
              style: TextStyle(
                  color: Colors.grey, fontFamily: popinsRegulr, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
