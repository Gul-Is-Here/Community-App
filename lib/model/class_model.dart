import 'package:meta/meta.dart';
import 'dart:convert';

class ClassesModel {
  final int code;
  final Data data;

  ClassesModel({
    required this.code,
    required this.data,
  });

  factory ClassesModel.fromRawJson(String str) =>
      ClassesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassesModel.fromJson(Map<String, dynamic> json) => ClassesModel(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final List<Class> classes;

  Data({
    required this.classes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        classes: json["Classes"] != null
            ? List<Class>.from(json["Classes"].map((x) => Class.fromJson(x)))
            : [], // Return an empty list if "Classes" is null
      );

  Map<String, dynamic> toJson() => {
        "Classes": List<dynamic>.from(classes.map((x) => x.toJson())),
      };
}

class Class {
  final int classId;
  final String id;
  final String classTeacher;
  final String? disclaimerId; // Made nullable
  final String className;
  final String classFees;
  final String classGender;
  final String minimumAge;
  final String maximumAge;
  final DateTime startDate;
  final DateTime endDate;
  final String classHeldDates;
  final String startTime;
  final String endTime;
  final String classDescription;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClassHasDisclaimer? classHasDisclaimer; // Made nullable

  Class({
    required this.classId,
    required this.id,
    required this.classTeacher,
    this.disclaimerId, // Made nullable
    required this.className,
    required this.classFees,
    required this.classGender,
    required this.minimumAge,
    required this.maximumAge,
    required this.startDate,
    required this.endDate,
    required this.classHeldDates,
    required this.startTime,
    required this.endTime,
    required this.classDescription,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.classHasDisclaimer, // Made nullable
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        classId: json["class_id"],
        id: json["id"],
        classTeacher: json["class_teacher"],
        disclaimerId: json["disclaimer_id"] ?? null, // Allow null
        className: json["class_name"],
        classFees: json["class_fees"],
        classGender: json["class_gender"],
        minimumAge: json["minimum_age"],
        maximumAge: json["maximum_age"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        classHeldDates: json["class_held_dates"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        classDescription: json["class_description"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        classHasDisclaimer: json["class_has_disclaimer"] != null
            ? ClassHasDisclaimer.fromJson(json["class_has_disclaimer"])
            : null, // Allow null for disclaimer
      );

  Map<String, dynamic> toJson() => {
        "class_id": classId,
        "id": id,
        "class_teacher": classTeacher,
        "disclaimer_id": disclaimerId, // Allow null
        "class_name": className,
        "class_fees": classFees,
        "class_gender": classGender,
        "minimum_age": minimumAge,
        "maximum_age": maximumAge,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "class_held_dates": classHeldDates,
        "start_time": startTime,
        "end_time": endTime,
        "class_description": classDescription,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "class_has_disclaimer": classHasDisclaimer?.toJson(), // Allow null
      };
}

class ClassHasDisclaimer {
  final int disclaimerId;
  final String disclaimerTitle;
  final String disclaimerDescription;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassHasDisclaimer({
    required this.disclaimerId,
    required this.disclaimerTitle,
    required this.disclaimerDescription,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassHasDisclaimer.fromJson(Map<String, dynamic> json) =>
      ClassHasDisclaimer(
        disclaimerId: json["disclaimer_id"],
        disclaimerTitle: json["disclaimer_title"],
        disclaimerDescription: json["disclaimer_description"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "disclaimer_id": disclaimerId,
        "disclaimer_title": disclaimerTitle,
        "disclaimer_description": disclaimerDescription,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
