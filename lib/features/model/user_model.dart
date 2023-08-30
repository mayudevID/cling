// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cling/features/model/currency.dart';
import 'package:equatable/equatable.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel extends Equatable {
  UserModel({
    required this.id,
    required this.verifiedProcess,
    required this.currency,
    this.email,
    this.name,
    this.photo,
    required this.monthlyBudget,
    required this.monthlyIncome,
  });

  String? email;
  String id;
  bool verifiedProcess;
  String? name;
  String? photo;
  Currency currency;
  double monthlyBudget;
  double monthlyIncome;

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        photo,
        verifiedProcess,
        currency,
        monthlyBudget,
        monthlyIncome,
      ];

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        photo: json["photo"],
        verifiedProcess: json["verified_process"],
        currency: Currency.values.firstWhere(
          (e) => e.value == json["currency"],
          orElse: () => Currency.idr,
        ),
        monthlyBudget: json["monthly_budget"],
        monthlyIncome: json["monthly_income"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "photo": photo,
        "verified_process": verifiedProcess,
        "currency": currency.value.countryCode,
        "monthly_budget": monthlyBudget,
        "monthly_income": monthlyIncome,
      };

  UserModel copyWith({
    String? email,
    String? id,
    String? name,
    String? photo,
    bool? verifiedProcess,
    Currency? currency,
    double? monthlyBudget,
    double? monthlyIncome,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      verifiedProcess: verifiedProcess ?? this.verifiedProcess,
      currency: currency ?? this.currency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}
