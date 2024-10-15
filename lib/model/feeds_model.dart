import 'package:meta/meta.dart';
import 'dart:convert';

class Feeds {
    final int code;
    final Data data;

    Feeds({
        required this.code,
        required this.data,
    });

    Feeds copyWith({
        int? code,
        Data? data,
    }) => 
        Feeds(
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory Feeds.fromRawJson(String str) => Feeds.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Feeds.fromJson(Map<String, dynamic> json) => Feeds(
        code: json["code"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
    };
}

class Data {
    final List<Feed> feeds;

    Data({
        required this.feeds,
    });

    Data copyWith({
        List<Feed>? feeds,
    }) => 
        Data(
            feeds: feeds ?? this.feeds,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
    };
}

class Feed {
    final int feedId;
    final String feedTitle;
    final String feedImage;
    final DateTime feedDate;
    final String active;
    final DateTime createdAt;
    final DateTime updatedAt;

    Feed({
        required this.feedId,
        required this.feedTitle,
        required this.feedImage,
        required this.feedDate,
        required this.active,
        required this.createdAt,
        required this.updatedAt,
    });

    Feed copyWith({
        int? feedId,
        String? feedTitle,
        String? feedImage,
        DateTime? feedDate,
        String? active,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Feed(
            feedId: feedId ?? this.feedId,
            feedTitle: feedTitle ?? this.feedTitle,
            feedImage: feedImage ?? this.feedImage,
            feedDate: feedDate ?? this.feedDate,
            active: active ?? this.active,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Feed.fromRawJson(String str) => Feed.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        feedId: json["feed_id"],
        feedTitle: json["feed_title"],
        feedImage: json["feed_image"],
        feedDate: DateTime.parse(json["feed_date"]),
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "feed_id": feedId,
        "feed_title": feedTitle,
        "feed_image": feedImage,
        "feed_date": "${feedDate.year.toString().padLeft(4, '0')}-${feedDate.month.toString().padLeft(2, '0')}-${feedDate.day.toString().padLeft(2, '0')}",
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
