import 'package:cloud_firestore/cloud_firestore.dart';

import 'evaluation_rule.dart';

class EvaluationQuestion {

  //----------------------------------------------------------
  // INFORMACIÓN GENERAL
  //----------------------------------------------------------

  final String id;

  final String countryCode;

  final String visaType;

  final bool isPremium;

  final int order;

  final String category;

  final String question;

  final String questionKey;

  //----------------------------------------------------------
  // RESPUESTA
  //----------------------------------------------------------

  /// text
  /// number
  /// date
  /// dropdown
  /// yes_no
  /// checkbox
  /// multiple

  final String responseType;

  final List<String> options;

  final bool required;

  //----------------------------------------------------------
  // EVALUACIÓN
  //----------------------------------------------------------

  final bool evaluationEnabled;

  /// none
  /// option
  /// range
  /// multiple
  /// quantity

  final String evaluationType;

  final List<EvaluationRule> rules;

  //----------------------------------------------------------
  // DEPENDENCIAS
  //----------------------------------------------------------

  final String? dependsOn;

  final List<String> dependsValues;

  //----------------------------------------------------------
  // FECHA
  //----------------------------------------------------------

  final Timestamp createdAt;

//----------------------------------------------------------
// CONSTRUCTOR
//----------------------------------------------------------

  const EvaluationQuestion({

    required this.id,

    required this.countryCode,

    required this.visaType,

    required this.isPremium,

    required this.order,

    required this.category,

    required this.question,

    required this.questionKey,

    required this.responseType,

    required this.options,

    required this.required,

    required this.evaluationEnabled,

    required this.evaluationType,

    required this.rules,

    this.dependsOn,

    this.dependsValues = const [],

    required this.createdAt,

  });

  //----------------------------------------------------------
  // FROM MAP
  //----------------------------------------------------------

  factory EvaluationQuestion.fromMap(

      Map<String, dynamic> map,

      String id,

      ) {

    return EvaluationQuestion(

      id: id,

      countryCode: map["countryCode"] ?? "",

      visaType: map["visaType"] ?? "",

      isPremium: map["isPremium"] ?? false,

      order: map["order"] ?? 0,

      category: map["category"] ?? "",

      question: map["question"] ?? "",

      questionKey: map["questionKey"] ?? "",

      responseType:
      map["responseType"] ?? "text",

      options: List<String>.from(
        map["options"] ?? [],
      ),

      required:
      map["required"] ?? true,

      evaluationEnabled:
      map["evaluationEnabled"] ?? false,

      evaluationType:
      map["evaluationType"] ?? "none",

      rules: (map["rules"] as List? ?? [])

          .map(
            (e) => EvaluationRule.fromMap(
          Map<String, dynamic>.from(e),
        ),
      )

          .toList(),

      dependsOn: map["dependsOn"],

      dependsValues: List<String>.from(
        map["dependsValues"] ?? [],
      ),

      createdAt:
      map["createdAt"] ??
          Timestamp.now(),

    );

  }

//----------------------------------------------------------
// TO MAP
//----------------------------------------------------------

  Map<String, dynamic> toMap() {

    return {

      //------------------------------------------------------
      // INFORMACIÓN GENERAL
      //------------------------------------------------------

      "countryCode": countryCode,

      "visaType": visaType,

      "isPremium": isPremium,

      "order": order,

      "category": category,

      "question": question,

      "questionKey": questionKey,

      //------------------------------------------------------
      // RESPUESTA
      //------------------------------------------------------

      "responseType": responseType,

      "options": options,

      "required": required,

      //------------------------------------------------------
      // EVALUACIÓN
      //------------------------------------------------------

      "evaluationEnabled": evaluationEnabled,

      "evaluationType": evaluationType,

      "rules": rules
          .map(
            (rule) => rule.toMap(),
      )
          .toList(),

      //------------------------------------------------------
      // DEPENDENCIAS
      //------------------------------------------------------

      "dependsOn": dependsOn,

      "dependsValues": dependsValues,

      //------------------------------------------------------
      // FECHA
      //------------------------------------------------------

      "createdAt": createdAt,

    };

  }

}