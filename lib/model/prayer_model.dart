import 'dart:convert';

class Prayer {
  Data? data;

  Prayer({
    this.data,
  });

  Prayer copyWith({
    int? code,
    String? status,
    Data? data,
  }) =>
      Prayer(
        data: data ?? this.data,
      );

  factory Prayer.fromRawJson(String str) => Prayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prayer.fromJson(Map<String, dynamic> json) => Prayer(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Timings timings;
  Date date;
  Meta meta;

  Data({
    required this.timings,
    required this.date,
    required this.meta,
  });

  Data copyWith({
    Timings? timings,
    Date? date,
    Meta? meta,
  }) =>
      Data(
        timings: timings ?? this.timings,
        date: date ?? this.date,
        meta: meta ?? this.meta,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        timings: Timings.fromJson(json["timings"]),
        date: Date.fromJson(json["date"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "timings": timings.toJson(),
        "date": date.toJson(),
        "meta": meta.toJson(),
      };
}

class Date {
  String readable;
  String timestamp;
  Hijri hijri;
  Gregorian gregorian;

  Date({
    required this.readable,
    required this.timestamp,
    required this.hijri,
    required this.gregorian,
  });

  Date copyWith({
    String? readable,
    String? timestamp,
    Hijri? hijri,
    Gregorian? gregorian,
  }) =>
      Date(
        readable: readable ?? this.readable,
        timestamp: timestamp ?? this.timestamp,
        hijri: hijri ?? this.hijri,
        gregorian: gregorian ?? this.gregorian,
      );

  factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        readable: json["readable"],
        timestamp: json["timestamp"],
        hijri: Hijri.fromJson(json["hijri"]),
        gregorian: Gregorian.fromJson(json["gregorian"]),
      );

  Map<String, dynamic> toJson() => {
        "readable": readable,
        "timestamp": timestamp,
        "hijri": hijri.toJson(),
        "gregorian": gregorian.toJson(),
      };
}

class Gregorian {
  String date;
  String format;
  String day;
  GregorianWeekday weekday;
  GregorianMonth month;
  String year;
  Designation designation;
  bool lunarSighting;

  Gregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.lunarSighting,
  });

  Gregorian copyWith({
    String? date,
    String? format,
    String? day,
    GregorianWeekday? weekday,
    GregorianMonth? month,
    String? year,
    Designation? designation,
    bool? lunarSighting,
  }) =>
      Gregorian(
        date: date ?? this.date,
        format: format ?? this.format,
        day: day ?? this.day,
        weekday: weekday ?? this.weekday,
        month: month ?? this.month,
        year: year ?? this.year,
        designation: designation ?? this.designation,
        lunarSighting: lunarSighting ?? this.lunarSighting,
      );

  factory Gregorian.fromRawJson(String str) =>
      Gregorian.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: GregorianWeekday.fromJson(json["weekday"]),
        month: GregorianMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
        lunarSighting: json["lunarSighting"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
        "lunarSighting": lunarSighting,
      };
}

class Designation {
  String abbreviated;
  String expanded;

  Designation({
    required this.abbreviated,
    required this.expanded,
  });

  Designation copyWith({
    String? abbreviated,
    String? expanded,
  }) =>
      Designation(
        abbreviated: abbreviated ?? this.abbreviated,
        expanded: expanded ?? this.expanded,
      );

  factory Designation.fromRawJson(String str) =>
      Designation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        abbreviated: json["abbreviated"],
        expanded: json["expanded"],
      );

  Map<String, dynamic> toJson() => {
        "abbreviated": abbreviated,
        "expanded": expanded,
      };
}

class GregorianMonth {
  int number;
  String en;

  GregorianMonth({
    required this.number,
    required this.en,
  });

  GregorianMonth copyWith({
    int? number,
    String? en,
  }) =>
      GregorianMonth(
        number: number ?? this.number,
        en: en ?? this.en,
      );

  factory GregorianMonth.fromRawJson(String str) =>
      GregorianMonth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
        number: json["number"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "en": en,
      };
}

class GregorianWeekday {
  String en;

  GregorianWeekday({
    required this.en,
  });

  GregorianWeekday copyWith({
    String? en,
  }) =>
      GregorianWeekday(
        en: en ?? this.en,
      );

  factory GregorianWeekday.fromRawJson(String str) =>
      GregorianWeekday.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) =>
      GregorianWeekday(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Hijri {
  String date;
  String format;
  int day;
  HijriWeekday weekday;
  HijriMonth month;
  int year;
  Designation designation;
  List<dynamic> holidays;
  List<dynamic> adjustedHolidays;
  String method;

  Hijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
    required this.adjustedHolidays,
    required this.method,
  });

  Hijri copyWith({
    String? date,
    String? format,
    int? day,
    HijriWeekday? weekday,
    HijriMonth? month,
    int? year,
    Designation? designation,
    List<dynamic>? holidays,
    List<dynamic>? adjustedHolidays,
    String? method,
  }) =>
      Hijri(
        date: date ?? this.date,
        format: format ?? this.format,
        day: day ?? this.day,
        weekday: weekday ?? this.weekday,
        month: month ?? this.month,
        year: year ?? this.year,
        designation: designation ?? this.designation,
        holidays: holidays ?? this.holidays,
        adjustedHolidays: adjustedHolidays ?? this.adjustedHolidays,
        method: method ?? this.method,
      );

  factory Hijri.fromRawJson(String str) => Hijri.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: HijriWeekday.fromJson(json["weekday"]),
        month: HijriMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
        holidays: List<dynamic>.from(json["holidays"].map((x) => x)),
        adjustedHolidays:
            List<dynamic>.from(json["adjustedHolidays"].map((x) => x)),
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
        "holidays": List<dynamic>.from(holidays.map((x) => x)),
        "adjustedHolidays": List<dynamic>.from(adjustedHolidays.map((x) => x)),
        "method": method,
      };
}

