import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final LoginController forgotPasswordController =
      Get.put(LoginController()); // Initialize the controller
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(fontFamily: popinsSemiBold, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Enter your registered email",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: GoogleFonts.poppins(color: primaryColor),
                  prefixIcon: Icon(Icons.email, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 220, 217, 217),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildCheckbox(
                  "Send Username", forgotPasswordController.sendUsername),
              _buildCheckbox(
                  "Send Password", forgotPasswordController.sendPassword),
              const SizedBox(height: 24),
              Obx(() {
                if (forgotPasswordController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                } else {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await forgotPasswordController.resetPassword(
                            email: _emailController.text,
                            sendUsername:
                                forgotPasswordController.sendUsername.value,
                            sendPassword:
                                forgotPasswordController.sendPassword.value,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 3,
                      ),
                      child: Text(
                        'Reset Password',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 20),
              Obx(() {
                if (forgotPasswordController.message.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: forgotPasswordController.message.value
                              .contains('Error')
                          ? Colors.red.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: forgotPasswordController.message.value
                                .contains('Error')
                            ? Colors.red.shade200
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Text(
                      forgotPasswordController.message.value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: forgotPasswordController.message.value
                                .contains('Error')
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Checkbox Widget
  Widget _buildCheckbox(String title, RxBool value) {
    return GestureDetector(
      onTap: () => value.toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: value.value,
                  onChanged: (bool? newValue) {
                    value.value = newValue ?? false;
                  },
                  activeColor: primaryColor,
                )),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
