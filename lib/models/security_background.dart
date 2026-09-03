class SecurityBackground {
  // SALUD
  final bool hasCommunicableDisease;
  final bool hasMentalDisorder;
  final bool drugAbuser;

  // CRIMINAL
  final bool arrestedOrConvicted;
  final bool violatedControlledSubstancesLaw;
  final bool prostitutionOrVice;
  final bool moneyLaundering;

  // SEGURIDAD
  final bool espionage;
  final bool terrorism;
  final bool genocide;
  final bool torture;
  final bool childSoldier;

  // INMIGRACIÓN
  final bool visaFraud;
  final bool deported;
  final bool unlawfullyPresent;

  // INFORMACIÓN ADICIONAL
  final String explanation;

  const SecurityBackground({
    this.hasCommunicableDisease = false,
    this.hasMentalDisorder = false,
    this.drugAbuser = false,
    this.arrestedOrConvicted = false,
    this.violatedControlledSubstancesLaw = false,
    this.prostitutionOrVice = false,
    this.moneyLaundering = false,
    this.espionage = false,
    this.terrorism = false,
    this.genocide = false,
    this.torture = false,
    this.childSoldier = false,
    this.visaFraud = false,
    this.deported = false,
    this.unlawfullyPresent = false,
    this.explanation = '',
  });

  SecurityBackground copyWith({
    bool? hasCommunicableDisease,
    bool? hasMentalDisorder,
    bool? drugAbuser,
    bool? arrestedOrConvicted,
    bool? violatedControlledSubstancesLaw,
    bool? prostitutionOrVice,
    bool? moneyLaundering,
    bool? espionage,
    bool? terrorism,
    bool? genocide,
    bool? torture,
    bool? childSoldier,
    bool? visaFraud,
    bool? deported,
    bool? unlawfullyPresent,
    String? explanation,
  }) {
    return SecurityBackground(
      hasCommunicableDisease:
      hasCommunicableDisease ?? this.hasCommunicableDisease,
      hasMentalDisorder:
      hasMentalDisorder ?? this.hasMentalDisorder,
      drugAbuser:
      drugAbuser ?? this.drugAbuser,
      arrestedOrConvicted:
      arrestedOrConvicted ?? this.arrestedOrConvicted,
      violatedControlledSubstancesLaw:
      violatedControlledSubstancesLaw ??
          this.violatedControlledSubstancesLaw,
      prostitutionOrVice:
      prostitutionOrVice ?? this.prostitutionOrVice,
      moneyLaundering:
      moneyLaundering ?? this.moneyLaundering,
      espionage:
      espionage ?? this.espionage,
      terrorism:
      terrorism ?? this.terrorism,
      genocide:
      genocide ?? this.genocide,
      torture:
      torture ?? this.torture,
      childSoldier:
      childSoldier ?? this.childSoldier,
      visaFraud:
      visaFraud ?? this.visaFraud,
      deported:
      deported ?? this.deported,
      unlawfullyPresent:
      unlawfullyPresent ?? this.unlawfullyPresent,
      explanation:
      explanation ?? this.explanation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hasCommunicableDisease": hasCommunicableDisease,
      "hasMentalDisorder": hasMentalDisorder,
      "drugAbuser": drugAbuser,
      "arrestedOrConvicted": arrestedOrConvicted,
      "violatedControlledSubstancesLaw":
      violatedControlledSubstancesLaw,
      "prostitutionOrVice": prostitutionOrVice,
      "moneyLaundering": moneyLaundering,
      "espionage": espionage,
      "terrorism": terrorism,
      "genocide": genocide,
      "torture": torture,
      "childSoldier": childSoldier,
      "visaFraud": visaFraud,
      "deported": deported,
      "unlawfullyPresent": unlawfullyPresent,
      "explanation": explanation,
    };
  }

  factory SecurityBackground.fromMap(
      Map<String, dynamic> map) {
    return SecurityBackground(
      hasCommunicableDisease:
      map["hasCommunicableDisease"] ?? false,
      hasMentalDisorder:
      map["hasMentalDisorder"] ?? false,
      drugAbuser:
      map["drugAbuser"] ?? false,
      arrestedOrConvicted:
      map["arrestedOrConvicted"] ?? false,
      violatedControlledSubstancesLaw:
      map["violatedControlledSubstancesLaw"] ?? false,
      prostitutionOrVice:
      map["prostitutionOrVice"] ?? false,
      moneyLaundering:
      map["moneyLaundering"] ?? false,
      espionage:
      map["espionage"] ?? false,
      terrorism:
      map["terrorism"] ?? false,
      genocide:
      map["genocide"] ?? false,
      torture:
      map["torture"] ?? false,
      childSoldier:
      map["childSoldier"] ?? false,
      visaFraud:
      map["visaFraud"] ?? false,
      deported:
      map["deported"] ?? false,
      unlawfullyPresent:
      map["unlawfullyPresent"] ?? false,
      explanation:
      map["explanation"] ?? "",
    );
  }
}