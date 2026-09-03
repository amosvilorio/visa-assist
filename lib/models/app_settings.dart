import 'package:cloud_firestore/cloud_firestore.dart';

class AppSettings {
  final String companyName;

  final String logo;

  final String email;

  final String phone;

  final String whatsapp;

  final String website;

  final String facebook;

  final String instagram;

  final String currency;

  final String currencySymbol;

  final double visaAssistPlusPrice;

  final bool promotionEnabled;

  final double promotionPrice;

  final String promotionTitle;

  final String promotionDescription;

  final bool maintenanceMode;

  final bool evaluationEnabled;

  final bool visaRequestEnabled;

  final Timestamp updatedAt;

  const AppSettings({
    required this.companyName,
    required this.logo,
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.website,
    required this.facebook,
    required this.instagram,
    required this.currency,
    required this.currencySymbol,
    required this.visaAssistPlusPrice,
    required this.promotionEnabled,
    required this.promotionPrice,
    required this.promotionTitle,
    required this.promotionDescription,
    required this.maintenanceMode,
    required this.evaluationEnabled,
    required this.visaRequestEnabled,
    required this.updatedAt,
  });

  factory AppSettings.fromMap(
      Map<String, dynamic> map,
      ) {
    return AppSettings(
      companyName: map["companyName"] ?? "Visa Assist",
      logo: map["logo"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
      whatsapp: map["whatsapp"] ?? "",
      website: map["website"] ?? "",
      facebook: map["facebook"] ?? "",
      instagram: map["instagram"] ?? "",
      currency: map["currency"] ?? "DOP",
      currencySymbol: map["currencySymbol"] ?? "RD\$",
      visaAssistPlusPrice: (map["visaAssistPlusPrice"] ?? 0).toDouble(),
      promotionEnabled: map["promotionEnabled"] ?? false,
      promotionPrice: (map["promotionPrice"] ?? 0).toDouble(),
      promotionTitle: map["promotionTitle"] ?? "",
      promotionDescription: map["promotionDescription"] ?? "",
      maintenanceMode: map["maintenanceMode"] ?? false,
      evaluationEnabled: map["evaluationEnabled"] ?? true,
      visaRequestEnabled: map["visaRequestEnabled"] ?? true,
      updatedAt: map["updatedAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "companyName": companyName,
      "logo": logo,
      "email": email,
      "phone": phone,
      "whatsapp": whatsapp,
      "website": website,
      "facebook": facebook,
      "instagram": instagram,
      "currency": currency,
      "currencySymbol": currencySymbol,
      "visaAssistPlusPrice": visaAssistPlusPrice,
      "promotionEnabled": promotionEnabled,
      "promotionPrice": promotionPrice,
      "promotionTitle": promotionTitle,
      "promotionDescription": promotionDescription,
      "maintenanceMode": maintenanceMode,
      "evaluationEnabled": evaluationEnabled,
      "visaRequestEnabled": visaRequestEnabled,
      "updatedAt": updatedAt,
    };
  }

  AppSettings copyWith({
    String? companyName,
    String? logo,
    String? email,
    String? phone,
    String? whatsapp,
    String? website,
    String? facebook,
    String? instagram,
    String? currency,
    String? currencySymbol,
    double? visaAssistPlusPrice,
    bool? promotionEnabled,
    double? promotionPrice,
    String? promotionTitle,
    String? promotionDescription,
    bool? maintenanceMode,
    bool? evaluationEnabled,
    bool? visaRequestEnabled,
    Timestamp? updatedAt,
  }) {
    return AppSettings(
      companyName: companyName ?? this.companyName,
      logo: logo ?? this.logo,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      website: website ?? this.website,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      visaAssistPlusPrice:
      visaAssistPlusPrice ?? this.visaAssistPlusPrice,
      promotionEnabled:
      promotionEnabled ?? this.promotionEnabled,
      promotionPrice:
      promotionPrice ?? this.promotionPrice,
      promotionTitle:
      promotionTitle ?? this.promotionTitle,
      promotionDescription:
      promotionDescription ?? this.promotionDescription,
      maintenanceMode:
      maintenanceMode ?? this.maintenanceMode,
      evaluationEnabled:
      evaluationEnabled ?? this.evaluationEnabled,
      visaRequestEnabled:
      visaRequestEnabled ?? this.visaRequestEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}