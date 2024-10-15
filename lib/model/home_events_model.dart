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
    final String eventDetail;
    final String eventLink;
    final DateTime eventDate;
    final String active;
    final DateTime createdAt;
    final DateTime updatedAt;

    Event({
        required this.eventId,
        required this.eventDetail,
        required this.eventLink,
        required this.eventDate,
        required this.active,
        required this.createdAt,
        required this.updatedAt,
    });

    Event copyWith({
        int? eventId,
        String? eventDetail,
        String? eventLink,
        DateTime? eventDate,
        String? active,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Event(
            eventId: eventId ?? this.eventId,
            eventDetail: eventDetail ?? this.eventDetail,
            eventLink: eventLink ?? this.eventLink,
            eventDate: eventDate ?? this.eventDate,
            active: active ?? this.active,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["event_id"],
        eventDetail: json["event_detail"],
        eventLink: json["event_link"],
        eventDate: DateTime.parse(json["event_date"]),
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_detail": eventDetail,
        "event_link": eventLink,
        "event_date": eventDate.toIso8601String(),
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
