import 'package:meta/meta.dart';
import 'dart:convert';

class EventType {
  final int code;
  final Data data;

  EventType({
    required this.code,
    required this.data,
  });

  EventType copyWith({
    int? code,
    Data? data,
  }) =>
      EventType(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory EventType.fromRawJson(String str) =>
      EventType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventType.fromJson(Map<String, dynamic> json) => EventType(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final List<Eventtype> eventtypes;

  Data({
    required this.eventtypes,
  });

  Data copyWith({
    List<Eventtype>? eventtypes,
  }) =>
      Data(
        eventtypes: eventtypes ?? this.eventtypes,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventtypes: List<Eventtype>.from(
            json["eventtypes"].map((x) => Eventtype.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eventtypes": List<dynamic>.from(eventtypes.map((x) => x.toJson())),
      };
}

class Eventtype {
  final int eventtypeId;
  final String eventtypeName;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Eventtype({
    required this.eventtypeId,
    required this.eventtypeName,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Eventtype copyWith({
    int? eventtypeId,
    String? eventtypeName,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Eventtype(
        eventtypeId: eventtypeId ?? this.eventtypeId,
        eventtypeName: eventtypeName ?? this.eventtypeName,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Eventtype.fromRawJson(String str) =>
      Eventtype.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Eventtype.fromJson(Map<String, dynamic> json) => Eventtype(
        eventtypeId: json["eventtype_id"],
        eventtypeName: json["eventtype_name"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "eventtype_id": eventtypeId,
        "eventtype_name": eventtypeName,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
