class PassportInformation {

  final String passportNumber;

  final String passportBookNumber;

  final bool hasPassportBookNumber;

  final String issuingCountry;

  final String issuingCity;

  final String issuingState;

  final DateTime issueDate;

  final DateTime expirationDate;

  final bool hasLostPassport;

  final String lostPassportNumber;

  final String lostPassportCountry;

  final String explanation;

  const PassportInformation({

    required this.passportNumber,

    required this.passportBookNumber,

    required this.hasPassportBookNumber,

    required this.issuingCountry,

    required this.issuingCity,

    required this.issuingState,

    required this.issueDate,

    required this.expirationDate,

    required this.hasLostPassport,

    required this.lostPassportNumber,

    required this.lostPassportCountry,

    required this.explanation,

  });

  factory PassportInformation.fromMap(
      Map<String, dynamic> map,
      ) {

    return PassportInformation(

      passportNumber:
      map["passportNumber"] ?? "",

      passportBookNumber:
      map["passportBookNumber"] ?? "",

      hasPassportBookNumber:
      map["hasPassportBookNumber"] ?? false,

      issuingCountry:
      map["issuingCountry"] ?? "",

      issuingCity:
      map["issuingCity"] ?? "",

      issuingState:
      map["issuingState"] ?? "",

      issueDate:
      DateTime.parse(map["issueDate"]),

      expirationDate:
      DateTime.parse(map["expirationDate"]),

      hasLostPassport:
      map["hasLostPassport"] ?? false,

      lostPassportNumber:
      map["lostPassportNumber"] ?? "",

      lostPassportCountry:
      map["lostPassportCountry"] ?? "",

      explanation:
      map["explanation"] ?? "",

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "passportNumber":
      passportNumber,

      "passportBookNumber":
      passportBookNumber,

      "hasPassportBookNumber":
      hasPassportBookNumber,

      "issuingCountry":
      issuingCountry,

      "issuingCity":
      issuingCity,

      "issuingState":
      issuingState,

      "issueDate":
      issueDate.toIso8601String(),

      "expirationDate":
      expirationDate.toIso8601String(),

      "hasLostPassport":
      hasLostPassport,

      "lostPassportNumber":
      lostPassportNumber,

      "lostPassportCountry":
      lostPassportCountry,

      "explanation":
      explanation,

    };

  }

  PassportInformation copyWith({

    String? passportNumber,

    String? passportBookNumber,

    bool? hasPassportBookNumber,

    String? issuingCountry,

    String? issuingCity,

    String? issuingState,

    DateTime? issueDate,

    DateTime? expirationDate,

    bool? hasLostPassport,

    String? lostPassportNumber,

    String? lostPassportCountry,

    String? explanation,

  }) {

    return PassportInformation(

      passportNumber:
      passportNumber ??
          this.passportNumber,

      passportBookNumber:
      passportBookNumber ??
          this.passportBookNumber,

      hasPassportBookNumber:
      hasPassportBookNumber ??
          this.hasPassportBookNumber,

      issuingCountry:
      issuingCountry ??
          this.issuingCountry,

      issuingCity:
      issuingCity ??
          this.issuingCity,

      issuingState:
      issuingState ??
          this.issuingState,

      issueDate:
      issueDate ??
          this.issueDate,

      expirationDate:
      expirationDate ??
          this.expirationDate,

      hasLostPassport:
      hasLostPassport ??
          this.hasLostPassport,

      lostPassportNumber:
      lostPassportNumber ??
          this.lostPassportNumber,

      lostPassportCountry:
      lostPassportCountry ??
          this.lostPassportCountry,

      explanation:
      explanation ??
          this.explanation,

    );

  }

}