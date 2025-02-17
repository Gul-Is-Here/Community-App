import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../controllers/rate_app_controller.dart';

class RateAppPage extends StatelessWidget {
  final RateAppController controller = Get.put(RateAppController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  RxInt selectedRating = 5.obs;
  RxString attachmentPath = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: lightColor,
                height: 2.0,
              ),
            )),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 18,
            )),
        backgroundColor: primaryColor,
        title: const Text(
          'Rate RCC App',
          style: TextStyle(
              color: Colors.white, fontFamily: popinsSemiBold, fontSize: 18),
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give your feedback:',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: popinsRegulr),
            ),
            const SizedBox(height: 10),

            /// Rating Stars
            Obx(() => Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: goldenColor,
                      ),
                      onPressed: () {
                        selectedRating.value = index + 1;
                      },
                    );
                  }),
                )),

            /// Email Input
            _buildInputField(
                controller: emailController,
                label: "Email",
                hint: "Enter Email"),

            /// Review Input
            _buildInputField(
                controller: reviewController,
                label: "Review",
                hint: "Write your review",
                maxLines: 3),

            /// Upload Image Button
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attachmentPath.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Attachment: ${attachmentPath.value.split('/').last}",
                          style: const TextStyle(
                              color: Colors.white, fontFamily: popinsRegulr),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF00A559), Color(0xFF006627)],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (image != null) {
                            attachmentPath.value = image.path;
                          }
                        },
                        icon: Icon(
                          Icons.upload,
                          color: whiteColor,
                        ),
                        label: Text(
                          "Attach Image",
                          style: TextStyle(
                              fontFamily: popinsRegulr, color: whiteColor),
                        ),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 20),

            /// Submit Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF00A559), Color(0xFF006627)],
                ),
              ),
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      await controller.sendRating(
                        rating: selectedRating.value,
                        email: emailController.text,
                        review: reviewController.text,
                        attachmentPath: attachmentPath.value.isNotEmpty
                            ? attachmentPath.value
                            : null,
                      );
                    },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        cursorColor: primaryColor,
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.black.withOpacity(.5), fontFamily: popinsRegulr),
          filled: true,
          fillColor: lightColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
