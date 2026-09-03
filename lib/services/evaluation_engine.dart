import '../models/evaluation_question.dart';
import '../models/evaluation_result.dart';
import '../models/evaluation_rule.dart';

class EvaluationEngine {

  EvaluationEngine();

  //----------------------------------------------------------
  // VARIABLES
  //----------------------------------------------------------

  final List<String> _strengths = [];

  final List<String> _weaknesses = [];

  final List<String> _recommendations = [];

  final Map<String, int> _categoryScores = {};

  final Map<String, int> _categoryMaxScores = {};

  int _totalScore = 0;

  int _maxScore = 0;

  //----------------------------------------------------------
  // MÉTODO PRINCIPAL
  //----------------------------------------------------------

  EvaluationResult analyze({

    required List<EvaluationQuestion> questions,

    required Map<String, dynamic> answers,

  }) {

    _reset();

    for (final question in questions) {

      if (!_shouldEvaluate(question, answers)) {
        continue;
      }

      _evaluateQuestion(
        question,
        answers,
      );

    }

    return _buildResult();

  }

  //----------------------------------------------------------
  // RESET
  //----------------------------------------------------------

  void _reset() {

    _strengths.clear();

    _weaknesses.clear();

    _recommendations.clear();

    _categoryScores.clear();

    _categoryMaxScores.clear();

    _totalScore = 0;

    _maxScore = 0;

  }

  //----------------------------------------------------------
  // DEPENDENCIAS
  //----------------------------------------------------------

  bool _shouldEvaluate(
      EvaluationQuestion question,
      Map<String, dynamic> answers,
      ) {
    if (question.dependsOn == null ||
        question.dependsOn!.isEmpty) {
      return true;
    }

    if (!answers.containsKey(question.dependsOn)) {
      return false;
    }

    final answer = answers[question.dependsOn];

    // Si no hay valores configurados, la dependencia no restringe.
    if (question.dependsValues.isEmpty) {
      return true;
    }

    // Respuesta de selección múltiple.
    if (answer is List) {
      return answer.any(
            (item) => question.dependsValues.contains(
          item.toString(),
        ),
      );
    }

    // Respuesta simple.
    return question.dependsValues.contains(
      answer.toString(),
    );
  }
//----------------------------------------------------------
// BUSCAR REGLA
//----------------------------------------------------------

  EvaluationRule? _findRule(
      EvaluationQuestion question,
      dynamic answer,
      ) {

    if (question.rules.isEmpty) {
      return null;
    }

    //--------------------------------------------------
    // RESPUESTAS POR OPCIÓN
    //--------------------------------------------------

    if (answer is String) {

      for (final rule in question.rules) {

        if (rule.value == answer) {
          return rule;
        }

      }

    }

    //--------------------------------------------------
    // RESPUESTAS NUMÉRICAS
    //--------------------------------------------------

    final number = num.tryParse(
      answer.toString(),
    );

    if (number != null) {

      for (final rule in question.rules) {

        if (rule.from == null ||
            rule.to == null) {
          continue;
        }

        if (number >= rule.from! &&
            number <= rule.to!) {

          return rule;

        }

      }

    }

    //--------------------------------------------------
    // MULTISELECT
    //--------------------------------------------------

    if (answer is List) {

      for (final item in answer) {

        for (final rule in question.rules) {

          if (rule.value == item.toString()) {

            return rule;

          }

        }

      }

    }

    return null;

  }

  //----------------------------------------------------------
  // CALCULAR PUNTOS
  //----------------------------------------------------------

  int _calculatePoints(
      EvaluationQuestion question,
      dynamic answer,
      ) {

    final rule = _findRule(
      question,
      answer,
    );

    if (rule == null) {
      return 0;
    }

    return rule.points;

  }

//----------------------------------------------------------
// EVALUAR PREGUNTA
//----------------------------------------------------------

