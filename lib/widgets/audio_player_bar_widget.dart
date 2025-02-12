import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildControlButtons(),
          const SizedBox(height: 8),
          Obx(() => _buildProgressBar(context)),
          const SizedBox(height: 4),
          Obx(() => _buildTimeDisplay()),
          const SizedBox(height: 8),
          _buildRepeatButton(),
        ],
      ),
    );
  }

  /// Builds the header displaying the Surah name, total verse count, and artist name.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surahName,
              style: TextStyle(
                  fontSize: 16, fontFamily: popinsMedium, color: whiteColor),
            ),
            Text(
              totalVerseCount ?? '',
              style: const TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: popinsMedium),
            ),
            const SizedBox(height: 5),
            Text(
              artistName ?? '',
              style: const TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: popinsMedium),
            ),
          ],
        ),
        _buildPlaybackSpeedButton(),
      ],
    );
  }

  /// Builds the playback speed toggle button.
  Widget _buildPlaybackSpeedButton() {
    return Obx(() {
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Text(
                '${audioPlayerController.playbackSpeed.value}x',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: popinsRegulr),
              ),
              onPressed: audioPlayerController.toggleSpeed,
            ),
          ),
        ),
      );
    });
  }

  /// Builds the control buttons (Play/Pause, Stop, Next, Previous).
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(Icons.skip_previous, onPrevious),
        _buildIconButton(
            isPlaying ? Icons.pause : Icons.play_arrow, onPlayPause),
        _buildIconButton(Icons.stop, onStop),
        _buildIconButton(Icons.skip_next, onNext),
      ],
    );
  }

  /// Builds a single control button.
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 35),
      onPressed: onPressed,
    );
  }

  /// Builds the progress bar.
  Widget _buildProgressBar(BuildContext context) {
    final progress = audioPlayerController.progress.value;
    final duration = audioPlayerController.bufferedDuration.value;

    return Container(
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
            right: (1 - (progress / (duration > 0 ? duration : 1))) *
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
    );
  }

  /// Builds the time display (current time / total duration).
  Widget _buildTimeDisplay() {
    final progress = audioPlayerController.progress.value;
    final duration = audioPlayerController.bufferedDuration.value;

    return Row(
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
    );
  }

  /// Builds the repeat button.
  Widget _buildRepeatButton() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              audioPlayerController.isRepeating.value
                  ? Icons.repeat_one_on_outlined
                  : Icons.repeat_one,
              color: Colors.white,
            ),
            onPressed: audioPlayerController.toggleRepeat,
          ),
          const SizedBox(width: 8),
        ],
      );
    });
  }

  /// Formats duration into a MM:SS string.
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
