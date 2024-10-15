import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../model/quran_audio_model.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _audioPlayer = AudioPlayer();
  final _mediaItemSubject = BehaviorSubject<MediaItem?>();

  AudioPlayerHandler() {
    _init();
  }

  void _init() {
    _audioPlayer.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });

    _audioPlayer.playbackEventStream.listen((event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        playing: playing,
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
      ));
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });
  }

  Stream<MediaItem?> get mediaItemStream => _mediaItemSubject.stream;

  @override
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    super.stop();
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  Future<void> setAudioFile(AudioFile audioFile) async {
    final mediaItem = MediaItem(
      id: audioFile.audioUrl,
      album: 'Quran',
      title: audioFile.format.name,
      artist: 'Quran Recitation',
      duration: await getDuration(audioFile.audioUrl),
      artUri: Uri.parse(
          'https://example.com/cover.jpg'), // Replace with actual cover image
    );

    _mediaItemSubject.add(mediaItem);
    await _audioPlayer.setUrl(audioFile.audioUrl);
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      playing: true,
    ));
  }

  Future<Duration?> getDuration(String url) async {
    try {
      return await _audioPlayer.setUrl(url);
    } catch (e) {
      return null;
    }
  }
}
