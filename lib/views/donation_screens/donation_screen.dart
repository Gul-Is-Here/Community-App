import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/donation_controller.dart';
import 'package:community_islamic_app/widgets/customized_card_widget2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_classes/app_class.dart';
import '../../constants/image_constants.dart';
import '../../controllers/login_controller.dart';
import '../../model/donation_model.dart';

// ignore: must_be_immutable
class DonationScreen extends StatelessWidget {
  DonationScreen({super.key});
  final loginController = Get.put(LoginController());
  final donationController = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        // toolbarHeight: 20,
        backgroundColor: primaryColor,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        title: Text(
          'Donation',
          style: TextStyle(
              fontFamily: popinsSemiBold, fontSize: 18, color: whiteColor),
        ),
      ),
      body: FutureBuilder<Donation>(
        future: donationController.fetchDonationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: whiteColor,
            ));
          } else if (snapshot.hasError) {
            return Center(
                child: Text("No Data Available",
                    style: TextStyle(
                        fontFamily: popinsRegulr, color: whiteColor)));
          } else if (snapshot.hasData) {
            final donations = snapshot.data!.data.donate;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donate = donations[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: double.infinity,
                            color: lightColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                donate.donationcategoryName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: popinsBold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 0.8),
                            itemCount: donate.hasdonation.length,
                            itemBuilder: (context, gridIndex) {
                              final hasDonation = donate.hasdonation[gridIndex];
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
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
