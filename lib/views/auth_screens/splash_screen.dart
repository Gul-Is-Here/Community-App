import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:community_islamic_app/views/home_screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  final TokenService _tokenService = TokenService();
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _tokenService.generateAndStoreToken();
    _tokenService.handleTokenRefresh();
    _navigateToAppropriateScreen();
  }

  // Initialize the video player
  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset('assets/video/splashvideo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
        _controller!.setLooping(true); // Loop video if required
      });
  }

  // Navigate to the appropriate screen based on login state
  Future<void> _navigateToAppropriateScreen() async {
    await Future.delayed(const Duration(seconds: 7)); // Wait for 5 seconds

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAll(() => const Home());
    } else {
      Get.offAll(() => const Home()); // Replace with login screen if needed
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Video background with transparent background
          _controller != null && _controller!.value.isInitialized
              ? Container(
                  decoration: BoxDecoration(color: primaryColor),
                  child: SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: FittedBox(
                      fit: BoxFit
                          .cover, // Ensures the video covers the screen without stretching
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                )
              : Container(
                  color: primaryColor, // Fallback if video isn't loaded yet
                ),
        ],
      ),
    );
  }
}
