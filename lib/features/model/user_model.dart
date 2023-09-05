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
    required this.email,
    required this.name,
    this.lastBackupTime,
    this.backupUrl,
    required this.monthlyBudget,
    required this.monthlyIncome,
  });

  String email;
  String id;
  bool verifiedProcess;
  String name;
  DateTime? lastBackupTime;
  String? backupUrl;
  Currency currency;
  double monthlyBudget;
  double monthlyIncome;

  @override
  List<Object?> get props => [
        email,
        id,
        name,
        lastBackupTime,
        backupUrl,
        verifiedProcess,
        currency,
        monthlyBudget,
        monthlyIncome,
      ];

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        lastBackupTime: DateTime.tryParse(json["last_backup_time"]),
        backupUrl: json['backup_url'],
        verifiedProcess: json["verified_process"],
        currency: Currency.values.firstWhere(
          (e) => e.value.countryCode == json["currency"],
          orElse: () => Currency.idr,
        ),
        monthlyBudget: json["monthly_budget"].toDouble(),
        monthlyIncome: json["monthly_income"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "last_backup_time": lastBackupTime?.toIso8601String(),
        "backup_url": backupUrl,
        "verified_process": verifiedProcess,
        "currency": currency.value.countryCode,
        "monthly_budget": monthlyBudget,
        "monthly_income": monthlyIncome,
      };

  factory UserModel.empty() => UserModel(
        id: '-1',
        verifiedProcess: false,
        currency: Currency.idr,
        email: "",
        name: "",
        lastBackupTime: null,
        backupUrl: null,
        monthlyBudget: 0.0,
        monthlyIncome: 0.0,
      );

  UserModel copyWith({
    String? email,
    String? id,
    String? name,
    DateTime? lastBackupTime,
    String? backupUrl,
    bool? verifiedProcess,
    Currency? currency,
    double? monthlyBudget,
    double? monthlyIncome,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      backupUrl: backupUrl ?? this.backupUrl,
      verifiedProcess: verifiedProcess ?? this.verifiedProcess,
      currency: currency ?? this.currency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}
