import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskImamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Ask Imam',
          style: TextStyle(color: Colors.white, fontFamily: popinsMedium),
        ),
        // centerTitle: true,
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
              _buildInputField(label: 'Name', hint: 'Your Name'),
              _buildInputField(
                  label: 'Email/Phone No.', hint: 'Your Email or phone number'),
              _buildDropdownField(
                  label: 'Question', hint: 'Select Question Type'),
              _buildInputField(
                label: 'Message',
                hint: 'Your Message',
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Align(
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
                    onPressed: () {},
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: popinsMedium),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    int maxLines = 1,
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
                onChanged: (newValue) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
