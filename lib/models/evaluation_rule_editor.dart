import 'package:flutter/material.dart';

import 'evaluation_rule.dart';

class EvaluationRuleEditor {

  final TextEditingController valueController;

  final TextEditingController fromController;

  final TextEditingController toController;

  final TextEditingController pointsController;

  final TextEditingController strengthController;

  final TextEditingController weaknessController;

  final TextEditingController recommendationController;

  String classification;

  EvaluationRuleEditor({

    String value = "",

    String from = "",

    String to = "",

    String points = "0",

    this.classification = "Neutral",

    String strength = "",

    String weakness = "",

    String recommendation = "",

  })  : valueController =
  TextEditingController(text: value),

        fromController =
        TextEditingController(text: from),

        toController =
        TextEditingController(text: to),

        pointsController =
        TextEditingController(text: points),

        strengthController =
        TextEditingController(text: strength),

        weaknessController =
        TextEditingController(text: weakness),

        recommendationController =
        TextEditingController(
          text: recommendation,
        );

  factory EvaluationRuleEditor.fromRule(
      EvaluationRule rule,
      ) {

    return EvaluationRuleEditor(

      value: rule.value ?? "",

      from: rule.from?.toString() ?? "",

      to: rule.to?.toString() ?? "",

      points: rule.points.toString(),

      classification:
      rule.classification,

      strength:
      rule.strengthMessage,

      weakness:
      rule.weaknessMessage,

      recommendation:
      rule.recommendationMessage,

    );

  }

  EvaluationRule toRule() {

    return EvaluationRule(

      value: valueController.text.trim().isEmpty
          ? null
          : valueController.text.trim(),

      from: fromController.text.trim().isEmpty
          ? null
          : double.tryParse(
        fromController.text.trim(),
      ),

      to: toController.text.trim().isEmpty
          ? null
          : double.tryParse(
        toController.text.trim(),
      ),

      points: int.tryParse(
        pointsController.text.trim(),
      ) ??
          0,

      classification: classification,

      strengthMessage:
      strengthController.text.trim(),

      weaknessMessage:
      weaknessController.text.trim(),

      recommendationMessage:
      recommendationController.text.trim(),

    );

  }

  void dispose() {

    valueController.dispose();

    fromController.dispose();

    toController.dispose();

    pointsController.dispose();

    strengthController.dispose();

    weaknessController.dispose();

    recommendationController.dispose();

  }

}