import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';
import '../../model/quran_audio_model.dart';

class AudioPlayerBar2 extends StatelessWidget {
  final AudioPlayerController audioPlayerController;
  final bool isPlaying;
  final AudioFile? currentAudio;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const AudioPlayerBar2({
    super.key,
    required this.audioPlayerController,
    required this.isPlaying,
    required this.currentAudio,
    required this.onPlayPause,
    required this.onStop,
    required this.onNext,
    required this.onPrevious, required String totalVerseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: onPrevious,
          ),
          Text(currentAudio != null ? currentAudio!.audioUrl : 'No Audio'),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: onPlayPause,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: onStop,
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
