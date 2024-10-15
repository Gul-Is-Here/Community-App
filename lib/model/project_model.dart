import 'package:meta/meta.dart';
import 'dart:convert';

class ProjectModel {
  final int code;
  final Data data;

  ProjectModel({
    required this.code,
    required this.data,
  });

  ProjectModel copyWith({
    int? code,
    Data? data,
  }) =>
      ProjectModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory ProjectModel.fromRawJson(String str) =>
      ProjectModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        code: json["code"] ?? 0, // Provide a default value
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final List<X> x;

  Data({
    required this.x,
  });

  Data copyWith({
    List<X>? x,
  }) =>
      Data(
        x: x ?? this.x,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        x: json["x"] != null
            ? List<X>.from(json["x"].map((x) => X.fromJson(x)))
            : [], // Provide an empty list if null
      );

  Map<String, dynamic> toJson() => {
        "x": List<dynamic>.from(x.map((x) => x.toJson())),
      };
}

class X {
  final int projectId;
  final String projectTitle;
  final String projectDescription;
  final String projectImage;
  final DateTime? projectDate; // Make it nullable
  final String active;
  final DateTime? createdAt; // Make it nullable
  final DateTime? updatedAt; // Make it nullable

  X({
    required this.projectId,
    required this.projectTitle,
    required this.projectDescription,
    required this.projectImage,
    this.projectDate, // Nullable DateTime
    required this.active,
    this.createdAt, // Nullable DateTime
    this.updatedAt, // Nullable DateTime
  });

  X copyWith({
    int? projectId,
    String? projectTitle,
    String? projectDescription,
    String? projectImage,
    DateTime? projectDate,
    String? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      X(
        projectId: projectId ?? this.projectId,
        projectTitle: projectTitle ?? this.projectTitle,
        projectDescription: projectDescription ?? this.projectDescription,
        projectImage: projectImage ?? this.projectImage,
        projectDate: projectDate ?? this.projectDate,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory X.fromRawJson(String str) => X.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory X.fromJson(Map<String, dynamic> json) => X(
        projectId: json["project_id"] ?? 0,
        projectTitle: json["project_title"] ?? "",
        projectDescription: json["project_description"] ?? "",
        projectImage: json["project_image"] ?? "",
        projectDate: json["project_date"] != null
            ? DateTime.tryParse(json["project_date"])
            : null,
        active: json["_active"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "project_title": projectTitle,
        "project_description": projectDescription,
        "project_image": projectImage,
        "project_date":
            projectDate?.toIso8601String(), // Handle nullable DateTime
        "_active": active,
        "created_at": createdAt?.toIso8601String(), // Handle nullable DateTime
        "updated_at": updatedAt?.toIso8601String(), // Handle nullable DateTime
      };
}
