import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_controller.dart';
import '../model/quran_audio_model.dart';
import '../constants/color.dart';

class AudioPlayerBar2 extends StatelessWidget {
  final AudioPlayerController audioPlayerController;
  final bool isPlaying;
  final AudioFile? currentAudio;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onStop;
  final String totalVerseCount;

  const AudioPlayerBar2({
    super.key,
    required this.audioPlayerController,
    required this.isPlaying,
    required this.currentAudio,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onStop,
    required this.totalVerseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 90),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              totalVerseCount,
              style: TextStyle(fontFamily: popinsMedium, color: whiteColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlaybackSpeedControl(),
                Row(
                  children: [
                    _buildIconButton(Icons.skip_previous, onPrevious),
                    _buildIconButton(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      onPlayPause,
                      size: 40,
                    ),
                    _buildIconButton(Icons.stop, onStop,
                        size: 40), // Stop button
                    _buildIconButton(Icons.skip_next, onNext),
                  ],
                ),
                // Close player button
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onStop,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => _buildProgressBar()),
          ],
        ),
      ),
    );
  }

  /// Builds the playback speed toggle button.
  Widget _buildPlaybackSpeedControl() {
    return Obx(() {
      final playbackSpeed = audioPlayerController.playbackSpeed.value;
      return GestureDetector(
        onTap: _togglePlaybackSpeed,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
            child: Text(
              '${playbackSpeed}x',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      );
    });
  }

  /// Builds an icon button with the specified icon and action.
  Widget _buildIconButton(IconData icon, VoidCallback onPressed,
      {double size = 24}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: size),
      onPressed: onPressed,
    );
  }

  /// Builds the progress bar.
  Widget _buildProgressBar() {
    final progress = audioPlayerController.progress.value;
    final duration = audioPlayerController.duration.value;

    return SizedBox(
      width: double.maxFinite,
      height: 5,
      child: LinearProgressIndicator(
        value: (duration > 0) ? (progress / duration).clamp(0.0, 1.0) : 0,
        backgroundColor: Colors.white.withOpacity(0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  /// Toggles playback speed.
  void _togglePlaybackSpeed() {
    final speeds = [0.5, 1.0, 1.5, 2.0];
    final currentSpeed = audioPlayerController.playbackSpeed.value;
    final nextSpeed =
        speeds[(speeds.indexOf(currentSpeed) + 1) % speeds.length];
    audioPlayerController.setPlaybackSpeed(nextSpeed);
  }
}