  void _evaluateQuestion(

      EvaluationQuestion question,

      Map<String, dynamic> answers,

      ) {

    if (!answers.containsKey(question.questionKey)) {
      return;
    }

    final answer = answers[question.questionKey];

    final rule = _findRule(
      question,
      answer,
    );

    if (rule == null) {
      return;
    }

    //--------------------------------------------------
    // ACUMULAR PUNTAJE TOTAL
    //--------------------------------------------------

    _totalScore += rule.points;

    //--------------------------------------------------
    // ACUMULAR PUNTAJE POR CATEGORÍA
    //--------------------------------------------------

    _categoryScores.update(

      question.category,

          (value) => value + rule.points,

      ifAbsent: () => rule.points,

    );

    //--------------------------------------------------
    // PUNTAJE MÁXIMO
    //--------------------------------------------------

    int maxCategoryPoints = 0;

    for (final r in question.rules) {

      if (r.points > maxCategoryPoints) {
        maxCategoryPoints = r.points;
      }

    }

    _maxScore += maxCategoryPoints;

    _categoryMaxScores.update(

      question.category,

          (value) => value + maxCategoryPoints,

      ifAbsent: () => maxCategoryPoints,

    );

    //--------------------------------------------------
    // CLASIFICACIÓN
    //--------------------------------------------------

    switch (rule.classification) {

      case "Fortaleza":

        if (rule.strengthMessage.isNotEmpty) {

          _strengths.add(
            rule.strengthMessage,
          );

        }

        break;

      case "Debilidad":

        if (rule.weaknessMessage.isNotEmpty) {

          _weaknesses.add(
            rule.weaknessMessage,
          );

        }

        if (rule.recommendationMessage.isNotEmpty) {

          _recommendations.add(
            rule.recommendationMessage,
          );

        }

        break;

      default:

        break;

    }

  }

//----------------------------------------------------------
// CONSTRUIR RESULTADO
//----------------------------------------------------------

  EvaluationResult _buildResult() {

    double approvalPercentage = 0;

    if (_maxScore > 0) {

      approvalPercentage =
          (_totalScore / _maxScore) * 100;

    }

    String profileLevel;

    if (approvalPercentage >= 90) {

      profileLevel = "Perfil Muy Fuerte";

    } else if (approvalPercentage >= 80) {

      profileLevel = "Perfil Fuerte";

    } else if (approvalPercentage >= 70) {

      profileLevel = "Perfil Bueno";

    } else if (approvalPercentage >= 60) {

      profileLevel = "Perfil Moderado";

    } else {

      profileLevel = "Perfil Débil";

    }

    String riskLevel;

    if (approvalPercentage >= 90) {

      riskLevel = "Muy Bajo";

    } else if (approvalPercentage >= 80) {

      riskLevel = "Bajo";

    } else if (approvalPercentage >= 70) {

      riskLevel = "Moderado";

    } else if (approvalPercentage >= 60) {

      riskLevel = "Alto";

    } else {

      riskLevel = "Muy Alto";

    }

    String recommendation;

    if (_recommendations.isEmpty) {

      recommendation =
      "La evaluación preliminar ha finalizado. Este resultado es una orientación inicial basada en las respuestas proporcionadas. Para obtener un análisis más completo de tu perfil, puedes continuar con la evaluación completa.";

    } else {

      recommendation = _recommendations.join("\n\n");

    }

    return EvaluationResult(

      profileLevel: profileLevel,

      riskLevel: riskLevel,

      totalScore: _totalScore,

      maxScore: _maxScore,

      approvalPercentage: approvalPercentage,

      categoryScores: _categoryScores,

      categoryMaxScores: _categoryMaxScores,

      strengths: List<String>.from(
        _strengths,
      ),

      weaknesses: List<String>.from(
        _weaknesses,
      ),

      recommendations: List<String>.from(
        _recommendations,
      ),

      visaAssistRecommendation:
      recommendation,

      legalMessage:
      "Esta evaluación es únicamente una orientación. La decisión final corresponde exclusivamente al Oficial Consular.",

    );

  }

}