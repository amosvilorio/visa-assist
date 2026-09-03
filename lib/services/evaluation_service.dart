import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';
import '../models/evaluation.dart';

class EvaluationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _evaluations =>
      _db.collection('evaluations');

  //==================================================
  // CREAR EVALUACIÓN
  //==================================================

  Future<String> createEvaluation({
    required bool isForAnotherPerson,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String visaType,
  }) async {
    final user = _auth.currentUser!;

    final doc = _evaluations.doc();

    final evaluation = Evaluation(
      id: doc.id,
      userId: user.uid,
      isForAnotherPerson: isForAnotherPerson,
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      visaType: visaType,
      isPremium: false,
      premiumUnlocked: false,
      premiumPaid: false,
      currentBlock: 1,
      currentQuestion: 1,
      profileLevel: "Sin evaluar",
      status: "in_progress",
      answers: {},
      strengths: [],
      weaknesses: [],
      recommendations: [],
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      completedAt: null,
    );

    await doc.set(
      evaluation.toMap(),
    );

    return doc.id;
  }

  //==================================================
  // ACTUALIZAR RESPUESTA
  //==================================================

  Future<void> updateAnswer({
    required String evaluationId,
    required String questionId,
    required dynamic answer,
  }) async {
    await _evaluations.doc(evaluationId).update({
      "answers.$questionId": answer,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ACTUALIZAR BLOQUE
  //==================================================

  Future<void> updateCurrentBlock({
    required String evaluationId,
    required int currentBlock,
  }) async {
    await _evaluations.doc(evaluationId).update({
      "currentBlock": currentBlock,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ACTUALIZAR PREGUNTA
  //==================================================

  Future<void> updateCurrentQuestion({
    required String evaluationId,
    required int currentQuestion,
  }) async {
    await _evaluations.doc(evaluationId).update({
      "currentQuestion": currentQuestion,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // GUARDAR RESULTADO
  //==================================================

  Future<void> saveEvaluationResult({
    required String evaluationId,
    required Map<String, dynamic> result,
  }) async {
    await _evaluations.doc(evaluationId).update({
      ...result,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // DESBLOQUEAR PREMIUM
  //==================================================

  Future<void> unlockPremium(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "premiumUnlocked": true,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // MARCAR PREMIUM PAGADO
  //==================================================

  Future<void> markPremiumPaid(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "premiumPaid": true,
      "isPremium": true,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // FINALIZAR EVALUACIÓN
  //==================================================

  Future<void> finishEvaluation(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "status": "completed",
      "completedAt": Timestamp.now(),
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ENVIAR A PROCESAMIENTO
  //==================================================

  Future<void> submitForProcessing(
      String evaluationId,
      ) async {

    // Obtener la evaluación antes de cambiar el estado
    final evaluationDoc =
    await _evaluations.doc(evaluationId).get();

    if (!evaluationDoc.exists) {
      throw Exception(
        "La evaluación no existe.",
      );
    }

    final evaluationData =
    evaluationDoc.data() as Map<String, dynamic>;

    final userId =
        evaluationData["userId"]?.toString() ?? "";

    // Cambiar estado a pendiente de revisión
    await _evaluations.doc(evaluationId).update({
      "status": "pending_processing",
      "submittedAt": Timestamp.now(),
      "updatedAt": Timestamp.now(),
    });

    // Notificar a todos los administradores
    await NotificationService().notifyAdmins(
      title: "Nueva evaluación Premium",
      message:
      "Un cliente ha terminado su evaluación Premium y está lista para ser revisada.",
      type: "premium_evaluation_submitted",
      expedienteId: evaluationId,
      data: {
        "evaluationId": evaluationId,
        "userId": userId,
        "status": "pending_processing",
      },
    );
  }

  //==================================================
  // CANCELAR
  //==================================================

  Future<void> cancelEvaluation(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "status": "cancelled",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // MIS EVALUACIONES
  //==================================================

  Stream<QuerySnapshot> myEvaluations() {
    final user = _auth.currentUser!;

    return _evaluations
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .orderBy(
      "createdAt",
      descending: true,
    )
        .snapshots();
  }

  //==================================================
  // OBTENER UNA EVALUACIÓN
  //==================================================

  Future<DocumentSnapshot> getEvaluation(
      String evaluationId,
      ) {
    return _evaluations
        .doc(evaluationId)
        .get();
  }

  //==================================================
  // EVALUACIÓN EN CURSO
  //==================================================

  Future<DocumentSnapshot?> getEvaluationInProgress() async {
    final user = _auth.currentUser!;

    final result = await _evaluations
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .get();

    DocumentSnapshot? activeEvaluation;

    DateTime latestDate =
    DateTime.fromMillisecondsSinceEpoch(0);

    for (final doc in result.docs) {
      final data =
      doc.data() as Map<String, dynamic>;

      final status =
          data["status"] ?? "";

      if (status != "in_progress" &&
          status != "waiting_payment" &&
          status != "payment_pending") {
        continue;
      }

      final timestamp =
      data["updatedAt"] as Timestamp?;

      final updatedAt =
          timestamp?.toDate() ??
              DateTime.fromMillisecondsSinceEpoch(0);

      if (activeEvaluation == null ||
          updatedAt.isAfter(latestDate)) {
        activeEvaluation = doc;
        latestDate = updatedAt;
      }
    }

    return activeEvaluation;
  }

  //==================================================
  // 🔴 NUEVO:
  // ESCUCHAR EVALUACIONES EN TIEMPO REAL
  //==================================================

  Stream<QuerySnapshot> watchMyEvaluations() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _evaluations
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .snapshots();
  }

  //==================================================
  // ESPERANDO PAGO
  //==================================================

  Future<void> waitingPayment(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "status": "waiting_payment",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // REGISTRAR PAGO
  //==================================================

  Future<void> registerPayment({
    required String evaluationId,
    required String paymentMethod,
    required String paymentReference,
    required String paymentReceipt,
  }) async {
    await _evaluations.doc(evaluationId).update({
      "status": "payment_pending",
      "paymentMethod": paymentMethod,
      "paymentReference": paymentReference,
      "paymentReceipt": paymentReceipt,
      "paymentDate": Timestamp.now(),
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // APROBAR PAGO
  //==================================================

  Future<void> approvePayment({
    required String evaluationId,
    required String adminId,
  }) async {
    await _evaluations.doc(evaluationId).update({
      "status": "in_progress",
      "premiumUnlocked": true,
      "premiumPaid": true,
      "isPremium": true,
      "currentQuestion": 11,
      "paymentApprovedAt": Timestamp.now(),
      "paymentApprovedBy": adminId,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // RECHAZAR PAGO
  //==================================================

  Future<void> rejectPayment(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "status": "payment_rejected",
      "updatedAt": Timestamp.now(),
    });
  }

//==================================================
// ELIMINAR EVALUACIÓN
//==================================================

  Future<void> deleteEvaluation(
      String evaluationId,
      ) async {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Debes iniciar sesión para eliminar la evaluación.',
      );
    }

    final doc =
    await _evaluations.doc(evaluationId).get();

    if (!doc.exists) {
      throw Exception(
        'La evaluación no existe.',
      );
    }

    final data =
    doc.data() as Map<String, dynamic>;

    // Verificar que la evaluación pertenece al usuario
    final userId =
    data['userId'] as String?;

    if (userId != user.uid) {
      throw Exception(
        'No tienes permiso para eliminar esta evaluación.',
      );
    }

    // Si ya fue pagada, JAMÁS se puede eliminar
    final premiumPaid =
        data['premiumPaid'] == true;

    if (premiumPaid) {
      throw Exception(
        'Esta evaluación ya tiene un pago realizado y no puede eliminarse.',
      );
    }

    // Si existe un pago enviado para revisión,
    // tampoco permitimos eliminarlo.
    final status =
        data['status'] ?? '';

    if (status == 'payment_pending') {
      throw Exception(
        'Esta evaluación tiene un pago pendiente de revisión y no puede eliminarse.',
      );
    }

    // Si está siendo procesada, tampoco se elimina.
    if (status == 'pending_processing') {
      throw Exception(
        'Esta evaluación está siendo procesada y no puede eliminarse.',
      );
    }

    // Si llegó hasta aquí, sí se puede eliminar.
    await _evaluations
        .doc(evaluationId)
        .delete();
  }

  //==================================================
  // REINICIAR
  //==================================================

  Future<void> restartEvaluation(
      String evaluationId,
      ) async {
    await _evaluations.doc(evaluationId).update({
      "currentBlock": 1,
      "currentQuestion": 1,
      "profileLevel": "Sin evaluar",
      "status": "in_progress",
      "answers": {},
      "strengths": [],
      "weaknesses": [],
      "recommendations": [],
      "premiumUnlocked": false,
      "premiumPaid": false,
      "isPremium": false,
      "completedAt": null,
      "updatedAt": Timestamp.now(),
    });
  }
}