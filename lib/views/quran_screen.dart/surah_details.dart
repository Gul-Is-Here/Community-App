import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/quran_controller.dart';
import '../../model/surah_detail_model.dart';
import '../../model/surah_english_model.dart';

class OnlySurahDetailsScreen extends StatefulWidget {
  final int surahNumber;
  final Surah surahM;
  final String surahName;
  final int surahVerseCount;
  final String verse;
  final String englishVerse;
  final List<Ayah> surahVerse;
  final List<Result> surahVerseEng;

  OnlySurahDetailsScreen({
    Key? key,
    required this.surahM,
    required this.surahVerseEng,
    required this.surahVerse,
    required this.surahName,
    required this.surahNumber,
    required this.surahVerseCount,
    required this.englishVerse,
    required this.verse,
  }) : super(key: key);

  @override
  _OnlySurahDetailsScreenState createState() => _OnlySurahDetailsScreenState();
}

class _OnlySurahDetailsScreenState extends State<OnlySurahDetailsScreen> {
  late QuranController quranController;
  late ScrollController scrollController;
  int currentIndex = 0; // To track the current Ayah index

  @override
  void initState() {
    super.initState();
    quranController = Get.find();
    scrollController = ScrollController();
  }

  void scrollToCurrentAyah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent *
          (currentIndex / widget.surahVerse.length));
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: primaryColor,
        title: Text(
          '${widget.surahNumber}. ${widget.surahName}',
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: popinsSemiBold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${widget.surahVerseCount} verses | ${widget.englishVerse}',
              style: TextStyle(
                  fontSize: 16, color: primaryColor, fontFamily: popinsMedium),
            ),
            const Divider(height: 20),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.surahVerse.length,
                itemBuilder: (context, index) {
                  final ayah = widget.surahVerse[index];
                  final translation =
                      quranController.translationData.firstWhere(
                    (t) => t.aya == ayah.numberInSurah.toString(),
                    orElse: () => Result(
                      id: '',
                      sura: '',
                      aya: '',
                      arabicText: '',
                      translation: '',
                      footnotes: '',
                    ),
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Ayah ${ayah.numberInSurah}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontFamily: popinsRegulr),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ayah.text,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: jameelNori1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              translation.translation,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontFamily: popinsRegulr),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
