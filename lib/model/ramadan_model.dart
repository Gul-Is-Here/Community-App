import 'dart:convert';

class RamadanResponse {
  final List<RamadanEvent> ramadan;
  final List<FullCalendar> fullCalendar;
  final List<TodaysData> todaysData;
  final String todaysDate;

  RamadanResponse({
    required this.ramadan,
    required this.fullCalendar,
    required this.todaysData,
    required this.todaysDate,
  });

  factory RamadanResponse.fromJson(Map<String, dynamic> json) {
    return RamadanResponse(
      ramadan: (json['data']['ramadan'] as List)
          .map((e) => RamadanEvent.fromJson(e))
          .toList(),
      fullCalendar: (json['data']['full_calendar'] as List)
          .map((e) => FullCalendar.fromJson(e))
          .toList(),
      todaysData: (json['data']['todays_data'] as List)
          .map((e) => TodaysData.fromJson(e))
          .toList(),
      todaysDate: json['data']['todays_date'],
    );
  }
}

class RamadanEvent {
  final int id;
  final String title;
  final String? description;
  final String? attachment;
  final String icon;
  final String? url;
  final String btnText;
  final String btnColor;
  final String btnTextColor;

  RamadanEvent({
    required this.id,
    required this.title,
    this.description,
    this.attachment,
    required this.icon,
    this.url,
    required this.btnText,
    required this.btnColor,
    required this.btnTextColor,
  });

  factory RamadanEvent.fromJson(Map<String, dynamic> json) {
    return RamadanEvent(
      id: json['ramadan_id'],
      title: json['title'],
      description: json['description'],
      attachment: json['attachment'],
      icon: json['icon'],
      url: json['url'],
      btnText: json['btn_text'],
      btnColor: json['btn_color'],
      btnTextColor: json['btn_text_color'],
    );
  }
}

class FullCalendar {
  final String date;
  final String day;
  final int juz;
  final List<String> rakats;

  FullCalendar({
    required this.date,
    required this.day,
    required this.juz,
    required this.rakats,
  });

  factory FullCalendar.fromJson(Map<String, dynamic> json) {
    return FullCalendar(
      date: json['date'],
      day: json['day'],
      juz: json['juz'],
      rakats: List.generate(20, (i) => json['rakat_${i + 1}'] ?? ''),
    );
  }
}

class TodaysData {
  final String date;
  final String day;
  final int juz;
  final List<String> rakats;

  TodaysData({
    required this.date,
    required this.day,
    required this.juz,
    required this.rakats,
  });

  factory TodaysData.fromJson(Map<String, dynamic> json) {
    return TodaysData(
      date: json['date'],
      day: json['day'],
      juz: json['juz'],
      rakats: List.generate(20, (i) => json['rakat_${i + 1}'] ?? ''),
    );
  }
}
