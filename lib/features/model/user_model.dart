// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel extends Equatable {
  UserModel({
    required this.id,
    required this.verifiedProcess,
    this.email,
    this.name,
    this.photo,
  });

  String? email;
  String id;
  bool verifiedProcess;
  String? name;
  String? photo;

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        photo,
        verifiedProcess,
      ];

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        photo: json["photo"],
        verifiedProcess: json["verified_process"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "photo": photo,
        "verified_process": verifiedProcess,
      };

  UserModel copyWith({
    String? email,
    String? id,
    String? name,
    String? photo,
    bool? verifiedProcess,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      verifiedProcess: verifiedProcess ?? this.verifiedProcess,
    );
  }
}
