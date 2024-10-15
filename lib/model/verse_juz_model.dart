import 'package:meta/meta.dart';
import 'dart:convert';

class VerseJuzsModel {
    final List<Juz> juzs;

    VerseJuzsModel({
        required this.juzs,
    });

    VerseJuzsModel copyWith({
        List<Juz>? juzs,
    }) => 
        VerseJuzsModel(
            juzs: juzs ?? this.juzs,
        );

    factory VerseJuzsModel.fromRawJson(String str) => VerseJuzsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory VerseJuzsModel.fromJson(Map<String, dynamic> json) => VerseJuzsModel(
        juzs: List<Juz>.from(json["juzs"].map((x) => Juz.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "juzs": List<dynamic>.from(juzs.map((x) => x.toJson())),
    };
}

class Juz {
    final int id;
    final int juzNumber;
    final Map<String, String> verseMapping;
    final int firstVerseId;
    final int lastVerseId;
    final int versesCount;

    Juz({
        required this.id,
        required this.juzNumber,
        required this.verseMapping,
        required this.firstVerseId,
        required this.lastVerseId,
        required this.versesCount,
    });

    Juz copyWith({
        int? id,
        int? juzNumber,
        Map<String, String>? verseMapping,
        int? firstVerseId,
        int? lastVerseId,
        int? versesCount,
    }) => 
        Juz(
            id: id ?? this.id,
            juzNumber: juzNumber ?? this.juzNumber,
            verseMapping: verseMapping ?? this.verseMapping,
            firstVerseId: firstVerseId ?? this.firstVerseId,
            lastVerseId: lastVerseId ?? this.lastVerseId,
            versesCount: versesCount ?? this.versesCount,
        );

    factory Juz.fromRawJson(String str) => Juz.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Juz.fromJson(Map<String, dynamic> json) => Juz(
        id: json["id"],
        juzNumber: json["juz_number"],
        verseMapping: Map.from(json["verse_mapping"]).map((k, v) => MapEntry<String, String>(k, v)),
        firstVerseId: json["first_verse_id"],
        lastVerseId: json["last_verse_id"],
        versesCount: json["verses_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "juz_number": juzNumber,
        "verse_mapping": Map.from(verseMapping).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "first_verse_id": firstVerseId,
        "last_verse_id": lastVerseId,
        "verses_count": versesCount,
    };
}
