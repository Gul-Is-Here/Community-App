import 'dart:convert';
import 'package:intl/intl.dart';

PrayerTimesModels prayerTimesModelFromJson(String str) =>
    PrayerTimesModels.fromJson(json.decode(str));

String prayerTimesModelToJson(PrayerTimesModels data) =>
    json.encode(data.toJson());

class PrayerTimesModels {
  int? code;
  Data? data;

  PrayerTimesModels({
    this.code,
    this.data,
  });

  factory PrayerTimesModels.fromJson(Map<String, dynamic> json) =>
      PrayerTimesModels(
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data?.toJson(),
      };
}

class Data {
  IqamahTiming? iqamahTimings;
  List<PrayerTimingsUpcoming>? prayerTimingsUpcoming;
  PrayerTimes? prayerTime;

  Data({
    this.iqamahTimings,
    this.prayerTimingsUpcoming,
    this.prayerTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iqamahTimings: json["IqamahTimings"] == null
            ? null
            : IqamahTiming.fromJson(json["IqamahTimings"]),
        prayerTimingsUpcoming: json["PrayerTimingsUpcoming"] == null
            ? []
            : List<PrayerTimingsUpcoming>.from(json["PrayerTimingsUpcoming"]!
                .map((x) => PrayerTimingsUpcoming.fromJson(x))),
        prayerTime: json["PrayerTime"] == null
            ? null
            : PrayerTimes.fromJson(json["PrayerTime"]),
      );

  Map<String, dynamic> toJson() => {
        "IqamahTimings": iqamahTimings?.toJson(),
        "PrayerTimingsUpcoming": prayerTimingsUpcoming == null
            ? []
            : List<dynamic>.from(prayerTimingsUpcoming!.map((x) => x.toJson())),
        "PrayerTime": prayerTime?.toJson(),
      };
}

class IqamahTiming {
  int? iqamahTimingId;
  String? startdate;
  String? enddate;
  String? fajr;
  String? zuhr;
  String? asr;
  String? maghrib;
  String? isha;

