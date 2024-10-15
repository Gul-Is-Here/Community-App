import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/widgets/project_background.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/image_constants.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  final RxInt selectedImageIndex = 0.obs;

  final List<String> titles = [
    'OUR CHILDREN OUR FUTURE',
    'THE FAMILY INSTITUTION',
    'SAFE SPACE SCARED PLACE',
    'A LEGACY ILLUMINATION'
  ];

  final List<String> descriptions = [
    'We must cultivate environments which nurture future leaders from within our community to champion a moral & ethical paradigm which ensures the success of our community and humanity as a whole.',
    'A strong & healthy Family Institution is the foundation for a healthy, moral, and upright society. If we wish to succeed as a community, we must become very intentional about strengthening the family institution.',
    'A sense of belonging, a source of inspiration, a means of empowerment must be associated with our sacred places which root our future generations to our Islamic Values & our community.',
    '''As God says in the Qur'an, "every soul shall taste death", we must ensure that our legacy lives on long after we have departed this earth. What better legacy could we leave than one which empowers and cultivates upright future leaders and champions the values of Islam.'''
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Projectbackground(
                  title: 'About Us',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Place to Pray and Community Center to Learn',
                    style: TextStyle(
                      fontFamily: popinsSemiBold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Community that learn together and builds together',
                    style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                        fontFamily: popinsMedium),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                10.heightBox,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Our center serves as more than just a mosque for prayers. It is a welcoming community center for everyone. We are dedicated to preserving an Islamic identity and promoting a comprehensive way of life based on the holy Quran and the Sunnah of Prophet Muhammad (PBUH). Our mission is to nurture future leaders within our community, champion Islam, foster a moral and ethical paradigm for prosperity, strengthen families, create a sense of belonging and empowerment, and cultivate upright leaders. We aim to build a lasting legacy and have a positive impact.',
                    style: TextStyle(fontSize: 14, fontFamily: popinsRegulr),
                    maxLines: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                10.heightBox,
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(color: primaryColor),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'CORE PRINCIPLES',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsBold),
                    ),
                  ),
                ),
                5.heightBox,
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(4, (index) {
                            final imagePaths = [
                              aboutUs1,
                              aboutUs2,
                              aboutUs3,
                              aboutUs4
                            ];

                            return GestureDetector(
                              onTap: () {
                                selectedImageIndex.value = index;
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Card(
                                    shape: Border.all(
                                      width: 4,
                                      color: primaryColor,
                                      style: BorderStyle.solid,
                                    ),
                                    child: Image.asset(
                                      imagePaths[index],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (selectedImageIndex.value == index) ...[
                                    Positioned(
                                      bottom:
                                          -20, // Adjust this value to position the arrow correctly
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 40,
                                        color: primaryColor,
                                      ),
                                    ),
                                    10.heightBox
                                  ],
                                  10.heightBox
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      5.heightBox,
                      Obx(() {
                        final index = selectedImageIndex.value;
                        return Column(
                          children: [
                            if (index < 4) ...[
                              Container(
                                width: double.infinity,
                                color: primaryColor,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  titles[index],
                                  style: TextStyle(
                                    fontFamily: popinsRegulr,
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  descriptions[index],
                                  style: TextStyle(
                                    fontFamily: popinsRegulr,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
