import 'package:meta/meta.dart';
import 'dart:convert';

class UserModelData {
    final User user;

    UserModelData({
        required this.user,
    });

    UserModelData copyWith({
        User? user,
    }) => 
        UserModelData(
            user: user ?? this.user,
        );

    factory UserModelData.fromRawJson(String str) => UserModelData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModelData.fromJson(Map<String, dynamic> json) => UserModelData(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    final int id;
    final dynamic relationId;
    final String roleId;
    final String firstName;
    final String lastName;
    final String name;
    final String username;
    final dynamic gender;
    final String relationType;
    final String profileImage;
    final String email;
    final dynamic number;
    final dynamic dob;
    final dynamic profession;
    final dynamic community;
    final dynamic residentialAddress;
    final dynamic city;
    final dynamic state;
    final dynamic zipCode;
    final dynamic emailVerifiedAt;
    final bool active;
    final String createdAt;
    final String updatedAt;

    User({
        required this.id,
        required this.relationId,
        required this.roleId,
        required this.firstName,
        required this.lastName,
        required this.name,
        required this.username,
        required this.gender,
        required this.relationType,
        required this.profileImage,
        required this.email,
        required this.number,
        required this.dob,
        required this.profession,
        required this.community,
        required this.residentialAddress,
        required this.city,
        required this.state,
        required this.zipCode,
        required this.emailVerifiedAt,
        required this.active,
        required this.createdAt,
        required this.updatedAt,
    });

    User copyWith({
        int? id,
        dynamic relationId,
        String? roleId,
        String? firstName,
        String? lastName,
        String? name,
        String? username,
        dynamic gender,
        String? relationType,
        String? profileImage,
        String? email,
        dynamic number,
        dynamic dob,
        dynamic profession,
        dynamic community,
        dynamic residentialAddress,
        dynamic city,
        dynamic state,
        dynamic zipCode,
        dynamic emailVerifiedAt,
        bool? active,
        String? createdAt,
        String? updatedAt,
    }) => 
        User(
            id: id ?? this.id,
            relationId: relationId ?? this.relationId,
            roleId: roleId ?? this.roleId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            name: name ?? this.name,
            username: username ?? this.username,
            gender: gender ?? this.gender,
            relationType: relationType ?? this.relationType,
            profileImage: profileImage ?? this.profileImage,
            email: email ?? this.email,
            number: number ?? this.number,
            dob: dob ?? this.dob,
            profession: profession ?? this.profession,
            community: community ?? this.community,
            residentialAddress: residentialAddress ?? this.residentialAddress,
            city: city ?? this.city,
            state: state ?? this.state,
            zipCode: zipCode ?? this.zipCode,
            emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
            active: active ?? this.active,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        relationId: json["relation_id"],
        roleId: json["role_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        name: json["name"],
        username: json["username"],
        gender: json["gender"],
        relationType: json["relation_type"],
        profileImage: json["profile_image"],
        email: json["email"],
        number: json["number"],
        dob: json["dob"],
        profession: json["profession"],
        community: json["community"],
        residentialAddress: json["residential_address"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        emailVerifiedAt: json["email_verified_at"],
        active: json["_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "relation_id": relationId,
        "role_id": roleId,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "username": username,
        "gender": gender,
        "relation_type": relationType,
        "profile_image": profileImage,
        "email": email,
        "number": number,
        "dob": dob,
        "profession": profession,
        "community": community,
        "residential_address": residentialAddress,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "email_verified_at": emailVerifiedAt,
        "_active": active,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
