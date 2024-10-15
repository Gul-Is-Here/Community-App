import 'package:meta/meta.dart';
import 'dart:convert';

class SurahAyatEnglisModel {
  final List<Result> result;

  SurahAyatEnglisModel({
    required this.result,
  });

  SurahAyatEnglisModel copyWith({
    List<Result>? result,
  }) =>
      SurahAyatEnglisModel(
        result: result ?? this.result,
      );

  factory SurahAyatEnglisModel.fromRawJson(String str) =>
      SurahAyatEnglisModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurahAyatEnglisModel.fromJson(Map<String, dynamic> json) =>
      SurahAyatEnglisModel(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  final String id;
  final String sura;
  final String aya;
  final String arabicText;
  final String translation;
  final String footnotes;

  Result({
    required this.id,
    required this.sura,
    required this.aya,
    required this.arabicText,
    required this.translation,
    required this.footnotes,
  });

  Result copyWith({
    String? id,
    String? sura,
    String? aya,
    String? arabicText,
    String? translation,
    String? footnotes,
  }) =>
      Result(
        id: id ?? this.id,
        sura: sura ?? this.sura,
        aya: aya ?? this.aya,
        arabicText: arabicText ?? this.arabicText,
        translation: translation ?? this.translation,
        footnotes: footnotes ?? this.footnotes,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        sura: json["sura"],
        aya: json["aya"],
        arabicText: json["arabic_text"],
        translation: json["translation"],
        footnotes: json["footnotes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sura": sura,
        "aya": aya,
        "arabic_text": arabicText,
        "translation": translation,
        "footnotes": footnotes,
      };
}
