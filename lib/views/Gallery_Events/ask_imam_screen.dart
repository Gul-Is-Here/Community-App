import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import '../../app_classes/app_class.dart';
import '../../controllers/askImamController.dart';

class AskImamPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final RxString _selectedQuestionType = ''.obs;

  final AskImamController _askImamController = Get.put(AskImamController());

  void _submitForm() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedQuestionType.value.isEmpty ||
        _phoneController.text.isEmpty ||
        _messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _askImamController.submitForm(
      name: _nameController.text,
      emailPhone: _emailController.text,
      message: _messageController.text,
      number: _phoneController.text,
    );
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    _phoneController.clear();
    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Ask Imam',
          style: TextStyle(color: Colors.white, fontFamily: popinsMedium),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: Get.back,
        ),
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Have a question/request for the Imam?',
              style: TextStyle(
                fontSize: 20,
                fontFamily: popinsRegulr,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Submit your question for the Imam below, He will provide an answer for this.',
              style: TextStyle(color: Colors.white70, fontFamily: popinsRegulr),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Name',
              hint: 'Your Name',
              controller: _nameController,
            ),
            _buildInputField(
              label: 'Email',
              hint: 'Enter Email',
              controller: _emailController,
            ),
            _buildInputField(
              label: 'Phone No.',
              hint: 'Enter phone number',
              controller: _phoneController,
            ),
            Row(
              children: [
                Expanded(
                    child: Obx(
                  () => GestureDetector(
                    onTap: () => _askImamController.selectedOption.value = 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5),
                      child: Container(
                        height: 47,
                        decoration: BoxDecoration(
                            color: _askImamController.selectedOption.value == 0
                                ? secondaryColor
                                : whiteColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'Ask a Question',
                          style: TextStyle(
                              color: whiteColor,
                              fontFamily: popinsRegulr,
                              fontSize: 12),
                        )),
                      ),
                    ),
                  ),
                )),
                Expanded(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        _askImamController.selectedOption.value = 1;
                        const String calendlyUrl =
                            "https://calendly.com/imammak/30min";
                        AppClass().launchURL(calendlyUrl);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 5),
                        child: Container(
                          height: 47,
                          decoration: BoxDecoration(
                              color:
                                  _askImamController.selectedOption.value == 1
                                      ? secondaryColor
                                      : whiteColor.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Book a Appointment',
                                  style: TextStyle(
                                      fontFamily: popinsRegulr,
                                      color: whiteColor,
                                      fontSize: 12),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: whiteColor,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Obx(
              () => _askImamController.selectedOption.value == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Align(
                            alignment: Alignment.centerLeft,
                            child: _buildDropdownField(
                              label: 'Question',
                              hint: 'Select  Type',
                              value: _selectedQuestionType.value,
                              onChanged: (newValue) =>
                                  _selectedQuestionType.value = newValue!,
                            ),
                          ),
                        ),
                        _buildInputField(
                          label: 'Message',
                          hint: 'Your Message',
                          maxLines: 4,
                          controller: _messageController,
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00A559),
                                    Color(0xFF006627)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _askImamController.isLoading.value
                                    ? null
                                    : _submitForm,
                                child: _askImamController.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: popinsMedium,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                      ],
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 14,
              color: Color(0xFF158549),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            cursorColor: primaryColor,
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Colors.black26, fontFamily: popinsRegulr),
              filled: true,
              fillColor: lightColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: popinsRegulr,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: primaryColor,
                hint: Text(
                  hint,
                  style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: popinsRegulr,
                      fontSize: 12),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                value: value.isEmpty ? null : value,
                items: [
                  'General Question',
                  'Request for Dua',
                  'Religious Advice',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: popinsRegulr,
                          fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
