import 'dart:convert';

class QuranAudio {
  final List<AudioFile> audioFiles;

  QuranAudio({
    required this.audioFiles,
  });

  QuranAudio copyWith({
    List<AudioFile>? audioFiles,
  }) =>
      QuranAudio(
        audioFiles: audioFiles ?? this.audioFiles,
      );

  factory QuranAudio.fromRawJson(String str) =>
      QuranAudio.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuranAudio.fromJson(Map<String, dynamic> json) => QuranAudio(
        audioFiles: List<AudioFile>.from(
            json["audio_files"].map((x) => AudioFile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "audio_files": List<dynamic>.from(audioFiles.map((x) => x.toJson())),
      };
}

class AudioFile {
  final int id;
  final int chapterId;
  final int fileSize;
  final Format format;
  final String audioUrl;

  AudioFile({
    required this.id,
    required this.chapterId,
    required this.fileSize,
    required this.format,
    required this.audioUrl,
  });

  AudioFile copyWith({
    int? id,
    int? chapterId,
    int? fileSize,
    Format? format,
    String? audioUrl,
  }) =>
      AudioFile(
        id: id ?? this.id,
        chapterId: chapterId ?? this.chapterId,
        fileSize: fileSize ?? this.fileSize,
        format: format ?? this.format,
        audioUrl: audioUrl ?? this.audioUrl,
      );

  factory AudioFile.fromRawJson(String str) =>
      AudioFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AudioFile.fromJson(Map<String, dynamic> json) => AudioFile(
        id: json["id"] is int ? json["id"] : (json["id"] as double).toInt(),
        chapterId: json["chapter_id"] is int
            ? json["chapter_id"]
            : (json["chapter_id"] as double).toInt(),
        fileSize: json["file_size"] is int
            ? json["file_size"]
            : (json["file_size"] as double).toInt(),
        format: formatValues.map[json["format"]]!,
        audioUrl: json["audio_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chapter_id": chapterId,
        "file_size": fileSize,
        "format": formatValues.reverse[format],
        "audio_url": audioUrl,
      };
}

enum Format {
  MP3
}

final formatValues = EnumValues({
  "mp3": Format.MP3,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
