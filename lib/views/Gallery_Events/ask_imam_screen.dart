import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import '../../controllers/askImamController.dart';
// import 'ask_imam_controller.dart'; // Import the controller

class AskImamPage extends StatefulWidget {
  @override
  _AskImamPageState createState() => _AskImamPageState();
}

class _AskImamPageState extends State<AskImamPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedQuestionType;

  final AskImamController _askImamController = Get.put(AskImamController());

  void _submitForm() {
    // Validate input fields
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedQuestionType == null ||
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

    // Call the controller method to submit the form
    _askImamController.submitForm(
      number: _phoneController.text,
      name: _nameController.text,
      emailPhone: _emailController.text,
      message: _messageController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Ask Imam',
          style: TextStyle(color: Colors.white, fontFamily: popinsMedium),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Have a question/request for the Imam?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: popinsRegulr,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Submit your question for the Imam below, He will provide an answer for this.',
                style:
                    TextStyle(color: Colors.white70, fontFamily: popinsRegulr),
              ),
              SizedBox(height: 20),
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
              _buildDropdownField(
                label: 'Question',
                hint: 'Select Question Type',
                value: _selectedQuestionType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedQuestionType = newValue;
                  });
                },
              ),
              _buildInputField(
                label: 'Message',
                hint: 'Your Message',
                maxLines: 4,
                controller: _messageController,
              ),
              SizedBox(height: 16),
              Obx(() {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF00A559), Color(0xFF006627)],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _askImamController.isLoading.value
                          ? null
                          : _submitForm,
                      child: _askImamController.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: popinsMedium),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
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
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 14,
              color: Color(0xFF158549),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(color: Colors.black26, fontFamily: popinsRegulr),
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
    required String? value,
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
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: popinsRegulr),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: primaryColor,
                hint: Text(
                  hint,
                  style: TextStyle(
                      color: Colors.white54, fontFamily: popinsRegulr),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
                value: value,
                items: [
                  'General Question',
                  'Request for Dua',
                  'Religious Advice'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Colors.white, fontFamily: popinsRegulr),
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
