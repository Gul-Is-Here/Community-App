import 'package:community_islamic_app/controllers/quran_controller.dart';
import 'package:community_islamic_app/views/RamadanScreen/ramadanScreen.dart';
import 'package:community_islamic_app/views/home_screens/comming_soon_screen.dart';
import 'package:community_islamic_app/views/home_screens/home_screen.dart';
import 'package:community_islamic_app/views/home_screens/masjid_map/map_splash_screen.dart';
// import 'package:community_islamic_app/views/ramadan_screen/ramadan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/image_constants.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../widgets/audio_player_bar_quran.dart';
import '../../widgets/customized_bottom_bar.dart';
import '../donation_screens/donation_screen.dart';
import '../qibla_screen/qibla_screen.dart';
import '../quran_screen.dart/quran_screen.dart';
import 'masjid_map/order_traking_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Variables for draggable FloatingActionButton position
  late Offset _fabPosition;

  @override
  void initState() {
    super.initState();
    // Initialize the FloatingActionButton position to bottom-center
    _fabPosition = Offset(
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width / 2 -
          40,
      // ignore: deprecated_member_use
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.height - 160,
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final quranController = Get.put(QuranController());
    final AudioPlayerController audioController =
        Get.put(AudioPlayerController());

    final List<Widget> _pages = [
      const HomeScreen(),
      QiblahScreen(
        isNavigation: false,
      ),
      const QuranScreen(
        isNavigation: false,
      ),
      RamadanScreen(),
      DonationScreen()
    ];

    return Scaffold(
      body: Obx(() => Stack(
            children: [
              // Main pages
              _pages[controller.selectedIndex.value],

              // Bottom Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomNavigationBar(controller: controller),
              ),

              // Audio Player Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(() => audioController.isPlaying.value ||
                        audioController.currentAudio.value != null
                    ? AudioPlayerBar2(
                        audioPlayerController: audioController,
                        isPlaying: audioController.isPlaying.value,
                        currentAudio: audioController.currentAudio.value,
                        onPlayPause: () => audioController.playOrPauseAudio(
                            audioController.currentAudio.value),
                        onNext: () => audioController
                            .playNextAudio(quranController.audioFiles),
                        onPrevious: () => audioController
                            .playPreviousAudio(quranController.audioFiles),
                        onStop: () =>
                            audioController.stopAudio(), // Stop button callback
                        totalVerseCount: quranController
                            .getSurahByChapterId(
                                audioController.currentAudio.value!.chapterId)!
                            .name,
                      )
                    : SizedBox.shrink()),
              ),

              // Draggable FloatingActionButton
            ],
          )),
    );
  }

  // FloatingActionButton builder
}
