class PersonalInformation {

  final bool hasOtherNames;

  final String otherNames;

  final String maritalStatus;

  final String cityOfBirth;

  final String stateOfBirth;

  final String countryOfBirth;

  final String nationality;

  final bool hasOtherNationality;

  final String otherNationality;

  final bool isPermanentResidentOtherCountry;

  final String permanentResidentCountry;

  final String nationalIdNumber;

  const PersonalInformation({

    required this.hasOtherNames,

    required this.otherNames,

    required this.maritalStatus,

    required this.cityOfBirth,

    required this.stateOfBirth,

    required this.countryOfBirth,

    required this.nationality,

    required this.hasOtherNationality,

    required this.otherNationality,

    required this.isPermanentResidentOtherCountry,

    required this.permanentResidentCountry,

    required this.nationalIdNumber,

  });

  factory PersonalInformation.fromMap(
      Map<String, dynamic> map,
      ) {

    return PersonalInformation(

      hasOtherNames:
      map["hasOtherNames"] ?? false,

      otherNames:
      map["otherNames"] ?? "",

      maritalStatus:
      map["maritalStatus"] ?? "",

      cityOfBirth:
      map["cityOfBirth"] ?? "",

      stateOfBirth:
      map["stateOfBirth"] ?? "",

      countryOfBirth:
      map["countryOfBirth"] ?? "",

      nationality:
      map["nationality"] ?? "",

      hasOtherNationality:
      map["hasOtherNationality"] ?? false,

      otherNationality:
      map["otherNationality"] ?? "",

      isPermanentResidentOtherCountry:
      map["isPermanentResidentOtherCountry"] ?? false,

      permanentResidentCountry:
      map["permanentResidentCountry"] ?? "",

      nationalIdNumber:
      map["nationalIdNumber"] ?? "",

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "hasOtherNames": hasOtherNames,

      "otherNames": otherNames,

      "maritalStatus": maritalStatus,

      "cityOfBirth": cityOfBirth,

      "stateOfBirth": stateOfBirth,

      "countryOfBirth": countryOfBirth,

      "nationality": nationality,

      "hasOtherNationality": hasOtherNationality,

      "otherNationality": otherNationality,

      "isPermanentResidentOtherCountry":
      isPermanentResidentOtherCountry,

      "permanentResidentCountry":
      permanentResidentCountry,

      "nationalIdNumber":
      nationalIdNumber,

    };

  }

  PersonalInformation copyWith({

    bool? hasOtherNames,

    String? otherNames,

    String? maritalStatus,

    String? cityOfBirth,

    String? stateOfBirth,

    String? countryOfBirth,

    String? nationality,

    bool? hasOtherNationality,

    String? otherNationality,

    bool? isPermanentResidentOtherCountry,

    String? permanentResidentCountry,

    String? nationalIdNumber,

  }) {

    return PersonalInformation(

      hasOtherNames:
      hasOtherNames ??
          this.hasOtherNames,

      otherNames:
      otherNames ??
          this.otherNames,

      maritalStatus:
      maritalStatus ??
          this.maritalStatus,

      cityOfBirth:
      cityOfBirth ??
          this.cityOfBirth,

      stateOfBirth:
      stateOfBirth ??
          this.stateOfBirth,

      countryOfBirth:
      countryOfBirth ??
          this.countryOfBirth,

      nationality:
      nationality ??
          this.nationality,

      hasOtherNationality:
      hasOtherNationality ??
          this.hasOtherNationality,

      otherNationality:
      otherNationality ??
          this.otherNationality,

      isPermanentResidentOtherCountry:
      isPermanentResidentOtherCountry ??
          this.isPermanentResidentOtherCountry,

      permanentResidentCountry:
      permanentResidentCountry ??
          this.permanentResidentCountry,

      nationalIdNumber:
      nationalIdNumber ??
          this.nationalIdNumber,

    );

  }

}