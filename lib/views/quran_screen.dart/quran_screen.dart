import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/quran_controller.dart';
import 'package:community_islamic_app/model/quran_model.dart';
import 'package:community_islamic_app/views/quran_screen.dart/surah_details.dart';
import 'package:community_islamic_app/widgets/customized_surah_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../constants/image_constants.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/login_controller.dart';
import '../../model/quran_audio_model.dart';
import 'player_bar_screen.dart';
import 'surah_audio_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  final bool isNavigation;
  const QuranScreen({super.key, required this.isNavigation});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

var loginController = Get.find<LoginController>();

class _QuranScreenState extends State<QuranScreen> {
  final QuranController quranController = Get.put(QuranController());
  final AudioPlayerController audioController =
      Get.put(AudioPlayerController());
  final ScrollController scrollController = ScrollController();
  RxInt highlightedIndex = 0.obs; // To track the current Surah index

  @override
  void initState() {
    super.initState();

    // Listen to the scroll position of the ListView and update highlightedIndex
    scrollController.addListener(() {
      double offset = scrollController.offset;
      int currentIndex =
          (offset / 70).floor(); // Each Surah item is 70 pixels high
      highlightedIndex.value = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.isNavigation
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: whiteColor,
                ),
              )
            : SizedBox(),
        centerTitle: true,
        title: Text(
          'Listen/Read Quran',
          style: TextStyle(fontFamily: popinsSemiBold, color: whiteColor),
        ),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (quranController.isLoading.value) {
          return Center(
            child: SpinKitFadingCircle(
              color: primaryColor,
            ),
          );
        }

        if (quranController.chapters.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            // List of Surahs
            ListView.builder(
              controller: scrollController,
              itemCount: quranController.chapters.length,
              itemBuilder: (context, index) {
                final chapter = quranController.chapters[index];
                final surah = quranController.getSurahByChapterId(chapter.id);

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

                return SizedBox(
                  height: 70,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomizedSurahWidget(
                        surahNameEng: surah!.englishName,
                        audioFile: audioFile,
                        onTap1: () async {
                          await quranController
                              .fetchTranslationData(chapter.id);
                          Get.to(
                            () => OnlySurahDetailsScreen(
                              surahM: surah,
                              surahVerseEng: quranController.translationData,
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
                        surahTxet: surah.name ?? 'Surah not found',
                        thirdIcon:
                            chapter.revelationPlace == RevelationPlace.MAKKAH
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
                                surahVerseEng: quranController.translationData,
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
            // Side Line
            Obx(
              () => Positioned(
                left: 0,
                top: highlightedIndex.value *
                    70.0, // Adjust for each Surah height
                child: Container(
                  width: 5, // Width of the line
                  height: 200, // Match Surah height
                  color: primaryColor, // Highlight color
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
