import 'package:meta/meta.dart';
import 'dart:convert';

class Events {
  final int code;
  final Data data;

  Events({
    required this.code,
    required this.data,
  });

  Events copyWith({
    int? code,
    Data? data,
  }) =>
      Events(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory Events.fromRawJson(String str) => Events.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final DateTime mytime;
  final List<Event> events;

  Data({
    required this.mytime,
    required this.events,
  });

  Data copyWith({
    DateTime? mytime,
    List<Event>? events,
  }) =>
      Data(
        mytime: mytime ?? this.mytime,
        events: events ?? this.events,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mytime: DateTime.parse(json["mytime"]),
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mytime": mytime.toIso8601String(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  final int eventId;
  final String eventtypeId;
  final String eventTitle;
  final String eventDetail;
  final String eventLink;
  final String eventImage;
  final DateTime eventDate;
  final String eventStarttime;
  final String eventEndtime;
  final String venueName;
  final String paid;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Eventhastype eventhastype;

  Event({
    required this.eventId,
    required this.eventtypeId,
    required this.eventTitle,
    required this.eventDetail,
    required this.eventLink,
    required this.eventImage,
    required this.eventDate,
    required this.eventStarttime,
    required this.eventEndtime,
    required this.venueName,
    required this.paid,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.eventhastype,
  });

  Event copyWith({
    int? eventId,
    String? eventtypeId,
    String? eventTitle,
    String? eventDetail,
    String? eventLink,
    String? eventImage,
    DateTime? eventDate,
    String? eventStarttime,
    String? eventEndtime,
    String? venueName,
    String? paid,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    Eventhastype? eventhastype,
  }) =>
      Event(
        eventId: eventId ?? this.eventId,
        eventtypeId: eventtypeId ?? this.eventtypeId,
        eventTitle: eventTitle ?? this.eventTitle,
        eventDetail: eventDetail ?? this.eventDetail,
        eventLink: eventLink ?? this.eventLink,
        eventImage: eventImage ?? this.eventImage,
        eventDate: eventDate ?? this.eventDate,
        eventStarttime: eventStarttime ?? this.eventStarttime,
        eventEndtime: eventEndtime ?? this.eventEndtime,
        venueName: venueName ?? this.venueName,
        paid: paid ?? this.paid,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        eventhastype: eventhastype ?? this.eventhastype,
      );

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"],
        eventtypeId: json["eventtype_id"],
        eventTitle: json["event_title"],
        eventDetail: json["event_detail"],
        eventLink: json["event_link"],
        eventImage: json["event_image"],
        eventDate: DateTime.parse(json["event_date"]),
        eventStarttime: json["event_starttime"],
        eventEndtime: json["event_endtime"],
        venueName: json["venue_name"],
        paid: json["paid"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        eventhastype: Eventhastype.fromJson(json["eventhastype"]),
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "eventtype_id": eventtypeId,
        "event_title": eventTitle,
        "event_detail": eventDetail,
        "event_link": eventLink,
        "event_image": eventImage,
        "event_date": eventDate.toIso8601String(),
        "event_starttime": eventStarttime,
        "event_endtime": eventEndtime,
        "venue_name": venueName,
        "paid": paid,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "eventhastype": eventhastype.toJson(),
      };
}

class Eventhastype {
  final int eventtypeId;
  final String eventtypeName;
  final String eventtypeIcon;
  final String eventtypeBgcolor;
  final String eventtypeTextcolor;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Eventhastype({
    required this.eventtypeId,
    required this.eventtypeName,
    required this.eventtypeIcon,
    required this.eventtypeBgcolor,
    required this.eventtypeTextcolor,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Eventhastype copyWith({
    int? eventtypeId,
    String? eventtypeName,
    String? eventtypeIcon,
    String? eventtypeBgcolor,
    String? eventtypeTextcolor,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Eventhastype(
        eventtypeId: eventtypeId ?? this.eventtypeId,
        eventtypeName: eventtypeName ?? this.eventtypeName,
        eventtypeIcon: eventtypeIcon ?? this.eventtypeIcon,
        eventtypeBgcolor: eventtypeBgcolor ?? this.eventtypeBgcolor,
        eventtypeTextcolor: eventtypeTextcolor ?? this.eventtypeTextcolor,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Eventhastype.fromRawJson(String str) =>
      Eventhastype.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Eventhastype.fromJson(Map<String, dynamic> json) => Eventhastype(
        eventtypeId: json["eventtype_id"],
        eventtypeName: json["eventtype_name"],
        eventtypeIcon: json["eventtype_icon"],
        eventtypeBgcolor: json["eventtype_bgcolor"],
        eventtypeTextcolor: json["eventtype_textcolor"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "eventtype_id": eventtypeId,
        "eventtype_name": eventtypeName,
        "eventtype_icon": eventtypeIcon,
        "eventtype_bgcolor": eventtypeBgcolor,
        "eventtype_textcolor": eventtypeTextcolor,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
