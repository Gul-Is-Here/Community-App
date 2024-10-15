import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/controllers/login_controller.dart';
import 'package:community_islamic_app/views/auth_screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final RxBool _obscurePassword =
      true.obs; // Observable for password visibility

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the screen to resize when the keyboard opens
      body: SingleChildScrollView(
        // Enable scrolling to prevent keyboard from closing
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: screenHeight * .35,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(splash),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image.asset(
                            splash3,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 250, left: 0, right: 0, bottom: 0),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(splash4),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: screenHeight * .65,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                50.heightBox,
                                const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: popinsMedium,
                                      fontWeight: FontWeight.bold),
                                ),
                                30.heightBox,
                                TextFormField(
                                  onChanged: (value) =>
                                      loginController.email.value = value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'username',
                                    labelStyle: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: primaryColor),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 220, 217, 217),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 220, 217, 217),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 220, 217, 217),
                                      ),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                20.heightBox,
                                Obx(() => TextFormField(
                                      onChanged: (value) => loginController
                                          .password.value = value,
                                      obscureText: _obscurePassword.value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                            fontFamily: popinsRegulr,
                                            color: primaryColor),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: primaryColor,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            _obscurePassword.value =
                                                !_obscurePassword.value;
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 220, 217, 217),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 220, 217, 217),
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 220, 217, 217),
                                          ),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    )),
                                20.heightBox,
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forget Password?',
                                    style: TextStyle(
                                      fontFamily: popinsSemiBold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                20.heightBox,
                                Center(
                                  child: Obx(
                                    () => loginController.isLoading.value
                                        ? SpinKitFadingCircle(
                                            color: primaryColor,
                                            size: 50.0,
                                          ) // Loading indicator
                                        : Container(
                                            height: 50,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 5,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                backgroundColor: primaryColor,
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // If the form is valid, proceed with login
                                                  await loginController
                                                      .loginUser();
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool(
                                                      'isLoggedIn', true);
                                                }
                                              },
                                              child: const Text(
                                                'Login',
                                                style: TextStyle(
                                                    fontFamily: popinsSemiBold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                10.heightBox,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Create an account?',
                                      style:
                                          TextStyle(fontFamily: popinsRegulr),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => RegistrationScreen());
                                      },
                                      child: Text(
                                        ' Sign Up',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontFamily: popinsRegulr,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
