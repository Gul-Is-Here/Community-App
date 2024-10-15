import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final HomeController controller;
  const CustomBottomNavigationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 80,
        child: AnimatedNotchBottomBar(
          elevation: 0,
          removeMargins: true,
          circleMargin: 15,
          bottomBarWidth: 0,
          // showTopRadius: true,
          color: Colors.white,
          bottomBarItems: [
            BottomBarItem(
              activeItem: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    homeIcon2,
                    height: 50, // Adjusted icon size
                    width: 40, // Adjusted icon size
                    color: const Color(0xFF0F6467),
                  ),
                ),
              ),
              inActiveItem: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  homeIcon2,
                  height: 50, // Adjusted icon size
                  width: 50, // Adjusted icon size
                  color: Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              activeItem: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    qiblaIconBg,
                    height: 50, // Adjusted icon size
                    width: 50, // Adjusted icon size
                    color: const Color(0xFF0F6467),
                  ),
                ),
              ),
              inActiveItem: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  qiblaIconBg,
                  height: 50, // Adjusted icon size
                  width: 50, // Adjusted icon size
                  color: Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              activeItem: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    quranIcon,
                    height: 60, // Adjusted icon size
                    width: 60, // Adjusted icon size
                    color: const Color(0xFF0F6467),
                  ),
                ),
              ),
              inActiveItem: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  quranIcon,
                  height: 45, // Adjusted icon size
                  width: 45, // Adjusted icon size
                  color: Colors.grey,
                ),
              ),
            ),
            BottomBarItem(
              activeItem: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    donationIcon2,
                    height: 30, // Adjusted icon size
                    width: 30, // Adjusted icon size
                    color: const Color(0xFF0F6467),
                  ),
                ),
              ),
              inActiveItem: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  donationIcon2,
                  height: 45, // Adjusted icon size
                  width: 45, // Adjusted icon size
                  color: Colors.grey,
                ),
              ),
            ),
          ],
          onTap: (index) {
            controller.changePage(index);
          },
          kIconSize: 35,
          kBottomRadius: 0,
          notchBottomBarController: controller.notchBottomBarController,
        ),
      ),
    );
  }
}
