import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/model/quran_audio_model.dart';
import 'package:community_islamic_app/widgets/myText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

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
                child: Center(
                    child: IconButton(
                        splashColor: primaryColor,
                        onPressed: widget.onTap1,
                        icon: Image.asset(
                          widget.firstIcon,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                          color: primaryColor,
                        ))),
              ),
            ),
          ),
          // 10.widthBox,
          SizedBox(
            width: 10,
          ),
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
                        ? SpinKitFadingCircle(
                            color: primaryColor,
                          )
                        : IconButton(
                            splashColor: primaryColor,
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
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              children: [
                MyText(
                  widget.surahTxet,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: jameelNori2,
                  ),
                ),
                MyText(
                  widget.surahNameEng,
                  style: const TextStyle(
                    // fontSize: 18,
                    fontFamily: popinsMedium,
                  ),
                ),
              ],
            ),
          ),
          // 10.widthBox,
          SizedBox(
            height: 10,
          ),
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
          // 10.widthBox,
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
