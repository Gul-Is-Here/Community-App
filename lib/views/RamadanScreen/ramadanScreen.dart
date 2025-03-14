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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.005),
          child: Container(
            color: lightColor,
            height: screenHeight * 0.002,
          ),
        ),
        title: Text(
          "Ramadan 2025",
          style: TextStyle(
            fontFamily: popinsSemiBold,
            fontSize: screenWidth * 0.045,
            color: whiteColor,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: lightColor),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(screenWidth * 0.04),
          itemCount: controller.ramadanData.value.ramadan.length,
          itemBuilder: (context, index) {
            RamadanEvent item = controller.ramadanData.value.ramadan[index];
            return Column(
              children: [
                _buildRamadanCard(
                    item, icRamadanIconsList[index], screenWidth, screenHeight),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildRamadanCard(RamadanEvent item, String image, double screenWidth,
      double screenHeight) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: screenHeight * 0.06),
            Container(
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: screenWidth * 0.02,
                    offset: Offset(0, screenHeight * 0.005),
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
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: popinsRegulr,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  if (item.btnText.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            int.parse(item.btnColor.replaceFirst('#', '0xFF'))),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.012,
                        ),
                      ),
                      onPressed: () {
                        if (item.url != null) {
                          AppClass().launchURL(item.url!);
                        } else {
                          AppClass().launchURL(item.attachment!);
                        }
                      },
                      child: Text(
                        item.btnText,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsRegulr,
                          color: Color(int.parse(
                              item.btnTextColor.replaceFirst('#', '0xFF'))),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.07),
          ],
        ),
        Positioned(
          top: -screenHeight * 0.0,
          child: CircleAvatar(
            radius: screenWidth * 0.08,
            backgroundColor: lightColor,
            child: Image.asset(
              image,
              width: screenWidth * 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
