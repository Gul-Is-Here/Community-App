import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../controllers/home_controller.dart';
import '../views/namaz_timmings/namaztimmings.dart';
import 'jumma_tile_widget.dart';

class JummaPrayerTile extends StatelessWidget {
  const JummaPrayerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Obx(() {
      final jummaTimes = homeController.jummaTimes.value.data!.jumah;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jumuah',
            style: TextStyle(
              fontSize: 22,
              fontFamily: popinsSemiBold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          buildJummaTile(
            'Jumuah Khutba',
            formatPrayerTime(jummaTimes.prayerTiming),
            Icons.mic,
          ),
          const SizedBox(height: 10),
          buildJummaTile(
            'Jumuah Prayer',
            formatPrayerTime(jummaTimes.iqamahTiming),
            Icons.access_time,
          ),
        ],
      );
    });
  }
}
