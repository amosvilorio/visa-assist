import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccount {
  final String id;

  final String bankName;

  final String accountHolder;

  final String accountType;

  final String accountNumber;

  final String currency;

  final bool enabled;

  final int order;

  final DateTime createdAt;

  final DateTime updatedAt;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountHolder,
    required this.accountType,
    required this.accountNumber,
    required this.currency,
    required this.enabled,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankAccount.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return BankAccount(
      id: id,
      bankName: json["bankName"] ?? "",
      accountHolder: json["accountHolder"] ?? "",
      accountType: json["accountType"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      currency: json["currency"] ?? "DOP",
      enabled: json["enabled"] ?? true,
      order: json["order"] ?? 0,
      createdAt: (json["createdAt"] as Timestamp?)?.toDate() ??
          DateTime.now(),
      updatedAt: (json["updatedAt"] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "bankName": bankName,
      "accountHolder": accountHolder,
      "accountType": accountType,
      "accountNumber": accountNumber,
      "currency": currency,
      "enabled": enabled,
      "order": order,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountHolder,
    String? accountType,
    String? accountNumber,
    String? currency,
    bool? enabled,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountHolder: accountHolder ?? this.accountHolder,
      accountType: accountType ?? this.accountType,
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
      enabled: enabled ?? this.enabled,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}