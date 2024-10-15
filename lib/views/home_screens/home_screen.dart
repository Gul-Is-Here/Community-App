import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/widgets/custome_drawer.dart';
import 'package:flutter/material.dart';
import 'package:community_islamic_app/widgets/customized_mobile_layout.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the drawer icon color to white
          ),
          title: const AutoScrollText(
            intervalSpaces: 60,
            'Rosenberg Community Center - First Islamic Dawah center in Rosenberg Texas',
            style: TextStyle(
                color: Colors.white, fontFamily: popinsMedium, fontSize: 18),
          )),
      body: Column(
        children: [
          CustomizedMobileLayout(
            screenHeight: screenHeight,
          ),
        ],
      ),
    );
  }
}
