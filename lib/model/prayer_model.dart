import 'dart:convert';

class Prayer {
  final IqamahTimings iqamahTimings;
  final List<PrayerTime> upcomingPrayerTimes;
  final PrayerTime todayPrayerTime;

  Prayer({
    required this.iqamahTimings,
    required this.upcomingPrayerTimes,
    required this.todayPrayerTime,
  });

  factory Prayer.fromJson(Map<String, dynamic> json) => Prayer(
        iqamahTimings: IqamahTimings.fromJson(json["IqamahTimings"]),
        upcomingPrayerTimes: List<PrayerTime>.from(
            json["PrayerTimingsUpcoming"].map((x) => PrayerTime.fromJson(x))),
        todayPrayerTime: PrayerTime.fromJson(json["PrayerTime"]),
      );

  Map<String, dynamic> toJson() => {
        "IqamahTimings": iqamahTimings.toJson(),
        "PrayerTimingsUpcoming":
            List<dynamic>.from(upcomingPrayerTimes.map((x) => x.toJson())),
        "PrayerTime": todayPrayerTime.toJson(),
      };
}

class IqamahTimings {
  final int iqamahTimingId;
  final String startDate;
  final String endDate;
  final String fajr;
  final String zuhr;
  final String asr;
  final String maghrib;
  final String isha;

  IqamahTimings({
    required this.iqamahTimingId,
    required this.startDate,
    required this.endDate,
    required this.fajr,
    required this.zuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory IqamahTimings.fromJson(Map<String, dynamic> json) => IqamahTimings(
        iqamahTimingId: json["iqamah_timing_id"],
        startDate: json["startdate"],
        endDate: json["enddate"],
        fajr: json["fajr"],
        zuhr: json["zuhr"],
        asr: json["asr"],
        maghrib: json["maghrib"],
        isha: json["isha"],
      );

  Map<String, dynamic> toJson() => {
        "iqamah_timing_id": iqamahTimingId,
        "startdate": startDate,
        "enddate": endDate,
        "fajr": fajr,
        "zuhr": zuhr,
        "asr": asr,
        "maghrib": maghrib,
        "isha": isha,
      };
}

class PrayerTime {
  final int prayerTimesId;
  final String date;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String hijriDayName;
  final String hijriDayDate;
  final String hijriMonth;
  final String hijriYear;
  final String gregorianDay;
  final String gregorianMonth;
  final String gregorianYear;
  final Jumuah? jumuah;

  PrayerTime({
    required this.prayerTimesId,
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.hijriDayName,
    required this.hijriDayDate,
    required this.hijriMonth,
    required this.hijriYear,
    required this.gregorianDay,
    required this.gregorianMonth,
    required this.gregorianYear,
    this.jumuah,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) => PrayerTime(
        prayerTimesId: json["PrayerTimes_id"],
        date: json["Date"],
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        hijriDayName: json["HijriDayName"],
        hijriDayDate: json["HijriDayDate"],
        hijriMonth: json["HijriMonth"],
        hijriYear: json["HijriYear"],
        gregorianDay: json["GeorgeDay"],
        gregorianMonth: json["GeorgeMonth"],
        gregorianYear: json["GeorgeYear"],
        jumuah: (json["Jumuah"] is Map<String, dynamic>)
            ? Jumuah.fromJson(json["Jumuah"])
            : null, // Fix: Handle empty Jumuah field
      );

  Map<String, dynamic> toJson() => {
        "PrayerTimes_id": prayerTimesId,
        "Date": date,
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "HijriDayName": hijriDayName,
        "HijriDayDate": hijriDayDate,
        "HijriMonth": hijriMonth,
        "HijriYear": hijriYear,
        "GeorgeDay": gregorianDay,
        "GeorgeMonth": gregorianMonth,
        "GeorgeYear": gregorianYear,
        "Jumuah": jumuah?.toJson(),
      };
}

class Jumuah {
  final int prayerId;
  final String prayerName;
  final String prayerTiming;
  final String iqamahTiming;
  final String namazTiming;
  final String active;
  final String createdAt;
  final String updatedAt;

  Jumuah({
    required this.prayerId,
    required this.prayerName,
    required this.prayerTiming,
    required this.iqamahTiming,
    required this.namazTiming,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Jumuah.fromJson(Map<String, dynamic> json) => Jumuah(
        prayerId: json["prayer_id"],
        prayerName: json["prayer_name"],
        prayerTiming: json["prayer_timing"],
        iqamahTiming: json["iqamah_timing"],
        namazTiming: json["namaz_timing"],
        active: json["_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "prayer_id": prayerId,
        "prayer_name": prayerName,
        "prayer_timing": prayerTiming,
        "iqamah_timing": iqamahTiming,
        "namaz_timing": namazTiming,
        "_active": active,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
