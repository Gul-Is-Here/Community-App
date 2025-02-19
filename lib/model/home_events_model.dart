import 'dart:convert';

class Events {
  final int code;
  final Data? data; // Nullable to prevent null check errors

  Events({required this.code, this.data});

  factory Events.fromRawJson(String str) => Events.fromJson(json.decode(str));

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        code: json["code"] ?? 0,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );
}

class Data {
  final DateTime mytime;
  final List<Event> events;

  Data({required this.mytime, required this.events});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mytime: DateTime.tryParse(json["mytime"] ?? "") ?? DateTime.now(),
        events: (json["events"] as List?)
                ?.map((e) => Event.fromJson(e ?? {}))
                .toList() ??
            [],
      );
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
  final String resType;
  final String? resUrl; // Nullable field
  final String isNotification;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Eventhastype? eventhastype; // Nullable field

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
    required this.resType,
    this.resUrl, // Nullable
    required this.isNotification,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.eventhastype, // Nullable
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"] ?? 0,
        eventtypeId: json["eventtype_id"] ?? "",
        eventTitle: json["event_title"] ?? "",
        eventDetail: json["event_detail"] ?? "",
        eventLink: json["event_link"] ?? "",
        eventImage: json["event_image"] ?? "",
        eventDate:
            DateTime.tryParse(json["event_date"] ?? "") ?? DateTime.now(),
        eventStarttime: json["event_starttime"] ?? "",
        eventEndtime: json["event_endtime"] ?? "",
        venueName: json["venue_name"] ?? "",
        paid: json["paid"] ?? "0",
        resType: json["res_type"] ?? "",
        resUrl: json["res_url"], // Can be null
        isNotification: json["is_notificaiton"] ?? "0",
        active: json["_active"] ?? "0",
        createdAt:
            DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
        eventhastype: json["eventhastype"] != null
            ? Eventhastype.fromJson(json["eventhastype"])
            : null, // Nullable
      );
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

  factory Eventhastype.fromJson(Map<String, dynamic> json) => Eventhastype(
        eventtypeId: json["eventtype_id"] ?? 0,
        eventtypeName: json["eventtype_name"] ?? "",
        eventtypeIcon: json["eventtype_icon"] ?? "",
        eventtypeBgcolor: json["eventtype_bgcolor"] ?? "#FFFFFF",
        eventtypeTextcolor: json["eventtype_textcolor"] ?? "#000000",
        active: json["_active"] ?? "0",
        createdAt:
            DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
      );
}
