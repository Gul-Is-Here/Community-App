import 'package:meta/meta.dart';
import 'dart:convert';

class SurahModel {
  final int code;
  final String status;
  final Data data;

  SurahModel({
    required this.code,
    required this.status,
    required this.data,
  });

  SurahModel copyWith({
    int? code,
    String? status,
    Data? data,
  }) =>
      SurahModel(
        code: code ?? this.code,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory SurahModel.fromRawJson(String str) =>
      SurahModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
        code: json["code"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  final List<Surah> surahs;
  final Edition edition;

  Data({
    required this.surahs,
    required this.edition,
  });

  Data copyWith({
    List<Surah>? surahs,
    Edition? edition,
  }) =>
      Data(
        surahs: surahs ?? this.surahs,
        edition: edition ?? this.edition,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
        edition: Edition.fromJson(json["edition"]),
      );

  Map<String, dynamic> toJson() => {
        "surahs": List<dynamic>.from(surahs.map((x) => x.toJson())),
        "edition": edition.toJson(),
      };
}

class Edition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;

  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });

  Edition copyWith({
    String? identifier,
    String? language,
    String? name,
    String? englishName,
    String? format,
    String? type,
  }) =>
      Edition(
        identifier: identifier ?? this.identifier,
        language: language ?? this.language,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        format: format ?? this.format,
        type: type ?? this.type,
      );

  factory Edition.fromRawJson(String str) => Edition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json["identifier"],
        language: json["language"],
        name: json["name"],
        englishName: json["englishName"],
        format: json["format"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "language": language,
        "name": name,
        "englishName": englishName,
        "format": format,
        "type": type,
      };
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final RevelationType revelationType;
  final List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  Surah copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    RevelationType? revelationType,
    List<Ayah>? ayahs,
  }) =>
      Surah(
        number: number ?? this.number,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        englishNameTranslation:
            englishNameTranslation ?? this.englishNameTranslation,
        revelationType: revelationType ?? this.revelationType,
        ayahs: ayahs ?? this.ayahs,
      );

  factory Surah.fromRawJson(String str) => Surah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: revelationTypeValues.map[json["revelationType"]]!,
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationTypeValues.reverse[revelationType],
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
      };
}

class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  Ayah copyWith({
    int? number,
    String? text,
    int? numberInSurah,
    int? juz,
    int? manzil,
    int? page,
    int? ruku,
    int? hizbQuarter,
    dynamic sajda,
  }) =>
      Ayah(
        number: number ?? this.number,
        text: text ?? this.text,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        juz: juz ?? this.juz,
        manzil: manzil ?? this.manzil,
        page: page ?? this.page,
        ruku: ruku ?? this.ruku,
        hizbQuarter: hizbQuarter ?? this.hizbQuarter,
        sajda: sajda ?? this.sajda,
      );

  factory Ayah.fromRawJson(String str) => Ayah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json["number"],
        text: json["text"],
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        sajda: json["sajda"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "text": text,
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda,
      };
}

class SajdaClass {
  final int id;
  final bool recommended;
  final bool obligatory;

  SajdaClass({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  SajdaClass copyWith({
    int? id,
    bool? recommended,
    bool? obligatory,
  }) =>
      SajdaClass(
        id: id ?? this.id,
        recommended: recommended ?? this.recommended,
        obligatory: obligatory ?? this.obligatory,
      );

  factory SajdaClass.fromRawJson(String str) =>
      SajdaClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SajdaClass.fromJson(Map<String, dynamic> json) => SajdaClass(
        id: json["id"],
        recommended: json["recommended"],
        obligatory: json["obligatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recommended": recommended,
        "obligatory": obligatory,
      };
}

enum RevelationType { MECCAN, MEDINAN }

final revelationTypeValues = EnumValues(
    {"Meccan": RevelationType.MECCAN, "Medinan": RevelationType.MEDINAN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