class HijriMonth {
  int number;
  String en;
  String ar;
  int days;

  HijriMonth({
    required this.number,
    required this.en,
    required this.ar,
    required this.days,
  });

  HijriMonth copyWith({
    int? number,
    String? en,
    String? ar,
    int? days,
  }) =>
      HijriMonth(
        number: number ?? this.number,
        en: en ?? this.en,
        ar: ar ?? this.ar,
        days: days ?? this.days,
      );

  factory HijriMonth.fromRawJson(String str) =>
      HijriMonth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
        number: json["number"],
        en: json["en"],
        ar: json["ar"],
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "en": en,
        "ar": ar,
        "days": days,
      };
}

class HijriWeekday {
  String en;
  String ar;

  HijriWeekday({
    required this.en,
    required this.ar,
  });

  HijriWeekday copyWith({
    String? en,
    String? ar,
  }) =>
      HijriWeekday(
        en: en ?? this.en,
        ar: ar ?? this.ar,
      );

  factory HijriWeekday.fromRawJson(String str) =>
      HijriWeekday.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
        en: json["en"],
        ar: json["ar"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "ar": ar,
      };
}

class Meta {
  double latitude;
  double longitude;
  String timezone;
  Method method;
  String latitudeAdjustmentMethod;
  String midnightMode;
  String school;
  Map<String, int> offset;

  Meta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  Meta copyWith({
    double? latitude,
    double? longitude,
    String? timezone,
    Method? method,
    String? latitudeAdjustmentMethod,
    String? midnightMode,
    String? school,
    Map<String, int>? offset,
  }) =>
      Meta(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timezone: timezone ?? this.timezone,
        method: method ?? this.method,
        latitudeAdjustmentMethod:
            latitudeAdjustmentMethod ?? this.latitudeAdjustmentMethod,
        midnightMode: midnightMode ?? this.midnightMode,
        school: school ?? this.school,
        offset: offset ?? this.offset,
      );

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timezone: json["timezone"],
        method: Method.fromJson(json["method"]),
        latitudeAdjustmentMethod: json["latitudeAdjustmentMethod"],
        midnightMode: json["midnightMode"],
        school: json["school"],
        offset:
            Map.from(json["offset"]).map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "method": method.toJson(),
        "latitudeAdjustmentMethod": latitudeAdjustmentMethod,
        "midnightMode": midnightMode,
        "school": school,
        "offset":
            Map.from(offset).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Method {
  int id;
  String name;
  Params params;
  Location location;

  Method({
    required this.id,
    required this.name,
    required this.params,
    required this.location,
  });

  Method copyWith({
    int? id,
    String? name,
    Params? params,
    Location? location,
  }) =>
      Method(
        id: id ?? this.id,
        name: name ?? this.name,
        params: params ?? this.params,
        location: location ?? this.location,
      );

  factory Method.fromRawJson(String str) => Method.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json["id"],
        name: json["name"],
        params: Params.fromJson(json["params"]),
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "params": params.toJson(),
        "location": location.toJson(),
      };
}

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  Location copyWith({
    double? latitude,
    double? longitude,
  }) =>
      Location(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Params {
  int fajr;
  int isha;

  Params({
    required this.fajr,
    required this.isha,
  });

  Params copyWith({
    int? fajr,
    int? isha,
  }) =>
      Params(
        fajr: fajr ?? this.fajr,
        isha: isha ?? this.isha,
      );

  factory Params.fromRawJson(String str) => Params.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json["Fajr"],
        isha: json["Isha"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Isha": isha,
      };
}

class Timings {
  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String imsak;
  String midnight;
  String firstthird;
  String lastthird;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
  });

  Timings copyWith({
    String? fajr,
    String? sunrise,
    String? dhuhr,
    String? asr,
    String? sunset,
    String? maghrib,
    String? isha,
    String? imsak,
    String? midnight,
    String? firstthird,
    String? lastthird,
  }) =>
      Timings(
        fajr: fajr ?? this.fajr,
        sunrise: sunrise ?? this.sunrise,
        dhuhr: dhuhr ?? this.dhuhr,
        asr: asr ?? this.asr,
        sunset: sunset ?? this.sunset,
        maghrib: maghrib ?? this.maghrib,
        isha: isha ?? this.isha,
        imsak: imsak ?? this.imsak,
        midnight: midnight ?? this.midnight,
        firstthird: firstthird ?? this.firstthird,
        lastthird: lastthird ?? this.lastthird,
      );

  factory Timings.fromRawJson(String str) => Timings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
        firstthird: json["Firstthird"],
        lastthird: json["Lastthird"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
        "Firstthird": firstthird,
        "Lastthird": lastthird,
      };
}
