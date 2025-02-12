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
  var bufferedDuration = 1.0.obs;
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

  /// Initializes Audio Service
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
      isAudioHandlerInitialized(true);
      _setupListeners();
    } catch (e) {
      _logError('Error initializing audio service', e);
    }
  }

  /// Sets up audio state listeners
  void _setupListeners() {
    _audioHandler?.playbackState.listen((state) {
      isPlaying(state.playing);
      progress(state.position.inMilliseconds.toDouble());
      bufferedDuration(state.bufferedPosition.inMilliseconds.toDouble());
      playbackSpeed(state.speed);
    });

    _audioHandler?.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        currentAudio(AudioFile(
          id: mediaItem.hashCode,
          audioUrl: mediaItem.id,
          chapterId: mediaItem.hashCode,
          fileSize: 1122,
          format: Format.MP3,
        ));
      }
    });
  }

  /// Initializes Bismillah Audio Player
  Future<void> _initBismillahAudioPlayer() async {
    try {
      await bismillahAudioPlayer.setAsset("assets/bismillah.mp3");
    } catch (e) {
      _logError('Error initializing Bismillah Audio Player', e);
    }
  }

  /// Disposes Audio Service
  Future<void> _disposeAudioService() async {
    if (_audioHandler != null) {
      await _audioHandler!.stop();
      _audioHandler = null;
      isAudioHandlerInitialized(false);
    }
  }

  /// Disposes Bismillah Audio Player
  void _disposeBismillahAudioPlayer() {
    try {
      if (bismillahAudioPlayer.playing) bismillahAudioPlayer.stop();
      bismillahAudioPlayer.dispose();
    } catch (e) {
      _logError('Error disposing Bismillah Audio Player', e);
    }
  }

  /// Plays or pauses the given [audio]
  Future<void> playOrPauseAudio(AudioFile? audio) async {
    if (audio == null) {
      _logWarning('No audio file provided');
      return;
    }

    if (!isAudioHandlerInitialized.value) {
      _logWarning('AudioHandler is not initialized yet');
      return;
    }

    try {
      if (currentAudio.value?.id == audio.id) {
        if (isPlaying.value) {
          await _audioHandler?.pause(); // ✅ Wait for pause to complete
          isPlaying(false); // ✅ Update state only after completion
        } else {
          await _audioHandler?.play(); // ✅ Wait for play to complete
          isPlaying(true); // ✅ Update state only after completion
        }
      } else {
        await _prepareAndPlayAudio(audio);
      }
    } catch (e) {
      _logError('Error playing or pausing audio', e);
      EasyLoading.dismiss();
    }
  }

  /// Prepares and plays a new [audio] file
  Future<void> _prepareAndPlayAudio(AudioFile audio) async {
    currentAudio(audio);
    progress(0.0);
    bufferedDuration(1.0);

    await _audioHandler?.stop();
    EasyLoading.show(status: "Loading...");
    await _audioHandler?.setAudioFile(audio);
    duration((await _audioHandler?.getDuration(audio.audioUrl))
            ?.inMilliseconds
            .toDouble() ??
        1.0);
    EasyLoading.dismiss();

    await _playBismillahIfRequired(audio.chapterId);
    await _audioHandler?.play();
    isPlaying(true);
  }

  /// Plays Bismillah audio if required
  Future<void> _playBismillahIfRequired(int chapterId) async {
    if (bismillahAudioPlayer.playing ||
        bismillahAudioPlayer.processingState == ProcessingState.completed) {
      await bismillahAudioPlayer.stop();
    }
    if (chapterId != 1) {
      await bismillahAudioPlayer.play();
    }
  }

  /// Pauses audio
  Future<void> pauseAudio() async =>
      isPlaying.value ? await _audioHandler?.pause() : null;

  /// Stops audio playback
  Future<void> stopAudio() async {
    await _audioHandler?.stop();
    isPlaying(false);
    currentAudio.value = null;
  }

  /// Plays the next audio file
  Future<void> playNextAudio(RxList<AudioFile> audioFiles) async {
    int currentIndex =
        audioFiles.indexWhere((audio) => audio.id == currentAudio.value?.id);
    if (currentIndex != -1 && currentIndex < audioFiles.length - 1) {
      await playOrPauseAudio(audioFiles[currentIndex + 1]);
    }
  }

  /// Plays the previous audio file
  Future<void> playPreviousAudio(RxList<AudioFile> audioFiles) async {
    int currentIndex =
        audioFiles.indexWhere((audio) => audio.id == currentAudio.value?.id);
    if (currentIndex > 0) {
      await playOrPauseAudio(audioFiles[currentIndex - 1]);
    }
  }

  /// Sets playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    try {
      playbackSpeed(speed);
      if (isPlaying.value) {
        await _audioHandler?.setSpeed(speed);
      }
    } catch (e) {
      _logError('Error setting playback speed', e);
    }
  }

  /// Toggles playback speed
  void toggleSpeed() {
    int nextIndex =
        (speedOptions.indexOf(playbackSpeed.value) + 1) % speedOptions.length;
    setPlaybackSpeed(speedOptions[nextIndex]);
  }

  /// Toggles repeat mode
  void toggleRepeat() {
    isRepeating.toggle();
    _audioHandler?.setRepeatMode(
      isRepeating.value
          ? AudioServiceRepeatMode.one
          : AudioServiceRepeatMode.none,
    );
  }

  /// Logs errors
  void _logError(String message, dynamic error) =>
      print('[ERROR] $message: $error');

  /// Logs warnings
  void _logWarning(String message) => print('[WARNING] $message');
}
