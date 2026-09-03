class AddressInformation {

  final String streetAddress;

  final String apartmentNumber;

  final String city;

  final String stateProvince;

  final String postalCode;

  final String country;

  final String primaryPhone;

  final String emailAddress;

  const AddressInformation({

    required this.streetAddress,

    required this.apartmentNumber,

    required this.city,

    required this.stateProvince,

    required this.postalCode,

    required this.country,

    required this.primaryPhone,

    required this.emailAddress,

  });

  factory AddressInformation.fromMap(
      Map<String, dynamic> map,
      ) {

    return AddressInformation(

      streetAddress:
      map["streetAddress"] ?? "",

      apartmentNumber:
      map["apartmentNumber"] ?? "",

      city:
      map["city"] ?? "",

      stateProvince:
      map["stateProvince"] ?? "",

      postalCode:
      map["postalCode"] ?? "",

      country:
      map["country"] ?? "",

      primaryPhone:
      map["primaryPhone"] ?? "",

      emailAddress:
      map["emailAddress"] ?? "",

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "streetAddress":
      streetAddress,

      "apartmentNumber":
      apartmentNumber,

      "city":
      city,

      "stateProvince":
      stateProvince,

      "postalCode":
      postalCode,

      "country":
      country,

      "primaryPhone":
      primaryPhone,

      "emailAddress":
      emailAddress,

    };

  }

  AddressInformation copyWith({

    String? streetAddress,

    String? apartmentNumber,

    String? city,

    String? stateProvince,

    String? postalCode,

    String? country,

    String? primaryPhone,

    String? emailAddress,

  }) {

    return AddressInformation(

      streetAddress:
      streetAddress ??
          this.streetAddress,

      apartmentNumber:
      apartmentNumber ??
          this.apartmentNumber,

      city:
      city ??
          this.city,

      stateProvince:
      stateProvince ??
          this.stateProvince,

      postalCode:
      postalCode ??
          this.postalCode,

      country:
      country ??
          this.country,

      primaryPhone:
      primaryPhone ??
          this.primaryPhone,

      emailAddress:
      emailAddress ??
          this.emailAddress,

    );

  }

}