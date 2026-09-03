class EvaluationResult {
  final String profileLevel;

  final String riskLevel;

  final int totalScore;

  final int maxScore;

  final double approvalPercentage;

  final Map<String, int> categoryScores;

  final Map<String, int> categoryMaxScores;

  final List<String> strengths;

  final List<String> weaknesses;

  final List<String> recommendations;

  final String visaAssistRecommendation;

  final String legalMessage;

  const EvaluationResult({
    required this.profileLevel,
    required this.riskLevel,
    required this.totalScore,
    required this.maxScore,
    required this.approvalPercentage,
    required this.categoryScores,
    required this.categoryMaxScores,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.visaAssistRecommendation,
    required this.legalMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      "profileLevel": profileLevel,
      "riskLevel": riskLevel,
      "totalScore": totalScore,
      "maxScore": maxScore,
      "approvalPercentage": approvalPercentage,
      "categoryScores": categoryScores,
      "categoryMaxScores": categoryMaxScores,
      "strengths": strengths,
      "weaknesses": weaknesses,
      "recommendations": recommendations,
      "visaAssistRecommendation":
      visaAssistRecommendation,
      "legalMessage": legalMessage,
    };
  }

  factory EvaluationResult.fromMap(
      Map<String, dynamic> map) {
    return EvaluationResult(
      profileLevel:
      map["profileLevel"] ?? "",
      riskLevel:
      map["riskLevel"] ?? "",
      totalScore:
      map["totalScore"] ?? 0,
      maxScore:
      map["maxScore"] ?? 0,
      approvalPercentage:
      (map["approvalPercentage"] ?? 0)
          .toDouble(),
      categoryScores:
      Map<String, int>.from(
          map["categoryScores"] ?? {}),
      categoryMaxScores:
      Map<String, int>.from(
          map["categoryMaxScores"] ?? {}),
      strengths:
      List<String>.from(
          map["strengths"] ?? []),
      weaknesses:
      List<String>.from(
          map["weaknesses"] ?? []),
      recommendations:
      List<String>.from(
          map["recommendations"] ?? []),
      visaAssistRecommendation:
      map["visaAssistRecommendation"] ??
          "",
      legalMessage:
      map["legalMessage"] ?? "",
    );
  }
}