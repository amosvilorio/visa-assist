class Applicant {
  final String firstName;
  final String lastName;

  final DateTime birthDate;

  final String gender;

  final String applicantType;

  final String relationship;

  final bool isMinor;

  const Applicant({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.applicantType,
    required this.relationship,
    required this.isMinor,
  });

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      birthDate: DateTime.parse(map["birthDate"]),
      gender: map["gender"] ?? "",
      applicantType: map["applicantType"] ?? "",
      relationship: map["relationship"] ?? "",
      isMinor: map["isMinor"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "birthDate": birthDate.toIso8601String(),
      "gender": gender,
      "applicantType": applicantType,
      "relationship": relationship,
      "isMinor": isMinor,
    };
  }

  Applicant copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? applicantType,
    String? relationship,
    bool? isMinor,
  }) {
    return Applicant(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      applicantType: applicantType ?? this.applicantType,
      relationship: relationship ?? this.relationship,
      isMinor: isMinor ?? this.isMinor,
    );
  }
}