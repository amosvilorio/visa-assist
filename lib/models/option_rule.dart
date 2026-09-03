import 'classification_rule.dart';

class OptionRule {

  final String value;

  final ClassificationRule rule;

  const OptionRule({
    required this.value,
    required this.rule,
  });

  factory OptionRule.fromMap(
      Map<String, dynamic> map,
      ) {

    return OptionRule(

      value: map["value"] ?? "",

      rule: ClassificationRule.fromMap(
        Map<String, dynamic>.from(
          map["rule"] ?? {},
        ),
      ),

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "value": value,

      "rule": rule.toMap(),

    };

  }

}