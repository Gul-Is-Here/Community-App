import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/constants/image_constants.dart';
import 'package:community_islamic_app/views/auth_screens/login_screen.dart';
import 'package:community_islamic_app/controllers/registration_controller.dart';

class RegistrationScreen extends StatelessWidget {
  // Initialize the controller
  final RegistrationController registrationController =
      Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * .35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(splash), fit: BoxFit.cover)),
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
                    padding: const EdgeInsets.only(top: 250),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(splash4), fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              50.heightBox,
                              const Text(
                                'Register',
                                style: TextStyle(
                                    fontFamily: popinsRegulr,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              30.heightBox,
                              // First Name
                              TextFormField(
                                cursorColor: primaryColor,
                                onChanged: (value) => registrationController
                                    .firstName.value = value,
                                decoration: InputDecoration(
                                    labelText: 'First Name',
                                    prefix: Text(
                                      '***   ',
                                      style: TextStyle(
                                          fontFamily: popinsSemiBold,
                                          color: primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: primaryColor),
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
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                              20.heightBox,
                              // Last Name
                              TextFormField(
                                cursorColor: primaryColor,
                                onChanged: (value) => registrationController
                                    .lastName.value = value,
                                decoration: InputDecoration(
                                    prefix: Text(
                                      '***   ',
                                      style: TextStyle(
                                          fontFamily: popinsSemiBold,
                                          color: primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: primaryColor),
                                    labelText: 'Last Name',
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
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                              20.heightBox,
                              // Email
                              TextFormField(
                                cursorColor: primaryColor,
                                onChanged: (value) =>
                                    registrationController.email.value = value,
                                decoration: InputDecoration(
                                    labelText: 'Email',
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
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                              20.heightBox,
                              // Username
                              TextFormField(
                                onChanged: (value) => registrationController
                                    .username.value = value,
                                decoration: InputDecoration(
                                    prefix: Text(
                                      '***   ',
                                      style: TextStyle(
                                          fontFamily: popinsSemiBold,
                                          color: primaryColor),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: popinsRegulr,
                                        color: primaryColor),
                                    labelText: 'Username',
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
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                              20.heightBox,
                              // Register Button
                              Center(
                                child: Obx(
                                  () => registrationController.isLoading.value
                                      ? SpinKitFadingCircle(
                                          color: primaryColor,
                                          size: 50.0,
                                        ) // Loading indicator
                                      : SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 5,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    30))),
                                                backgroundColor: primaryColor,
                                              ),
                                              onPressed: registrationController
                                                  .registerUser,
                                              child: Text(
                                                'Register',
                                                style: TextStyle(
                                                    fontFamily: popinsBold,
                                                    color: Colors.white),
                                              )),
                                        ),
                                ),
                              ),
                              10.heightBox,
                              // Sign In Redirect
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: TextStyle(fontFamily: popinsRegulr),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(() => LoginScreen());
                                      },
                                      child: Text(
                                        ' Sign In',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: popinsRegulr,
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
