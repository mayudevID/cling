// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cling/features/model/currency.dart';
import 'package:equatable/equatable.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel extends Equatable {
  UserModel({
    required this.uid,
    required this.verifiedProcess,
    required this.currency,
    this.lastBackupTime,
    this.backupUrl,
    required this.monthlyBudget,
    required this.monthlyIncome,
    required this.createdAt,
    required this.updatedAt,
  });

  String uid;
  bool verifiedProcess;
  DateTime? lastBackupTime;
  String? backupUrl;
  Currency currency;
  double monthlyBudget;
  double monthlyIncome;
  DateTime createdAt;
  DateTime updatedAt;

  @override
  List<Object?> get props => [
        uid,
        lastBackupTime,
        backupUrl,
        verifiedProcess,
        currency,
        monthlyBudget,
        monthlyIncome,
        createdAt,
        updatedAt,
      ];

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        lastBackupTime: DateTime.tryParse(json["last_backup_time"] ?? ""),
        backupUrl: json['backup_url'],
        verifiedProcess: json["verified_process"],
        currency: Currency.values.firstWhere(
          (e) => e.value.countryCode == json["currency"],
          orElse: () => Currency.idr,
        ),
        monthlyBudget: json["monthly_budget"].toDouble(),
        monthlyIncome: json["monthly_income"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "last_backup_time": lastBackupTime?.toIso8601String(),
        "backup_url": backupUrl,
        "verified_process": verifiedProcess,
        "currency": currency.value.countryCode,
        "monthly_budget": monthlyBudget,
        "monthly_income": monthlyIncome,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  factory UserModel.empty() => UserModel(
        uid: '-1',
        verifiedProcess: false,
        currency: Currency.idr,
        lastBackupTime: null,
        backupUrl: null,
        monthlyBudget: 0.0,
        monthlyIncome: 0.0,
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
      );

  UserModel copyWith({
    String? uid,
    DateTime? lastBackupTime,
    String? backupUrl,
    bool? verifiedProcess,
    Currency? currency,
    double? monthlyBudget,
    double? monthlyIncome,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      backupUrl: backupUrl ?? this.backupUrl,
      verifiedProcess: verifiedProcess ?? this.verifiedProcess,
      currency: currency ?? this.currency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
