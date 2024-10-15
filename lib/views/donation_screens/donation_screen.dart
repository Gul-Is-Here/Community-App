import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/donation_controller.dart';
import 'package:community_islamic_app/widgets/customized_card_widget2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app_classes/app_class.dart';
import '../../constants/image_constants.dart';
import '../../controllers/login_controller.dart';
import '../../model/donation_model.dart';

// ignore: must_be_immutable
class DonationScreen extends StatelessWidget {
  DonationScreen({super.key});
  var loginConrtroller = Get.put(LoginController());
  var donationController = Get.put(DonationController());
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<Donation>(
        future: donationController.fetchDonationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            final donations = snapshot.data!.data.donate;
            return Column(
              children: [
                Container(
                  height: screenHeight * .25,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    image: DecorationImage(
                      image: AssetImage(qiblaTopBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'DONATION',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: popinsBold,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                10.heightBox,

                // Dynamically create donation categories
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donate = donations[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            color: primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                donate.donationcategoryName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: popinsBold),
                              ),
                            ),
                          ),
                          10.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: donate.hasdonation.map((hasDonation) {
                              return CusTomizedCardWidget2(
                                title: hasDonation.donationName,
                                imageIcon: hasDonation.donationImage.toString(),
                                onTap: () async {
                                  try {
                                    await AppClass()
                                        .launchURL(hasDonation.donationLink);
                                  } catch (e) {
                                    print(
                                        'Could not launch ${hasDonation.donationLink}: $e');
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          10.heightBox,
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
                child: Text(
              "No data found",
              style: TextStyle(fontFamily: popinsRegulr),
            ));
          }
        },
      ),
    );
  }
}
