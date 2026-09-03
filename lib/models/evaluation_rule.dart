class EvaluationRule {
  final String? value;

  final double? from;

  final double? to;

  final int points;

  final String classification;

  final String strengthMessage;

  final String weaknessMessage;

  final String recommendationMessage;

  const EvaluationRule({
    this.value,
    this.from,
    this.to,
    required this.points,
    required this.classification,
    required this.strengthMessage,
    required this.weaknessMessage,
    required this.recommendationMessage,
  });

  factory EvaluationRule.fromMap(
      Map<String, dynamic> map,
      ) {
    return EvaluationRule(
      value: map["value"],

      from: map["from"] != null
          ? (map["from"] as num).toDouble()
          : null,

      to: map["to"] != null
          ? (map["to"] as num).toDouble()
          : null,

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
      "value": value,
      "from": from,
      "to": to,
      "points": points,
      "classification": classification,
      "strengthMessage": strengthMessage,
      "weaknessMessage": weaknessMessage,
      "recommendationMessage":
      recommendationMessage,
    };
  }
}