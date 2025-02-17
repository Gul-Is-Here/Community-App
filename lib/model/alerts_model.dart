import 'package:meta/meta.dart';
import 'dart:convert';

class AlertsModel {
  final int code;
  final Data data;

  AlertsModel({
    required this.code,
    required this.data,
  });

  AlertsModel copyWith({
    int? code,
    Data? data,
  }) =>
      AlertsModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory AlertsModel.fromRawJson(String str) =>
      AlertsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlertsModel.fromJson(Map<String, dynamic> json) => AlertsModel(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final List<Alert> alert;

  Data({
    required this.alert,
  });

  Data copyWith({
    List<Alert>? alert,
  }) =>
      Data(
        alert: alert ?? this.alert,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        alert: List<Alert>.from(json["Alert"].map((x) => Alert.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Alert": List<dynamic>.from(alert.map((x) => x.toJson())),
      };
}

class Alert {
  final int alertId;
  final String alertTitle;
  final String alertDescription;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;

  Alert(
      {required this.alertId,
      required this.alertTitle,
      required this.alertDescription,
      required this.active,
      required this.createdAt,
      required this.updatedAt,
      required this.image});

  Alert copyWith(
          {int? alertId,
          String? alertTitle,
          String? alertDescription,
          String? active,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? image}) =>
      Alert(
        alertId: alertId ?? this.alertId,
        alertTitle: alertTitle ?? this.alertTitle,
        alertDescription: alertDescription ?? this.alertDescription,
        active: active ?? this.active,
        image: image ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Alert.fromRawJson(String str) => Alert.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        alertId: json["alert_id"],
        alertTitle: json["alert_title"],
        alertDescription: json["alert_description"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        image: json["alert_image"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "alert_id": alertId,
        "alert_title": alertTitle,
        "alert_description": alertDescription,
        "_active": active,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
