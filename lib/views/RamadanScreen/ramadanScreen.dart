import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/image_constants.dart';
import '../../controllers/ramadanController.dart';

import '../../model/ramadan_model.dart';

class RamadanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RamadanController controller = Get.put(RamadanController());
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: lightColor,
                height: 2.0,
              )),
          title: Text(
            "Ramadan 2025",
            style: TextStyle(
                fontFamily: popinsSemiBold, fontSize: 18, color: whiteColor),
          ),
          backgroundColor: primaryColor),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(
            color: lightColor,
          ));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.ramadanData.value.ramadan.length,
          itemBuilder: (context, index) {
            RamadanEvent item = controller.ramadanData.value.ramadan[index];
            return Column(
              children: [
                _buildRamadanCard(item, icRamadanIconsList[index]),
                // SizedBox(height: ,)
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildRamadanCard(RamadanEvent item, String image) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: popinsRegulr),
                  ),
                  const SizedBox(height: 12),
                  if (item.btnText.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            int.parse(item.btnColor.replaceFirst('#', '0xFF'))),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        if (item.url != null) {
                          AppClass().launchURL(item.url!);
                        }
                      },
                      child: Text(
                        item.btnText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsRegulr,
                          // decoration: TextDecoration.underline,
                          color: Color(int.parse(
                              item.btnTextColor.replaceFirst('#', '0xFF'))),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 170.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: lightColor,
            child: Image.asset(
              image,
              width: 30,
            ),
          ),
        ),
      ],
    );
  }
}
