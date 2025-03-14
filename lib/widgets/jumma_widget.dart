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
      final jummaTimes = homeController.prayerTime.value.todayPrayerTime.jumuah;

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
          Row(
            children: [
              jummaTimes != null
                  ? buildJummaTile(
                      'Jumuah Khutba',
                      jummaTimes.prayerTiming,
                      Icons.mic,
                    )
                  : buildJummaTile(
                      'Jumuah Khutba',
                      '01:30 PM',
                      Icons.mic,
                    ),
              const SizedBox(width: 10),
              jummaTimes?.iqamahTiming != null
                  ? buildJummaTile(
                      'Jumuah Prayer',
                      jummaTimes!.iqamahTiming,
                      Icons.access_time,
                    )
                  : buildJummaTile(
                      'Jumuah Prayer',
                      '02:00 PM',
                      Icons.access_time,
                    ),
            ],
          ),
        ],
      );
    });
  }
}
