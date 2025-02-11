import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/contact_uc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var controller = Get.put(ContactFormController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontFamily: popinsMedium),
        ),
        // centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: lightColor,
                height: 2.0,
              ),
            )),
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stay in touch',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: popinsSemiBold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can get in touch with us through below platforms. Our team will reach out to you as soon as it will be possible.',
                style:
                    TextStyle(color: Colors.white70, fontFamily: popinsRegulr),
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                title2: 'Email',
                title: 'Customer Support',
                icon: Icons.phone,
                label: 'Contact Number',
                value: '+1 (281) 303-1758',
                subIcon: Icons.email,
                subValue: 'admin@rosenbergcommunitycenter.org',
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                title2: 'Email',
                title: 'Location',
                icon: Icons.location_on,
                label: 'Address',
                value: '6719 Koeblen Road, Richmond, TX, 77469',
              ),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF315B5A),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16, left: 16),
                        child: Text(
                          'Tell us what you think!',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: popinsRegulr,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      buildInputField(
                          label: 'Name',
                          hint: 'Your Name',
                          controller: nameController),
                      buildInputField(
                          controller: emailController,
                          label: 'Email',
                          hint: 'Your email'),
                      buildInputField(
                          controller: phoneController,
                          label: 'Phone No.',
                          hint: 'Your  phone number'),
                      buildInputField(
                        controller: messageController,
                        label: 'Message',
                        hint: 'Your Message',
                        maxLines: 4,
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF00A559), Color(0xFF006627)],
                    ),
                  ),
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await controller.sendContactForm(
                          name: nameController.text,
                          number: phoneController.text,
                          email: emailController.text,
                          message: messageController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(
                              color: whiteColor,
                            )
                          : Text(
                              'Submit',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required IconData icon,
    required String label,
    required String value,
    IconData? subIcon,
    required String title2,
    String? subValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF315B5A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: whiteColor, fontFamily: popinsSemiBold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: lightColor),
                  child: Icon(
                    icon,
                    color: const Color(0xFF00A53C),
                    size: 20,
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF00A53C)),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: popinsMedium,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subIcon != null && subValue != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: lightColor),
                    child: Icon(
                      subIcon,
                      color: const Color(0xFF00A53C),
                      size: 20,
                    )),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title2,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF00A53C),
                            fontFamily: popinsRegulr),
                      ),
                      Text(
                        subValue,
                        style: const TextStyle(
                            fontSize: 14,
                            fontFamily: popinsMedium,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget buildInputField({
    required var controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16.0, left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00A53C),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              cursorColor: primaryColor,
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.5),
                    fontFamily: popinsRegulr),
                filled: true,
                fillColor: lightColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
