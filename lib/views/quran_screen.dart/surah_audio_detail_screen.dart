import 'dart:async';
import 'dart:io';
import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:community_islamic_app/controllers/audio_controller.dart';
import 'package:community_islamic_app/controllers/quran_controller.dart';
import 'package:community_islamic_app/model/surah_detail_model.dart';
import 'package:community_islamic_app/widgets/audio_player_bar_widget.dart';
import 'package:dio/dio.dart';

import '../../model/quran_audio_model.dart';
import '../../model/surah_english_model.dart';

class SurahDetailsScreen extends StatefulWidget {
  final int surahNumber;
  final Surah surahM;
  final String surahName;
  final int surahVerseCount;
  final String verse;
  final String englishVerse;
  final AudioFile audioPlayerUrl;
  final List<Ayah> surahVerse;
  final List<Result> surahVerseEng;

  SurahDetailsScreen({
    Key? key,
    required this.surahM,
    required this.surahVerseEng,
    required this.surahVerse,
    required this.audioPlayerUrl,
    required this.surahName,
    required this.surahNumber,
    required this.surahVerseCount,
    required this.englishVerse,
    required this.verse,
  }) : super(key: key);

  @override
  _SurahDetailsScreenState createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  late AudioPlayerController audioController;
  late QuranController quranController;
  late ScrollController scrollController;
  int currentIndex = 0; // To track the current Ayah index
  Timer? autoScrollTimer; // Timer for automatic scrolling
  bool isDownloading = false;
  double downloadProgress = 0.0;
  bool isAudioDownloaded = false;

  @override
  void initState() {
    super.initState();
    audioController = Get.find();
    quranController = Get.find();
    scrollController = ScrollController();
    checkIfAudioDownloaded();
    // playCurrentAyahAudio();
    scrollToCurrentAyah();
  }

  void checkIfAudioDownloaded() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${widget.surahName}.mp3';
    setState(() {
      isAudioDownloaded = File(filePath).existsSync();
    });
  }

  void playCurrentAyahAudio() {
    final ayah = widget.surahVerse[currentIndex];
    final audioFile = quranController.audioFiles.firstWhere(
      (audio) => audio.chapterId == widget.surahNumber,
      orElse: () {
        print(
            'Audio file not found for Ayah ${ayah.numberInSurah} in Surah ${widget.surahNumber}');
        return AudioFile(
          id: 0,
          chapterId: widget.surahNumber,
          fileSize: 0,
          format: Format.MP3,
          audioUrl: '',
        );
      },
    );

    if (audioFile.audioUrl.isNotEmpty) {
      audioController.playOrPauseAudio(audioFile);
    }
  }

  void scrollToCurrentAyah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent *
          (currentIndex / widget.surahVerse.length));
    });
  }

  void playNextAyah() {
    if (currentIndex < widget.surahVerse.length - 1) {
      setState(() {
        currentIndex++;
        scrollToCurrentAyah();
      });
    }
  }

  void playPreviousAyah() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        scrollToCurrentAyah();
        playCurrentAyahAudio();
      });
    }
  }

  Future<void> downloadSurahAudio() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final audioFile = quranController.audioFiles.firstWhere(
        (audio) => audio.chapterId == widget.surahNumber,
        orElse: () => AudioFile(
          id: 0,
          chapterId: widget.surahNumber,
          fileSize: 0,
          format: Format.MP3,
          audioUrl: '',
        ),
      );

      if (audioFile.audioUrl.isNotEmpty) {
        final savePath = '${dir.path}/${widget.surahName}.mp3';

        await dio.download(
          audioFile.audioUrl,
          savePath,
          onReceiveProgress: (received, total) {
            setState(() {
              downloadProgress = (received / total) * 100;
            });
          },
        );

        setState(() {
          isDownloading = false;
          isAudioDownloaded = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: ${widget.surahName}')),
        );
      }
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primaryColor,
        title: Text(
          '${widget.surahNumber}. ${widget.surahName}',
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: popinsSemiBold),
        ),
        actions: [
          isDownloading
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress / 100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : isAudioDownloaded
                  ? IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                            'Audio already downloaded',
                            style: TextStyle(fontFamily: popinsMedium),
                          )),
                        );
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: downloadSurahAudio,
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${widget.surahVerseCount} verses | ${widget.englishVerse}',
                    style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontFamily: popinsMedium),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.surahVerse.length,
                      itemBuilder: (context, index) {
                        final ayah = widget.surahVerse[index];
                        final translation =
                            quranController.translationData.firstWhere(
                          (t) => t.aya == ayah.numberInSurah.toString(),
                          orElse: () => Result(
                            id: '',
                            sura: '',
                            aya: '',
                            arabicText: '',
                            translation: '',
                            footnotes: '',
                          ),
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Ayah ${ayah.numberInSurah}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontFamily: popinsRegulr),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ayah.text,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: jameelNori2),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    translation.translation,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                        fontFamily: popinsRegulr),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            return AudioPlayerBar(
              totalVerseCount: 'Verses ${widget.surahVerse.length}',
              audioPlayerController: audioController,
              isPlaying: audioController.isPlaying.value,
              currentAudio: audioController.currentAudio.value,
              onPlayPause: () {
                final audioFile = quranController.audioFiles.firstWhere(
                  (audio) =>
                      audio.chapterId == widget.surahNumber &&
                      audio.format == Format.MP3,
                  orElse: () => AudioFile(
                    id: 0,
                    chapterId: widget.surahNumber,
                    fileSize: 0,
                    format: Format.MP3,
                    audioUrl: '',
                  ),
                );

                if (audioFile.audioUrl.isNotEmpty) {
                  audioController.playOrPauseAudio(audioFile);
                }
              },
              onNext: playNextAyah,
              onPrevious: playPreviousAyah,
              onStop: audioController.stopAudio,
            );
          }),
        ],
      ),
    );
  }
}
