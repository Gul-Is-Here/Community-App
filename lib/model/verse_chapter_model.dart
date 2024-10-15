import 'package:meta/meta.dart';
import 'dart:convert';

class VerseChapterModel {
  final List<Verse> verses;
  final Pagination pagination;

  VerseChapterModel({
    required this.verses,
    required this.pagination,
  });

  VerseChapterModel copyWith({
    List<Verse>? verses,
    Pagination? pagination,
  }) =>
      VerseChapterModel(
        verses: verses ?? this.verses,
        pagination: pagination ?? this.pagination,
      );

  factory VerseChapterModel.fromRawJson(String str) =>
      VerseChapterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerseChapterModel.fromJson(Map<String, dynamic> json) =>
      VerseChapterModel(
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  final int perPage;
  final int currentPage;
  final dynamic nextPage;
  final int totalPages;
  final int totalRecords;

  Pagination({
    required this.perPage,
    required this.currentPage,
    required this.nextPage,
    required this.totalPages,
    required this.totalRecords,
  });

  Pagination copyWith({
    int? perPage,
    int? currentPage,
    dynamic nextPage,
    int? totalPages,
    int? totalRecords,
  }) =>
      Pagination(
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
        nextPage: nextPage ?? this.nextPage,
        totalPages: totalPages ?? this.totalPages,
        totalRecords: totalRecords ?? this.totalRecords,
      );

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        perPage: json["per_page"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "per_page": perPage,
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_records": totalRecords,
      };
}

class Verse {
  final int id;
  final int verseNumber;
  final String verseKey;
  final int hizbNumber;
  final int rubElHizbNumber;
  final int rukuNumber;
  final int manzilNumber;
  final dynamic sajdahNumber;
  final int pageNumber;
  final int juzNumber;

  Verse({
    required this.id,
    required this.verseNumber,
    required this.verseKey,
    required this.hizbNumber,
    required this.rubElHizbNumber,
    required this.rukuNumber,
    required this.manzilNumber,
    required this.sajdahNumber,
    required this.pageNumber,
    required this.juzNumber,
  });

  Verse copyWith({
    int? id,
    int? verseNumber,
    String? verseKey,
    int? hizbNumber,
    int? rubElHizbNumber,
    int? rukuNumber,
    int? manzilNumber,
    dynamic sajdahNumber,
    int? pageNumber,
    int? juzNumber,
  }) =>
      Verse(
        id: id ?? this.id,
        verseNumber: verseNumber ?? this.verseNumber,
        verseKey: verseKey ?? this.verseKey,
        hizbNumber: hizbNumber ?? this.hizbNumber,
        rubElHizbNumber: rubElHizbNumber ?? this.rubElHizbNumber,
        rukuNumber: rukuNumber ?? this.rukuNumber,
        manzilNumber: manzilNumber ?? this.manzilNumber,
        sajdahNumber: sajdahNumber ?? this.sajdahNumber,
        pageNumber: pageNumber ?? this.pageNumber,
        juzNumber: juzNumber ?? this.juzNumber,
      );

  factory Verse.fromRawJson(String str) => Verse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json["id"],
        verseNumber: json["verse_number"],
        verseKey: json["verse_key"],
        hizbNumber: json["hizb_number"],
        rubElHizbNumber: json["rub_el_hizb_number"],
        rukuNumber: json["ruku_number"],
        manzilNumber: json["manzil_number"],
        sajdahNumber: json["sajdah_number"],
        pageNumber: json["page_number"],
        juzNumber: json["juz_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "verse_number": verseNumber,
        "verse_key": verseKey,
        "hizb_number": hizbNumber,
        "rub_el_hizb_number": rubElHizbNumber,
        "ruku_number": rukuNumber,
        "manzil_number": manzilNumber,
        "sajdah_number": sajdahNumber,
        "page_number": pageNumber,
        "juz_number": juzNumber,
      };
}