  IqamahTiming({
    this.iqamahTimingId,
    this.startdate,
    this.enddate,
    this.fajr,
    this.zuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

  factory IqamahTiming.fromJson(Map<String, dynamic> json) => IqamahTiming(
        iqamahTimingId: json["iqamah_timing_id"],
        startdate: json["startdate"],
        enddate: json["enddate"],
        fajr: json["fajr"],
        zuhr: json["zuhr"],
        asr: json["asr"],
        maghrib: json["maghrib"],
        isha: json["isha"],
      );

  Map<String, dynamic> toJson() => {
        "iqamah_timing_id": iqamahTimingId,
        "startdate": startdate,
        "enddate": enddate,
        "fajr": fajr,
        "zuhr": zuhr,
        "asr": asr,
        "maghrib": maghrib,
        "isha": isha,
      };
}

class PrayerTimes {
  int? prayerTimesId;
  DateTime? date;
  DateTime? fajr;
  DateTime? sunrise;
  DateTime? dhuhr;
  DateTime? asr;
  DateTime? sunset;
  DateTime? maghrib;
  DateTime? isha;
  String? hijriDayName;
  String? hijriDayDate;
  String? hijriMonth;
  String? hijriYear;
  String? georgeDay;
  String? georgeMonth;
  String? georgeYear;
  String? jumuah;
  DateTime? fajrIqamah;
  DateTime? duhurIqamah;
  DateTime? asrIqamah;
  DateTime? maghribIqamah;
  DateTime? ishaIqamah;

  PrayerTimes({
    this.prayerTimesId,
    this.date,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.hijriDayName,
    this.hijriDayDate,
    this.hijriMonth,
    this.hijriYear,
    this.georgeDay,
    this.georgeMonth,
    this.georgeYear,
    this.jumuah,
    this.fajrIqamah,
    this.duhurIqamah,
    this.asrIqamah,
    this.maghribIqamah,
    this.ishaIqamah,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    final date = _parseDate(json["Date"]);
    final sunset = _parseTime(json["Sunset"], date);
    return PrayerTimes(
      prayerTimesId: json["PrayerTimes_id"],
      date: date,
      fajr: _parseTime(json["Fajr"], date),
      sunrise: _parseTime(json["Sunrise"], date),
      dhuhr: _parseTime(json["Dhuhr"], date),
      asr: _parseTime(json["Asr"], date),
      sunset: sunset,
      maghrib: _parseTime(json["Maghrib"], date),
      isha: _parseTime(json["Isha"], date),
      hijriDayName: json["HijriDayName"],
      hijriDayDate: json["HijriDayDate"],
      hijriMonth: json["HijriMonth"],
      hijriYear: json["HijriYear"],
      georgeDay: json["GeorgeDay"],
      georgeMonth: json["GeorgeMonth"],
      georgeYear: json["GeorgeYear"],
      // ✅ FIX: Handle `Jumuah` if it's a Map or a String
      jumuah: json["Jumuah"] is Map<String, dynamic>
          ? jsonEncode(json["Jumuah"])
          : json["Jumuah"],
      fajrIqamah: _parseTime(json["FajrIqamah"], date),
      duhurIqamah: _parseTime(json["DuhurIqamah"], date),
      asrIqamah: _parseTime(json["AsrIqamah"], date),
      maghribIqamah: sunset?.add(const Duration(minutes: 5)),
      ishaIqamah: _parseTime(json["IshaIqamah"], date),
    );
  }

  static DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  static DateTime? _parseTime(String? timeStr, DateTime? date) {
    if (timeStr == null || date == null) return null;
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(timeStr);
      return DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final format = DateFormat('hh:mm a');
    return {
      "Fajr": fajr != null ? format.format(fajr!) : null,
      "Dhuhr": dhuhr != null ? format.format(dhuhr!) : null,
      "Asr": asr != null ? format.format(asr!) : null,
      "Maghrib": maghrib != null ? format.format(maghrib!) : null,
      "Isha": isha != null ? format.format(isha!) : null,
    };
  }
}

class PrayerTimingsUpcoming {
  int? prayerTimesId;
  DateTime? date;
  DateTime? fajr;
  DateTime? sunrise;
  DateTime? dhuhr;
  DateTime? asr;
  DateTime? sunset;
  DateTime? maghrib;
  DateTime? isha;
  String? hijriDayName;
  String? hijriDayDate;
  String? hijriMonth;
  String? hijriYear;
  String? georgeDay;
  String? georgeMonth;
  String? georgeYear;
  dynamic jumuah;
  DateTime? fajrIqamah;
  DateTime? dhuhrIqamah;
  DateTime? asrIqamah;
  DateTime? maghribIqamah;
  DateTime? ishaIqamah;

  PrayerTimingsUpcoming({
    this.prayerTimesId,
    this.date,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.hijriDayName,
    this.hijriDayDate,
    this.hijriMonth,
    this.hijriYear,
    this.georgeDay,
    this.georgeMonth,
    this.georgeYear,
    this.jumuah,
    this.fajrIqamah,
    this.dhuhrIqamah,
    this.asrIqamah,
    this.maghribIqamah,
    this.ishaIqamah,
  });

  factory PrayerTimingsUpcoming.fromJson(Map<String, dynamic> json) {
    final date = PrayerTimes._parseDate(json["Date"]);
    var sunset = PrayerTimes._parseTime(json["Sunset"], date);
    return PrayerTimingsUpcoming(
      prayerTimesId: json["PrayerTimes_id"],
      date: date,
      fajr: PrayerTimes._parseTime(json["Fajr"], date),
      sunrise: PrayerTimes._parseTime(json["Sunrise"], date),
      dhuhr: PrayerTimes._parseTime(json["Dhuhr"], date),
      asr: PrayerTimes._parseTime(json["Asr"], date),
      sunset: sunset,
      maghrib: PrayerTimes._parseTime(json["Maghrib"], date),
      isha: PrayerTimes._parseTime(json["Isha"], date),
      hijriDayName: json["HijriDayName"],
      hijriDayDate: json["HijriDayDate"],
      hijriMonth: json["HijriMonth"],
      hijriYear: json["HijriYear"],
      georgeDay: json["GeorgeDay"],
      georgeMonth: json["GeorgeMonth"],
      georgeYear: json["GeorgeYear"],
      // Fix for `Jumuah`: Handle both `String` and `Map`
      jumuah: json["Jumuah"] is Map<String, dynamic>
          ? jsonEncode(json["Jumuah"])
          : json["Jumuah"],
      fajrIqamah: PrayerTimes._parseTime(json["FajrIqamah"], date),
      dhuhrIqamah: PrayerTimes._parseTime(json["DhuhrIqamah"], date),
      asrIqamah: PrayerTimes._parseTime(json["AsrIqamah"], date),
      maghribIqamah: sunset?.add(Duration(minutes: 5)),
      ishaIqamah: PrayerTimes._parseTime(json["IshaIqamah"], date),
    );
  }

  Map<String, dynamic> toJson() {
    final format = DateFormat('hh:mm a');
    return {
      "PrayerTimes_id": prayerTimesId,
      "Date": date?.toIso8601String().substring(0, 10),
      "Fajr": fajr != null ? format.format(fajr!) : null,
      "Sunrise": sunrise != null ? format.format(sunrise!) : null,
      "Dhuhr": dhuhr != null ? format.format(dhuhr!) : null,
      "Asr": asr != null ? format.format(asr!) : null,
      "Sunset": sunset != null ? format.format(sunset!) : null,
      "Maghrib": maghrib != null ? format.format(maghrib!) : null,
      "Isha": isha != null ? format.format(isha!) : null,
      "HijriDayName": hijriDayName,
      "HijriDayDate": hijriDayDate,
      "HijriMonth": hijriMonth,
      "HijriYear": hijriYear,
      "GeorgeDay": georgeDay,
      "GeorgeMonth": georgeMonth,
      "GeorgeYear": georgeYear,
      "Jumuah": jumuah,
      "FajrIqamah": fajrIqamah != null ? format.format(fajrIqamah!) : null,
      "DhuhrIqamah": dhuhrIqamah != null ? format.format(dhuhrIqamah!) : null,
      "AsrIqamah": asrIqamah != null ? format.format(asrIqamah!) : null,
      "MaghribIqamah":
          maghribIqamah != null ? format.format(maghribIqamah!) : null,
      "IshaIqamah": ishaIqamah != null ? format.format(ishaIqamah!) : null,
    };
  }
}

class JumuahClass {
  int? prayerId;
  String? prayerName;
  String? prayerTiming;
  String? iqamahTiming;
  String? namazTiming;
  String? active;
  DateTime? createdAt;
  DateTime? updatedAt;

  JumuahClass({
    this.prayerId,
    this.prayerName,
    this.prayerTiming,
    this.iqamahTiming,
    this.namazTiming,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory JumuahClass.fromJson(Map<String, dynamic> json) => JumuahClass(
        prayerId: json["prayer_id"],
        prayerName: json["prayer_name"],
        prayerTiming: json["prayer_timing"],
        iqamahTiming: json["iqamah_timing"],
        namazTiming: json["namaz_timing"],
        active: json["_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "prayer_id": prayerId,
        "prayer_name": prayerName,
        "prayer_timing": prayerTiming,
        "iqamah_timing": iqamahTiming,
        "namaz_timing": namazTiming,
        "_active": active,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
