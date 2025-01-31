import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
import '../controllers/audio_controller.dart';
import '../model/quran_audio_model.dart';

class AudioPlayerBar extends StatelessWidget {
  final AudioPlayerController audioPlayerController;
  final bool isPlaying;
  final AudioFile? currentAudio;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final String? totalVerseCount;
  final String? artistName;
  final String surahName;

  const AudioPlayerBar({
    super.key,
    required this.surahName,
    required this.audioPlayerController,
    required this.isPlaying,
    required this.currentAudio,
    required this.onPlayPause,
    required this.onStop,
    required this.onNext,
    required this.onPrevious,
    this.artistName,
    this.totalVerseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final progress = audioPlayerController.progress.value;
      final duration = audioPlayerController.buffereDuration.value;
      final isRepeating = audioPlayerController.isRepeating.value;
      final playbackSpeed = audioPlayerController.playbackSpeed.value;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: popinsMedium,
                          color: whiteColor),
                    ),
                    Text(
                      totalVerseCount ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: popinsMedium),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      artistName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: popinsMedium),
                    ),
                  ],
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Text(
                          '$playbackSpeed x',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: popinsRegulr),
                        ),
                        onPressed: audioPlayerController.toggleSpeed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: onPrevious,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: onPlayPause,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: onStop,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: onNext,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 4.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: const LinearGradient(
                  colors: [Colors.greenAccent, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: (1 - (progress / duration)) *
                        MediaQuery.of(context).size.width,
                    child: Container(
                      height: 4.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: lightColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(Duration(milliseconds: progress.toInt())),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  formatDuration(Duration(milliseconds: duration.toInt())),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isRepeating
                        ? Icons.repeat_one_on_outlined
                        : Icons.repeat_one,
                    color: Colors.white,
                  ),
                  onPressed: audioPlayerController.toggleRepeat,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      );
    });
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
