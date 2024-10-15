import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/Gallery_Events/ask_imam_screen.dart';
import 'package:community_islamic_app/views/Gallery_Events/chat_with_Rcc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaFloatingButton extends StatelessWidget {
  const SocialMediaFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main FloatingActionButton
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            heroTag: 'toggle', // Unique heroTag for the main button
            focusColor: primaryColor,
            splashColor: primaryColor,
            backgroundColor: primaryColor,
            mini: true,
            onPressed: () =>
                _showSocialMediaDialog(context), // Show dialog on press
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showSocialMediaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Connect with RCC',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                children: [
                  _buildSocialMediaButton(
                    icon: Image.asset(askImamIcon),
                    label: 'Ask Imam',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => AskImamScreen());
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Icon(Icons.email, color: primaryColor),
                    label: 'Email Us',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'admin@rosenbergcommunitycenter.org',
                      );
                      await launchUrl(emailLaunchUri);
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: const Icon(Icons.call, color: Colors.greenAccent),
                    label: 'Call Us',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: '+1 (281) 303-1758',
                      );
                      await launchUrl(phoneUri);
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Image.asset(icWhatsapp),
                    label: 'WhatsApp',
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showWhatsAppDialog(
                          context); // New dialog for WhatsApp options
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: const Icon(Icons.facebook, color: Colors.blueAccent),
                    label: 'Facebook',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.facebook.com/rosenbergcommunitycenter/'));
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Image.asset(
                      fit: BoxFit.cover,
                      icyoutube,
                    ),
                    label: 'YouTube',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.youtube.com/channel/UCBvcBiS7SvA7NDn6oI1Qu5Q'));
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Image.asset(icInstagram),
                    label: 'Instagram',
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(Uri.parse(
                          'https://www.instagram.com/rosenbergcommunitycenter/?igshid=MmIzYWVlNDQ5Yg%3D%3D'));
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Icon(
                      Icons.newspaper,
                      color: primaryColor,
                    ),
                    label: 'Newsletters',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  _buildSocialMediaButton(
                    icon: Icon(
                      Icons.chat,
                      color: primaryColor,
                    ),
                    label: 'RCC Chat',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => const ChatWithRCCScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWhatsAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Join WhatsApp Group',
            style: TextStyle(
              fontFamily: popinsSemiBold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(icWhatsapp),
                title: Text(
                  'RCC Brothers',
                  style: TextStyle(fontFamily: popinsRegulr),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await launchUrl(Uri.parse(
                      'https://chat.whatsapp.com/C558smdW2bc2asAJIeoS6t'));
                },
              ),
              const Divider(),
              ListTile(
                leading: Image.asset(icWhatsapp),
                title: const Text(
                  'RCC Sisters',
                  style: TextStyle(fontFamily: popinsRegulr),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await launchUrl(Uri.parse(
                      'https://chat.whatsapp.com/JwNn9RLPj4kFcrOLW4ANgW'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialMediaButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: 30,
              height: 30,
              child: FittedBox(
                fit: BoxFit.cover,
                child: icon,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
