import 'dart:convert';

class Jumma {
  final int? code;
  final Data? data;

  Jumma({
    this.code,
    this.data,
  });

  Jumma copyWith({
    int? code,
    Data? data,
  }) =>
      Jumma(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory Jumma.fromRawJson(String str) => Jumma.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Jumma.fromJson(Map<String, dynamic> json) => Jumma(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data!.toJson(),
      };
}

class Data {
  final Jumah jumah;
  final Adjustment adjustment;

  Data({
    required this.jumah,
    required this.adjustment,
  });

  Data copyWith({
    Jumah? jumah,
    Adjustment? adjustment,
  }) =>
      Data(
        jumah: jumah ?? this.jumah,
        adjustment: adjustment ?? this.adjustment,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jumah: Jumah.fromJson(json["jumah"]),
        adjustment: Adjustment.fromJson(json["adjustment"]),
      );

  Map<String, dynamic> toJson() => {
        "jumah": jumah.toJson(),
        "adjustment": adjustment.toJson(),
      };
}

class Adjustment {
  final int apiAdjustId;
  final String apiAdjustAdjustment;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Adjustment({
    required this.apiAdjustId,
    required this.apiAdjustAdjustment,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Adjustment copyWith({
    int? apiAdjustId,
    String? apiAdjustAdjustment,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Adjustment(
        apiAdjustId: apiAdjustId ?? this.apiAdjustId,
        apiAdjustAdjustment: apiAdjustAdjustment ?? this.apiAdjustAdjustment,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Adjustment.fromRawJson(String str) =>
      Adjustment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Adjustment.fromJson(Map<String, dynamic> json) => Adjustment(
        apiAdjustId: json["api_adjust_id"],
        apiAdjustAdjustment: json["api_adjust_adjustment"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "api_adjust_id": apiAdjustId,
        "api_adjust_adjustment": apiAdjustAdjustment,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Jumah {
  final int prayerId;
  final String prayerName;
  final String prayerTiming;
  final String iqamahTiming;
  final String namazTiming;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Jumah({
    required this.prayerId,
    required this.prayerName,
    required this.prayerTiming,
    required this.iqamahTiming,
    required this.namazTiming,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Jumah copyWith({
    int? prayerId,
    String? prayerName,
    String? prayerTiming,
    String? iqamahTiming,
    String? namazTiming,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Jumah(
        prayerId: prayerId ?? this.prayerId,
        prayerName: prayerName ?? this.prayerName,
        prayerTiming: prayerTiming ?? this.prayerTiming,
        iqamahTiming: iqamahTiming ?? this.iqamahTiming,
        namazTiming: namazTiming ?? this.namazTiming,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Jumah.fromRawJson(String str) => Jumah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Jumah.fromJson(Map<String, dynamic> json) => Jumah(
        prayerId: json["prayer_id"],
        prayerName: json["prayer_name"],
        prayerTiming: json["prayer_timing"],
        iqamahTiming: json["iqamah_timing"],
        namazTiming: json["namaz_timing"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "prayer_id": prayerId,
        "prayer_name": prayerName,
        "prayer_timing": prayerTiming,
        "iqamah_timing": iqamahTiming,
        "namaz_timing": namazTiming,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
