class TravelInformation {

  final String purposeOfTrip;

  final DateTime? estimatedArrivalDate;

  final String lengthOfStay;

  final bool knowsWhereWillStay;

  final String stayAddress;

  final String personPayingTrip;

  final String payerRelationship;

  const TravelInformation({

    required this.purposeOfTrip,

    required this.estimatedArrivalDate,

    required this.lengthOfStay,

    required this.knowsWhereWillStay,

    required this.stayAddress,

    required this.personPayingTrip,

    required this.payerRelationship,

  });

  factory TravelInformation.fromMap(
      Map<String, dynamic> map,
      ) {

    return TravelInformation(

      purposeOfTrip:
      map["purposeOfTrip"] ?? "",

      estimatedArrivalDate:
      map["estimatedArrivalDate"] != null
          ? DateTime.parse(
        map["estimatedArrivalDate"],
      )
          : null,

      lengthOfStay:
      map["lengthOfStay"] ?? "",

      knowsWhereWillStay:
      map["knowsWhereWillStay"] ?? false,

      stayAddress:
      map["stayAddress"] ?? "",

      personPayingTrip:
      map["personPayingTrip"] ?? "",

      payerRelationship:
      map["payerRelationship"] ?? "",

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "purposeOfTrip":
      purposeOfTrip,

      "estimatedArrivalDate":
      estimatedArrivalDate?.toIso8601String(),

      "lengthOfStay":
      lengthOfStay,

      "knowsWhereWillStay":
      knowsWhereWillStay,

      "stayAddress":
      stayAddress,

      "personPayingTrip":
      personPayingTrip,

      "payerRelationship":
      payerRelationship,

    };

  }

  TravelInformation copyWith({

    String? purposeOfTrip,

    DateTime? estimatedArrivalDate,

    String? lengthOfStay,

    bool? knowsWhereWillStay,

    String? stayAddress,

    String? personPayingTrip,

    String? payerRelationship,

  }) {

    return TravelInformation(

      purposeOfTrip:
      purposeOfTrip ??
          this.purposeOfTrip,

      estimatedArrivalDate:
      estimatedArrivalDate ??
          this.estimatedArrivalDate,

      lengthOfStay:
      lengthOfStay ??
          this.lengthOfStay,

      knowsWhereWillStay:
      knowsWhereWillStay ??
          this.knowsWhereWillStay,

      stayAddress:
      stayAddress ??
          this.stayAddress,

      personPayingTrip:
      personPayingTrip ??
          this.personPayingTrip,

      payerRelationship:
      payerRelationship ??
          this.payerRelationship,

    );

  }

}