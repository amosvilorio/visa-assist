import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/evaluation_question.dart';

class QuestionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _questions =>
      _db.collection('evaluation_questions');

  Future<List<EvaluationQuestion>> getQuestions({
    required String countryCode,
    required String visaType,
    required bool isPremium,
  }) async {
    final snapshot = await _questions
        .where('countryCode', isEqualTo: countryCode)
        .where('visaType', isEqualTo: visaType)
        .where('isPremium', isEqualTo: isPremium)
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
      return EvaluationQuestion.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<EvaluationQuestion?> getQuestionByOrder({
    required String countryCode,
    required String visaType,
    required bool isPremium,
    required int order,
  }) async {
    final snapshot = await _questions
        .where('countryCode', isEqualTo: countryCode)
        .where('visaType', isEqualTo: visaType)
        .where('isPremium', isEqualTo: isPremium)
        .where('order', isEqualTo: order)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return EvaluationQuestion.fromMap(
      snapshot.docs.first.data() as Map<String, dynamic>,
      snapshot.docs.first.id,
    );
  }

  Stream<List<EvaluationQuestion>> watchQuestions({
    required String countryCode,
    required String visaType,
    required bool isPremium,
  }) {
    return _questions
        .where('countryCode', isEqualTo: countryCode)
        .where('visaType', isEqualTo: visaType)
        .where('isPremium', isEqualTo: isPremium)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => EvaluationQuestion.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ),
      )
          .toList(),
    );
  }

  Stream<List<EvaluationQuestion>> watchAllQuestions() {
    return _questions
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => EvaluationQuestion.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ),
      )
          .toList(),
    );
  }

  Future<List<EvaluationQuestion>> getAllQuestions() async {

    final snapshot = await _questions
        .orderBy("order")
        .get();

    return snapshot.docs.map((doc) {

      return EvaluationQuestion.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );

    }).toList();

  }

  Future<List<EvaluationQuestion>> getQuestionsForEvaluation({
    required String countryCode,
    required String visaType,
  }) async {

    final snapshot = await _questions
        .where(
      'countryCode',
      isEqualTo: countryCode,
    )
        .where(
      'visaType',
      isEqualTo: visaType,
    )
        .orderBy('order')
        .get();

    final questions = snapshot.docs.map((doc) {

      return EvaluationQuestion.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );

    }).toList();

    questions.sort(
          (a, b) => a.order.compareTo(b.order),
    );

    return questions;
  }

  Future<void> createQuestion(
      EvaluationQuestion question,
      ) async {
    await _questions.add(
      question.toMap(),
    );
  }

  Future<void> updateQuestion(
      String id,
      EvaluationQuestion question,
      ) async {
    await _questions.doc(id).update(
      question.toMap(),
    );
  }

  Future<void> deleteQuestion(
      String id,
      ) async {
    await _questions.doc(id).delete();
  }
}