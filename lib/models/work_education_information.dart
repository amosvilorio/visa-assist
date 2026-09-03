class WorkEducationInformation {
  // EMPLEO ACTUAL
  final String occupation;
  final String employerName;
  final String streetAddress;
  final String city;
  final String stateProvince;
  final String postalCode;
  final String country;
  final String phoneNumber;
  final DateTime? startDate;
  final String monthlySalary;
  final String duties;

  // EMPLEO ANTERIOR
  final bool hasPreviousEmployment;
  final String previousEmployer;
  final String previousOccupation;

  // EDUCACIÓN
  final String highestEducationLevel;
  final String institutionName;
  final String courseOfStudy;

  const WorkEducationInformation({
    this.occupation = '',
    this.employerName = '',
    this.streetAddress = '',
    this.city = '',
    this.stateProvince = '',
    this.postalCode = '',
    this.country = '',
    this.phoneNumber = '',
    this.startDate,
    this.monthlySalary = '',
    this.duties = '',
    this.hasPreviousEmployment = false,
    this.previousEmployer = '',
    this.previousOccupation = '',
    this.highestEducationLevel = '',
    this.institutionName = '',
    this.courseOfStudy = '',
  });

  WorkEducationInformation copyWith({
    String? occupation,
    String? employerName,
    String? streetAddress,
    String? city,
    String? stateProvince,
    String? postalCode,
    String? country,
    String? phoneNumber,
    DateTime? startDate,
    String? monthlySalary,
    String? duties,
    bool? hasPreviousEmployment,
    String? previousEmployer,
    String? previousOccupation,
    String? highestEducationLevel,
    String? institutionName,
    String? courseOfStudy,
  }) {
    return WorkEducationInformation(
      occupation: occupation ?? this.occupation,
      employerName: employerName ?? this.employerName,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      stateProvince: stateProvince ?? this.stateProvince,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      startDate: startDate ?? this.startDate,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      duties: duties ?? this.duties,
      hasPreviousEmployment:
      hasPreviousEmployment ?? this.hasPreviousEmployment,
      previousEmployer:
      previousEmployer ?? this.previousEmployer,
      previousOccupation:
      previousOccupation ?? this.previousOccupation,
      highestEducationLevel:
      highestEducationLevel ?? this.highestEducationLevel,
      institutionName:
      institutionName ?? this.institutionName,
      courseOfStudy:
      courseOfStudy ?? this.courseOfStudy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "occupation": occupation,
      "employerName": employerName,
      "streetAddress": streetAddress,
      "city": city,
      "stateProvince": stateProvince,
      "postalCode": postalCode,
      "country": country,
      "phoneNumber": phoneNumber,
      "startDate": startDate?.toIso8601String(),
      "monthlySalary": monthlySalary,
      "duties": duties,
      "hasPreviousEmployment": hasPreviousEmployment,
      "previousEmployer": previousEmployer,
      "previousOccupation": previousOccupation,
      "highestEducationLevel": highestEducationLevel,
      "institutionName": institutionName,
      "courseOfStudy": courseOfStudy,
    };
  }

  factory WorkEducationInformation.fromMap(
      Map<String, dynamic> map) {
    return WorkEducationInformation(
      occupation: map["occupation"] ?? "",
      employerName: map["employerName"] ?? "",
      streetAddress: map["streetAddress"] ?? "",
      city: map["city"] ?? "",
      stateProvince: map["stateProvince"] ?? "",
      postalCode: map["postalCode"] ?? "",
      country: map["country"] ?? "",
      phoneNumber: map["phoneNumber"] ?? "",
      startDate: map["startDate"] != null
          ? DateTime.parse(map["startDate"])
          : null,
      monthlySalary: map["monthlySalary"] ?? "",
      duties: map["duties"] ?? "",
      hasPreviousEmployment:
      map["hasPreviousEmployment"] ?? false,
      previousEmployer:
      map["previousEmployer"] ?? "",
      previousOccupation:
      map["previousOccupation"] ?? "",
      highestEducationLevel:
      map["highestEducationLevel"] ?? "",
      institutionName:
      map["institutionName"] ?? "",
      courseOfStudy:
      map["courseOfStudy"] ?? "",
    );
  }
}