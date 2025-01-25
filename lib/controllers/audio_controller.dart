import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../model/quran_audio_model.dart';
import 'package:audio_service/audio_service.dart';
import '../views/audio_screen/audio_handler.dart';

class AudioPlayerController extends GetxController {
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var progress = 0.0.obs;
  var buffereDuration = 1.0.obs;
  var duration = 1.0.obs;
  var playbackSpeed = 1.0.obs;
  var isRepeating = false.obs;
  var currentAudio = Rxn<AudioFile>();

  AudioPlayerHandler? _audioHandler;
  final List<double> speedOptions = [0.5, 1.0, 1.5, 2.0];
  var isAudioHandlerInitialized = false.obs;

  AudioPlayer bismillahAudioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _initAudioService();
    _initBismillahAudioPlayer();
  }

  @override
  void onClose() {
    _disposeAudioService();
    _disposeBismillahAudioPlayer();
    super.onClose();
  }

  Future<void> _initAudioService() async {
    try {
      await AudioService.stop();

      _audioHandler = await AudioService.init(
        builder: () => AudioPlayerHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.community.islamic.app',
          androidNotificationChannelName: 'adhan_channel',
          androidNotificationOngoing: true,
        ),
      );

      isAudioHandlerInitialized.value = true;

      _audioHandler?.playbackState.listen((playbackState) {
        isPlaying.value = playbackState.playing;
        progress.value = playbackState.position.inMilliseconds.toDouble();
        buffereDuration.value =
            playbackState.bufferedPosition.inMilliseconds.toDouble();
        playbackSpeed.value = playbackState.speed;
        print('Playback State Updated: $playbackState');
      });

      _audioHandler?.mediaItem.listen((mediaItem) {
        if (mediaItem != null) {
          currentAudio.value = AudioFile(
            id: mediaItem.hashCode,
            audioUrl: mediaItem.id,
            chapterId: mediaItem.hashCode,
            fileSize: 1122,
            format: Format.MP3,
          );
          print('Media Item Updated: ${currentAudio.value}');
        }
      });
    } catch (e) {
      print('Error initializing audio service: $e');
    }
  }

  Future<void> _initBismillahAudioPlayer() async {
    try {
      await bismillahAudioPlayer.setAsset("assets/bismillah.mp3");
    } catch (e) {
      print('Error initializing bismillahAudioPlayer: $e');
    }
  }

  Future<void> _disposeAudioService() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
      _audioHandler = null;
      isAudioHandlerInitialized.value = false;
    }
  }

  void _disposeBismillahAudioPlayer() {
    try {
      if (bismillahAudioPlayer.playing) {
        bismillahAudioPlayer.stop();
      }
      bismillahAudioPlayer.dispose();
    } catch (e) {
      print('Error disposing bismillahAudioPlayer: $e');
    }
  }

  Future<void> playOrPauseAudio(AudioFile? audio) async {
    if (audio == null) {
      print('No audio file provided');
      return;
    }

    if (!isAudioHandlerInitialized.value) {
      print('AudioHandler is not initialized yet');
      return;
    }

    try {
      if (currentAudio.value?.id == audio.id) {
        if (isPlaying.value) {
          await _audioHandler!.pause();
          isPlaying.value = false;
        } else {
          await _audioHandler!.play();
          isPlaying.value = true;
        }
      } else {
        currentAudio.value = audio;
        progress.value = 0.0;
        buffereDuration.value = 1.0;

        await _audioHandler!.stop();
        EasyLoading.show(status: "Loading...");
        await _audioHandler!.setAudioFile(audio);
        duration.value = (await _audioHandler?.getDuration(audio.audioUrl))
                ?.inMilliseconds
                .toDouble() ??
            1.0;
        EasyLoading.dismiss();

        if (bismillahAudioPlayer.playing ||
            bismillahAudioPlayer.playerState.processingState ==
                ProcessingState.completed) {
          await bismillahAudioPlayer.stop();
        }

        if (audio.chapterId != 1) {
          await bismillahAudioPlayer.play();
        }

        await _audioHandler!.play();
        isPlaying.value = true;
      }
    } catch (e) {
      print('Error playing or pausing audio: $e');
      EasyLoading.dismiss();
    }
  }

  Future<void> pauseAudio() async {
    if (!isAudioHandlerInitialized.value) {
      print('AudioHandler is not initialized yet');
      return;
    }

    try {
      if (isPlaying.value) {
        await _audioHandler!.pause();
        isPlaying.value = false;
      }
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    if (!isAudioHandlerInitialized.value) {
      print('AudioHandler is not initialized yet');
      return;
    }

    try {
      await _audioHandler!.stop();
      isPlaying.value = false;
      currentAudio.value = null;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  Future<void> playNextAudio(RxList<AudioFile> audioFiles) async {
    if (currentAudio.value == null) return;

    int currentIndex =
        audioFiles.indexWhere((audio) => audio.id == currentAudio.value!.id);
    if (currentIndex == -1 || currentIndex == audioFiles.length - 1) return;

    AudioFile nextAudio = audioFiles[currentIndex + 1];
    await playOrPauseAudio(nextAudio);
  }

  Future<void> playPreviousAudio(RxList<AudioFile> audioFiles) async {
    if (currentAudio.value == null) return;

    int currentIndex =
        audioFiles.indexWhere((audio) => audio.id == currentAudio.value!.id);
    if (currentIndex <= 0) return;

    AudioFile previousAudio = audioFiles[currentIndex - 1];
    await playOrPauseAudio(previousAudio);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    try {
      playbackSpeed.value = speed;
      if (isPlaying.value && _audioHandler != null) {
        await _audioHandler!.setSpeed(speed);
      }
    } catch (e) {
      print('Error setting playback speed: $e');
    }
  }

  void toggleSpeed() {
    int currentIndex = speedOptions.indexOf(playbackSpeed.value);
    int nextIndex = (currentIndex + 1) % speedOptions.length;
    setPlaybackSpeed(speedOptions[nextIndex]);
  }

  void toggleRepeat() {
    isRepeating.value = !isRepeating.value;
    if (_audioHandler != null) {
      _audioHandler!.setRepeatMode(
        isRepeating.value
            ? AudioServiceRepeatMode.one
            : AudioServiceRepeatMode.none,
      );
    }
  }
}
