class ClassificationRule {
  final int points;

  final String classification;

  final String strengthMessage;

  final String weaknessMessage;

  final String recommendationMessage;

  const ClassificationRule({
    required this.points,
    required this.classification,
    required this.strengthMessage,
    required this.weaknessMessage,
    required this.recommendationMessage,
  });

  factory ClassificationRule.fromMap(
      Map<String, dynamic> map,
      ) {
    return ClassificationRule(
      points: map["points"] ?? 0,
      classification:
      map["classification"] ?? "Neutral",
      strengthMessage:
      map["strengthMessage"] ?? "",
      weaknessMessage:
      map["weaknessMessage"] ?? "",
      recommendationMessage:
      map["recommendationMessage"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "points": points,
      "classification": classification,
      "strengthMessage": strengthMessage,
      "weaknessMessage": weaknessMessage,
      "recommendationMessage":
      recommendationMessage,
    };
  }
}