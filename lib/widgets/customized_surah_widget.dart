import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/model/quran_audio_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/audio_controller.dart';

class CustomizedSurahWidget extends StatefulWidget {
  const CustomizedSurahWidget(
      {super.key,
      required this.onTap1,
      required this.audioFile,
      required this.onTapNavigation,
      required this.firstIcon,
      required this.surahTxet,
      required this.thirdIcon,
      required this.surahNumber,
      required this.surahNameEng});

  final void Function() onTapNavigation;
  final void Function() onTap1;
  final AudioFile audioFile;
  final String firstIcon;
  final String surahTxet;
  final String thirdIcon;
  final int surahNumber;
  final String surahNameEng;

  @override
  State<CustomizedSurahWidget> createState() => _CustomizedSurahWidgetState();
}

class _CustomizedSurahWidgetState extends State<CustomizedSurahWidget> {
  // late IconData icon;

  @override
  void initState() {
    super.initState();
  }

  final AudioPlayerController audioController =
      Get.put(AudioPlayerController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTapNavigation();

        if (widget.audioFile.audioUrl.isNotEmpty) {
          await audioController.playOrPauseAudio(widget.audioFile);
        } else {
          print(
            'Audio file not found for chapter',
          );
        }
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: GestureDetector(
                  onTap: widget.onTap1,
                  child: Center(
                      child: Image.asset(
                    widget.firstIcon,
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                    color: primaryColor,
                  )),
                ),
              ),
            ),
          ),
          10.widthBox,
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Obx(
                  () => Center(
                    child: audioController.isLoading.value &&
                            audioController.currentAudio.value?.chapterId ==
                                widget.audioFile.chapterId
                        ? CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : IconButton(
                            onPressed: () async {
                              if (widget.audioFile.audioUrl.isNotEmpty) {
                                await audioController
                                    .playOrPauseAudio(widget.audioFile);
                              } else {
                                print(
                                  'Audio file not found for chapter',
                                );
                              }
                            },
                            icon: Icon(
                              // widget.audioPlayer.playerState.playing
                              audioController.isPlaying.value &&
                                      audioController
                                              .currentAudio.value?.chapterId ==
                                          widget.audioFile.chapterId
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 24,
                              color: primaryColor,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          10.widthBox,
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.surahTxet,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: jameelNori2,
                  ),
                ),
                Text(
                  widget.surahNameEng,
                  style: const TextStyle(
                    // fontSize: 18,
                    fontFamily: popinsMedium,
                  ),
                ),
              ],
            ),
          ),
          10.widthBox,
          Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.asset(
                      widget.thirdIcon,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ))),
          10.widthBox,
        ],
      ),
    );
  }
}
