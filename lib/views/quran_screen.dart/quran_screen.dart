import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/quran_controller.dart';
import 'package:community_islamic_app/model/quran_model.dart';
import 'package:community_islamic_app/views/quran_screen.dart/surah_details.dart';
import 'package:community_islamic_app/widgets/customized_surah_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/image_constants.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/login_controller.dart';
import '../../model/quran_audio_model.dart';
import '../../widgets/audio_player_bar_quran.dart';
import 'surah_audio_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

var loginConrtroller = Get.find<LoginController>();

class _QuranScreenState extends State<QuranScreen> {
  final QuranController quranController = Get.put(QuranController());

  final AudioPlayerController audioController =
      Get.put(AudioPlayerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (quranController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (quranController.chapters.isEmpty) {
          return const Center(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Column(
          children: [
            // Header Section
            SizedBox(
              height: screenHeight * .25,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        height: screenHeight * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: const DecorationImage(
                            image: AssetImage(qiblaTopBg), // Background image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.10,
                    left: screenHeight * 0.15,
                    child: Text(
                      'Quran',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: popinsBold),
                    ),
                  ),
                ],
              ),
            ),
            // List of Surahs
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: quranController.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = quranController.chapters[index];
                    final surah =
                        quranController.getSurahByChapterId(chapter.id);

                    var audioFile = quranController.audioFiles.firstWhere(
                      (audio) => audio.chapterId == chapter.id,
                      orElse: () => AudioFile(
                        id: 0,
                        chapterId: 0,
                        fileSize: 0,
                        format: Format.MP3,
                        audioUrl: '',
                      ),
                    );

                    // if (players.length <= index) {
                    //   players.add(AudioPlayer());
                    // }

                    return SizedBox(
                      height: 70,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomizedSurahWidget(
                            surahNameEng: surah!.englishName,
                            audioFile: audioFile,
                            onTap1: () async {
                              print('----Surah-------');
                              await quranController
                                  .fetchTranslationData(chapter.id);
                              Get.to(
                                () => OnlySurahDetailsScreen(
                                  surahM: surah!,
                                  surahVerseEng:
                                      quranController.translationData,
                                  surahVerse: surah.ayahs,
                                  surahName: surah.name,
                                  surahNumber: surah.number,
                                  surahVerseCount: surah.ayahs.length,
                                  englishVerse: surah.englishName,
                                  verse: surah.name,
                                ),
                              );
                            },
                            firstIcon: quranIcon,
                            surahTxet: surah?.name ?? 'Surah not found',
                            thirdIcon: chapter.revelationPlace ==
                                    RevelationPlace.MAKKAH
                                ? kabbaIcon
                                : masjidIcon,
                            surahNumber: chapter.id,
                            onTapNavigation: () async {
                              if (surah != null) {
                                await quranController
                                    .fetchTranslationData(chapter.id);
                                Get.to(
                                  () => SurahDetailsScreen(
                                    surahM: surah,
                                    surahVerseCount: surah.ayahs.length,
                                    surahVerseEng:
                                        quranController.translationData,
                                    audioPlayerUrl: audioFile,
                                    surahName: surah.name,
                                    surahNumber: surah.number,
                                    englishVerse: surah.englishName,
                                    verse: surah.name,
                                    surahVerse: surah.ayahs,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            50.heightBox,
            // Audio Player Bar
            Obx(() => audioController.isPlaying.value ||
                    audioController.currentAudio.value != null
                ? AudioPlayerBar2(
                    audioPlayerController: audioController,
                    isPlaying: audioController.isPlaying.value,
                    currentAudio: audioController.currentAudio.value,
                    onPlayPause: () => audioController
                        .playOrPauseAudio(audioController.currentAudio.value!),
                    onNext: () => audioController
                        .playNextAudio(quranController.audioFiles),
                    onPrevious: () => audioController
                        .playPreviousAudio(quranController.audioFiles),
                    onStop: () =>
                        audioController.stopAudio(), // Stop button callback
                    totalVerseCount: '',
                  )
                : SizedBox.shrink()),
          ],
        );
      }),
    );
  }
}
