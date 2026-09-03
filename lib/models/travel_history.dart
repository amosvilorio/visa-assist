class TravelHistory {
  final bool hasTraveledBefore;

  final String countriesVisited;

  final String travelPurpose;

  final bool hadAmericanVisa;

  final bool visaDenied;

  final bool deported;

  const TravelHistory({
    this.hasTraveledBefore = false,
    this.countriesVisited = '',
    this.travelPurpose = '',
    this.hadAmericanVisa = false,
    this.visaDenied = false,
    this.deported = false,
  });


  TravelHistory copyWith({

    bool? hasTraveledBefore,

    String? countriesVisited,

    String? travelPurpose,

    bool? hadAmericanVisa,

    bool? visaDenied,

    bool? deported,

  }) {

    return TravelHistory(

      hasTraveledBefore:
      hasTraveledBefore ?? this.hasTraveledBefore,

      countriesVisited:
      countriesVisited ?? this.countriesVisited,

      travelPurpose:
      travelPurpose ?? this.travelPurpose,

      hadAmericanVisa:
      hadAmericanVisa ?? this.hadAmericanVisa,

      visaDenied:
      visaDenied ?? this.visaDenied,

      deported:
      deported ?? this.deported,

    );
  }


  Map<String, dynamic> toMap() {

    return {

      "hasTraveledBefore":
      hasTraveledBefore,

      "countriesVisited":
      countriesVisited,

      "travelPurpose":
      travelPurpose,

      "hadAmericanVisa":
      hadAmericanVisa,

      "visaDenied":
      visaDenied,

      "deported":
      deported,

    };
  }


  factory TravelHistory.fromMap(
      Map<String, dynamic> map) {

    return TravelHistory(

      hasTraveledBefore:
      map["hasTraveledBefore"] ?? false,

      countriesVisited:
      map["countriesVisited"] ?? "",

      travelPurpose:
      map["travelPurpose"] ?? "",

      hadAmericanVisa:
      map["hadAmericanVisa"] ?? false,

      visaDenied:
      map["visaDenied"] ?? false,

      deported:
      map["deported"] ?? false,

    );
  }
}