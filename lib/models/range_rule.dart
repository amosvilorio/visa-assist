import 'classification_rule.dart';

class RangeRule {

  final double from;

  final double to;

  final ClassificationRule rule;

  const RangeRule({
    required this.from,
    required this.to,
    required this.rule,
  });

  factory RangeRule.fromMap(
      Map<String, dynamic> map,
      ) {

    return RangeRule(

      from: (map["from"] ?? 0).toDouble(),

      to: (map["to"] ?? 0).toDouble(),

      rule: ClassificationRule.fromMap(
        Map<String, dynamic>.from(
          map["rule"] ?? {},
        ),
      ),

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "from": from,

      "to": to,

      "rule": rule.toMap(),

    };

  }

  bool contains(num value) {

    return value >= from && value <= to;

  }

}