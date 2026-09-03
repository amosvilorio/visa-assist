class TravelCompanion {
  final String fullName;
  final String relationship;
  final bool travelingWithApplicant;

  const TravelCompanion({
    required this.fullName,
    required this.relationship,
    required this.travelingWithApplicant,
  });

  TravelCompanion copyWith({
    String? fullName,
    String? relationship,
    bool? travelingWithApplicant,
  }) {
    return TravelCompanion(
      fullName: fullName ?? this.fullName,
      relationship: relationship ?? this.relationship,
      travelingWithApplicant:
      travelingWithApplicant ?? this.travelingWithApplicant,
    );
  }

  factory TravelCompanion.fromMap(Map<String, dynamic> map) {
    return TravelCompanion(
      fullName: map['fullName'] ?? '',
      relationship: map['relationship'] ?? '',
      travelingWithApplicant:
      map['travelingWithApplicant'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'relationship': relationship,
      'travelingWithApplicant': travelingWithApplicant,
    };
  }
}