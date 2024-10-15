import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/quran_audio_model.dart';
import '../model/quran_model.dart';
import '../model/surah_detail_model.dart';
import '../model/surah_english_model.dart';
import '../views/quran_screen.dart/surah_audio_detail_screen.dart';

class QuranController extends GetxController {
  var isLoading = false.obs;
  var chapters = <Chapter>[].obs;
  var audioFiles = <AudioFile>[].obs;
  var chapterId = 0.obs;
  var surahData = SurahModel(
    code: 0,
    status: '',
    data: Data(
      surahs: [],
      edition: Edition(
        identifier: '',
        language: '',
        name: '',
        englishName: '',
        format: '',
        type: '',
      ),
    ),
  ).obs;
  var translationData = <Result>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load chapters from cache or fetch from API
    String? chaptersJson = prefs.getString('chapters');
    if (chaptersJson != null) {
      chapters.value = List<Chapter>.from(
          json.decode(chaptersJson).map((x) => Chapter.fromJson(x)));
    } else {
      await fetchChapters();
    }

    // Load audio files from cache or fetch from API
    String? audioFilesJson = prefs.getString('audioFiles');
    if (audioFilesJson != null) {
      audioFiles.value = List<AudioFile>.from(
          json.decode(audioFilesJson).map((x) => AudioFile.fromJson(x)));
    } else {
      await fetchAudioFiles();
    }

    // Load surah data from cache or fetch from API
    String? surahDataJson = prefs.getString('surahData');
    if (surahDataJson != null) {
      surahData.value = SurahModel.fromJson(json.decode(surahDataJson));
    } else {
      await fetchSurahData();
    }
  }

  Future<void> fetchChapters() async {
    isLoading(true);
    try {
      final response =
          await http.get(Uri.parse('https://api.quran.com/api/v4/chapters'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        chapters.value = List<Chapter>.from(
            result['chapters'].map((x) => Chapter.fromJson(x)));

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('chapters', json.encode(result['chapters']));
      } else {
        throw Exception('Failed to load chapters');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAudioFiles() async {
    isLoading(true);
    try {
      final response = await http
          .get(Uri.parse('https://api.quran.com/api/v4/chapter_recitations/2'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        audioFiles.value = List<AudioFile>.from(
            result['audio_files'].map((x) => AudioFile.fromJson(x)));

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('audioFiles', json.encode(result['audio_files']));
      } else {
        throw Exception('Failed to load audio files');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSurahData() async {
    isLoading(true);
    try {
      final response = await http
          .get(Uri.parse('https://api.alquran.cloud/v1/quran/quran-uthmani'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        surahData.value = SurahModel.fromJson(result);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('surahData', json.encode(result));
      } else {
        throw Exception('Failed to load Surah data');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTranslationData(int chapterId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://quranenc.com/api/v1/translation/sura/english_saheeh/$chapterId'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        var translation = SurahAyatEnglisModel.fromJson(result);
        translationData.value = translation.result;
      } else {
        throw Exception('Failed to load translation data');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Surah? getSurahByChapterId(int chapterId) {
    return surahData.value.data.surahs
        .firstWhereOrNull((surah) => surah.number == chapterId);
  }

  Future<void> updateSurahDetails(
      int chapterId, Surah surah, AudioFile audio) async {
    if (surah != null) {
      await fetchTranslationData(chapterId); // Fetch translation data
      Get.to(() => SurahDetailsScreen(
            surahM: surah,
            surahVerseCount: surah.ayahs.length,
            surahVerseEng: translationData,
            audioPlayerUrl: audio,
            surahName: surah.name,
            surahNumber: surah.number,
            englishVerse: surah.englishName,
            verse: surah.name,
            surahVerse: surah.ayahs,
          ));
    }
  }

 

  Future<Surah> fetchSurahDetails(int chapterId) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.quran.com/api/v4/chapters/$chapterId'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return Surah.fromJson(
            result['data']); // Adjust based on your API response
      } else {
        throw Exception('Failed to load Surah details');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> updateSurahDetail(int chapterId) async {
    try {
      final surah = await fetchSurahDetails(chapterId);
      final audio = audioFiles.firstWhere(
        (audioFile) => audioFile.chapterId == chapterId,
        orElse: () => AudioFile(
            id: 0,
            chapterId: chapterId,
            fileSize: 0,
            format: Format.MP3,
            audioUrl: ''),
      );

      await fetchTranslationData(chapterId); // Fetch translation data

      Get.to(() => SurahDetailsScreen(
            surahM: surah,
            surahVerseCount: surah.ayahs.length,
            surahVerseEng:
                translationData, // Ensure this is fetched appropriately
            audioPlayerUrl: audio,
            surahName: surah.name,
            surahNumber: surah.number,
            englishVerse: surah.englishName,
            verse: surah.name,
            surahVerse: surah.ayahs,
          ));
    } catch (e) {
      print("Error: $e");
    }
  }
}
