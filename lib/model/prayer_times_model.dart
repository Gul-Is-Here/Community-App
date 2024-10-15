import 'dart:convert';

import 'package:intl/intl.dart';

PrayerTimesModel prayerTimesFromJson(String str) =>
    PrayerTimesModel.fromJson(json.decode(str));

String prayerTimesToJson(PrayerTimesModel data) => json.encode(data.toJson());

class PrayerTimesModel {
  int code;
  String status;
  List<Datum> data;

  PrayerTimesModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) =>
      PrayerTimesModel(
        code: json["code"],
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  Timings? getTodayPrayerTimes() {
    DateTime today = DateTime.now();
    for (var datum in data) {
      DateTime gregorianDate = DateFormat("dd-MM-yyyy").parse(datum.date.gregorian.date);
      if (gregorianDate.year == today.year &&
          gregorianDate.month == today.month &&
          gregorianDate.day == today.day) {
        return datum.timings;
      }
    }
    return null; // Return null if no data for today
  }

  DateTime getDateTime(String timeString, String dateString) {
    // Extract time components
    List<String> timeComponents = timeString.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes =
        int.parse(timeComponents[1].split(' ')[0]); // Remove timezone info

    // Parse date
    DateTime date = DateFormat("dd MMM yyyy").parse(dateString);

    // Combine date and time
    return DateTime(date.year, date.month, date.day, hours, minutes);
  }

  String convertTimeFormat(String timeString) {
    // Split timeString into components
    List<String> components = timeString.split(' ');

    // Split the time component into hours and minutes
    List<String> timeComponents = components[0].split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);

    // Convert hours to 12-hour format
    int hours12 = hours % 12;
    if (hours12 == 0) {
      hours12 = 12; // 12:00 AM should be displayed as 12:00 PM
    }

    // Determine AM/PM
    String period = hours < 12 ? 'AM' : 'PM';

    // Format the time string
    return '${hours12.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  }
}

class Datum {
  Timings timings;
  Date date;

  Datum({
    required this.timings,
    required this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        timings: Timings.fromJson(json["timings"]),
        date: Date.fromJson(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "timings": timings.toJson(),
        "date": date.toJson(),
      };
}

class Date {
  String readable;
  String timestamp;
  Gregorian gregorian;

  Date({
    required this.readable,
    required this.timestamp,
    required this.gregorian,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        readable: json["readable"],
        timestamp: json["timestamp"],
        gregorian: Gregorian.fromJson(json["gregorian"]),
      );

  Map<String, dynamic> toJson() => {
        "readable": readable,
        "timestamp": timestamp,
        "gregorian": gregorian.toJson(),
      };
}

class Gregorian {
  String date;

  Gregorian({
    required this.date,
  });

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
      };
}

class Timings {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;
  String midnight;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.midnight,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        midnight: json["Midnight"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        // "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Maghrib": maghrib,
        "Isha": isha,
        // "Midnight": midnight,
      };
}
