class FamilyInformation {
  final String fatherSurname;
  final String fatherGivenNames;
  final DateTime? fatherDateOfBirth;
  final bool fatherInUs;
  final String fatherStatus;

  final String motherSurname;
  final String motherGivenNames;
  final DateTime? motherDateOfBirth;
  final bool motherInUs;
  final String motherStatus;

  final bool hasImmediateRelatives;
  final String immediateRelativeName;
  final String immediateRelativeRelationship;
  final String immediateRelativeStatus;

  final bool hasOtherRelatives;
  final String otherRelativeDescription;

  const FamilyInformation({
    this.fatherSurname = '',
    this.fatherGivenNames = '',
    this.fatherDateOfBirth,
    this.fatherInUs = false,
    this.fatherStatus = '',
    this.motherSurname = '',
    this.motherGivenNames = '',
    this.motherDateOfBirth,
    this.motherInUs = false,
    this.motherStatus = '',
    this.hasImmediateRelatives = false,
    this.immediateRelativeName = '',
    this.immediateRelativeRelationship = '',
    this.immediateRelativeStatus = '',
    this.hasOtherRelatives = false,
    this.otherRelativeDescription = '',
  });

  FamilyInformation copyWith({
    String? fatherSurname,
    String? fatherGivenNames,
    DateTime? fatherDateOfBirth,
    bool? fatherInUs,
    String? fatherStatus,
    String? motherSurname,
    String? motherGivenNames,
    DateTime? motherDateOfBirth,
    bool? motherInUs,
    String? motherStatus,
    bool? hasImmediateRelatives,
    String? immediateRelativeName,
    String? immediateRelativeRelationship,
    String? immediateRelativeStatus,
    bool? hasOtherRelatives,
    String? otherRelativeDescription,
  }) {
    return FamilyInformation(
      fatherSurname:
      fatherSurname ?? this.fatherSurname,
      fatherGivenNames:
      fatherGivenNames ?? this.fatherGivenNames,
      fatherDateOfBirth:
      fatherDateOfBirth ?? this.fatherDateOfBirth,
      fatherInUs:
      fatherInUs ?? this.fatherInUs,
      fatherStatus:
      fatherStatus ?? this.fatherStatus,
      motherSurname:
      motherSurname ?? this.motherSurname,
      motherGivenNames:
      motherGivenNames ?? this.motherGivenNames,
      motherDateOfBirth:
      motherDateOfBirth ?? this.motherDateOfBirth,
      motherInUs:
      motherInUs ?? this.motherInUs,
      motherStatus:
      motherStatus ?? this.motherStatus,
      hasImmediateRelatives:
      hasImmediateRelatives ??
          this.hasImmediateRelatives,
      immediateRelativeName:
      immediateRelativeName ??
          this.immediateRelativeName,
      immediateRelativeRelationship:
      immediateRelativeRelationship ??
          this.immediateRelativeRelationship,
      immediateRelativeStatus:
      immediateRelativeStatus ??
          this.immediateRelativeStatus,
      hasOtherRelatives:
      hasOtherRelatives ??
          this.hasOtherRelatives,
      otherRelativeDescription:
      otherRelativeDescription ??
          this.otherRelativeDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fatherSurname": fatherSurname,
      "fatherGivenNames": fatherGivenNames,
      "fatherDateOfBirth":
      fatherDateOfBirth?.toIso8601String(),
      "fatherInUs": fatherInUs,
      "fatherStatus": fatherStatus,
      "motherSurname": motherSurname,
      "motherGivenNames": motherGivenNames,
      "motherDateOfBirth":
      motherDateOfBirth?.toIso8601String(),
      "motherInUs": motherInUs,
      "motherStatus": motherStatus,
      "hasImmediateRelatives":
      hasImmediateRelatives,
      "immediateRelativeName":
      immediateRelativeName,
      "immediateRelativeRelationship":
      immediateRelativeRelationship,
      "immediateRelativeStatus":
      immediateRelativeStatus,
      "hasOtherRelatives":
      hasOtherRelatives,
      "otherRelativeDescription":
      otherRelativeDescription,
    };
  }

  factory FamilyInformation.fromMap(
      Map<String, dynamic> map) {
    return FamilyInformation(
      fatherSurname:
      map["fatherSurname"] ?? "",
      fatherGivenNames:
      map["fatherGivenNames"] ?? "",
      fatherDateOfBirth:
      map["fatherDateOfBirth"] != null
          ? DateTime.parse(
          map["fatherDateOfBirth"])
          : null,
      fatherInUs:
      map["fatherInUs"] ?? false,
      fatherStatus:
      map["fatherStatus"] ?? "",
      motherSurname:
      map["motherSurname"] ?? "",
      motherGivenNames:
      map["motherGivenNames"] ?? "",
      motherDateOfBirth:
      map["motherDateOfBirth"] != null
          ? DateTime.parse(
          map["motherDateOfBirth"])
          : null,
      motherInUs:
      map["motherInUs"] ?? false,
      motherStatus:
      map["motherStatus"] ?? "",
      hasImmediateRelatives:
      map["hasImmediateRelatives"] ??
          false,
      immediateRelativeName:
      map["immediateRelativeName"] ?? "",
      immediateRelativeRelationship:
      map["immediateRelativeRelationship"] ??
          "",
      immediateRelativeStatus:
      map["immediateRelativeStatus"] ??
          "",
      hasOtherRelatives:
      map["hasOtherRelatives"] ??
          false,
      otherRelativeDescription:
      map["otherRelativeDescription"] ??
          "",
    );
  }
}