import 'dart:convert';

class Donation {
  final int code;
  final Data data;

  Donation({
    required this.code,
    required this.data,
  });

  factory Donation.fromRawJson(String str) =>
      Donation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final List<Donate> donate;

  Data({
    required this.donate,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        donate:
            List<Donate>.from(json["donate"].map((x) => Donate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "donate": List<dynamic>.from(donate.map((x) => x.toJson())),
      };
}

class Donate {
  final int donationcategoryId;
  final String donationcategoryName;
  final String orderSequence;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Hasdonation> hasdonation;

  Donate({
    required this.donationcategoryId,
    required this.donationcategoryName,
    required this.orderSequence,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.hasdonation,
  });

  factory Donate.fromRawJson(String str) => Donate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Donate.fromJson(Map<String, dynamic> json) => Donate(
        donationcategoryId: json["donationcategory_id"],
        donationcategoryName: json["donationcategory_name"],
        orderSequence: json["order_sequence"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        hasdonation: List<Hasdonation>.from(
            json["hasdonation"].map((x) => Hasdonation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "donationcategory_id": donationcategoryId,
        "donationcategory_name": donationcategoryName,
        "order_sequence": orderSequence,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "hasdonation": List<dynamic>.from(hasdonation.map((x) => x.toJson())),
      };
}

class Hasdonation {
  final int donationId;
  final String donationcategoryId;
  final String donationLink;
  final String donationName;
  final String donationImage;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hasdonation({
    required this.donationId,
    required this.donationcategoryId,
    required this.donationLink,
    required this.donationName,
    required this.donationImage,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hasdonation.fromRawJson(String str) =>
      Hasdonation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hasdonation.fromJson(Map<String, dynamic> json) => Hasdonation(
        donationId: json["donation_id"],
        donationcategoryId: json["donationcategory_id"],
        donationLink: json["donation_link"],
        donationName: json["donation_name"],
        donationImage: json["donation_image"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "donation_id": donationId,
        "donationcategory_id": donationcategoryId,
        "donation_link": donationLink,
        "donation_name": donationName,
        "donation_image": donationImage,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
