import 'package:meta/meta.dart';
import 'dart:convert';

class EventsModel {
  final int code;
  final Data data;

  EventsModel({
    required this.code,
    required this.data,
  });

  factory EventsModel.fromRawJson(String str) =>
      EventsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  final Category category;
  final List<Subcategory> subcategory;

  Data({
    required this.category,
    required this.subcategory,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        category: Category.fromJson(json["category"]),
        subcategory: List<Subcategory>.from(
            json["subcategory"].map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category.toJson(),
        "subcategory": List<dynamic>.from(subcategory.map((x) => x.toJson())),
      };
}

class Category {
  final int galleryCategoryId;
  final String galleryCategoryName;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.galleryCategoryId,
    required this.galleryCategoryName,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        galleryCategoryId: json["gallery_category_id"],
        galleryCategoryName: json["gallery_category_name"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "gallery_category_id": galleryCategoryId,
        "gallery_category_name": galleryCategoryName,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Subcategory {
  final int gallerySubcategoryId;
  final String galleryCategoryId;
  final String gallerySubcategoryName;
  final String gallerySubcategoryHash;
  final String active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subcategory({
    required this.gallerySubcategoryId,
    required this.galleryCategoryId,
    required this.gallerySubcategoryName,
    required this.gallerySubcategoryHash,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subcategory.fromRawJson(String str) =>
      Subcategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        gallerySubcategoryId: json["gallery_subcategory_id"],
        galleryCategoryId: json["gallery_category_id"],
        gallerySubcategoryName: json["gallery_subcategory_name"],
        gallerySubcategoryHash: json["gallery_subcategory_hash"],
        active: json["_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "gallery_subcategory_id": gallerySubcategoryId,
        "gallery_category_id": galleryCategoryId,
        "gallery_subcategory_name": gallerySubcategoryName,
        "gallery_subcategory_hash": gallerySubcategoryHash,
        "_active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
