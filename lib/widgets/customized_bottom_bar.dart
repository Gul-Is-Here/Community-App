import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import '../constants/image_constants.dart';
import '../controllers/home_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final HomeController controller;
  const CustomBottomNavigationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      color: const Color(0xFF315C5A), // Background color for the entire bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            index: 0,
            icon: bHomeIcon,
            label: "Home",
          ),
          _buildNavItem(
            context,
            index: 1,
            icon: mosqueIcon,
            label: "Qibla",
          ),
          _buildNavItem(
            context,
            index: 2,
            icon: quranIcon,
            label: "Quran",
          ),
          _buildNavItem(
            context,
            index: 3,
            icon: prayerIcon,
            label: "Prayer",
          ),
          _buildNavItem(
            context,
            index: 4,
            icon: bDonationIcon, // Replace with your desired fifth icon
            label: "Donate",
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required int index, required String icon, required String label}) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            // color:,
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for selected item
          ),
          child: isSelected
              ? Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(40)),
                  height: 34,
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icon,
                        height: 18,
                        width: 18,
                        color: whiteColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: popinsMedium, // Update based on your font
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Image.asset(
                      icon,
                      height: 26,
                      width: 24,
                      color: lightColor,
                    ),
                  ],
                )),
    );
  }
}
