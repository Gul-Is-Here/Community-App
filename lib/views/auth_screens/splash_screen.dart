import 'package:community_islamic_app/controllers/all_event_controller.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/controllers/home_events_controller.dart';
import 'package:community_islamic_app/controllers/qibla_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    HomeController();
    QiblahController();
    HomeEventsController();
    EventTypeController();
    _navigateToAppropriateScreen();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset('assets/video/splashvideo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
        _controller!.setLooping(true); // Loop video if required
      });
  }

  Future<void> _navigateToAppropriateScreen() async {
    await Future.delayed(const Duration(seconds: 5)); // Wait for 5 seconds

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAll(() => const Home());
    } else {
      Get.offAll(() => const Home());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          _controller != null && _controller!.value.isInitialized
              ? SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
