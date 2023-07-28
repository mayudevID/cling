// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel extends Equatable {
  UserModel({
    required this.id,
    required this.emailVerified,
    this.email,
    this.name,
    this.photo,
  });

  String? email;
  String id;
  bool emailVerified;
  String? name;
  String? photo;

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        photo,
        emailVerified,
      ];

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        photo: json["photo"],
        emailVerified: json["email_verified"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "photo": photo,
        "email_verified": emailVerified,
      };
}
