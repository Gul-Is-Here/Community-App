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
      backgroundColor: primaryColor,
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomizedMobileLayout(
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
    );
  }
}
