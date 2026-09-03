import 'dart:io';
import 'expediente_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'evaluation_service.dart';
import '../models/payment.dart';
import 'notification_service.dart';

class PaymentService {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final EvaluationService _evaluationService =
  EvaluationService();

  final NotificationService _notificationService =
  NotificationService();

  CollectionReference<Map<String, dynamic>>
  get _payments =>
      _db.collection("payments");

  //==================================================
  // CREAR PAGO
  //==================================================

  Future<String> createPayment({

    required String expedienteId,

    required String paymentType,

    required File receiptImage,

    required double amount,

    required String currency,

    required String paymentMethod,

    required String bankId,

    required String bankName,

    String notes = "",

  }) async {

    final user = _auth.currentUser!;

    final existingPayments = await _payments
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .where(
      "expedienteId",
      isEqualTo: expedienteId,
    )
        .where(
      "paymentType",
      isEqualTo: paymentType,
    )
        .get();


    for (final doc in existingPayments.docs) {

      final data = doc.data();

      final status = data["status"];

      print("========================================");
      print("PAGO ENCONTRADO");
      print("paymentId: ${doc.id}");
      print("userId: ${data["userId"]}");
      print("expedienteId: ${data["expedienteId"]}");
      print("paymentType: ${data["paymentType"]}");
      print("status: $status");
      print("========================================");

      if (status == "pending" ||
          status == "approved") {

        throw Exception(
          "Ya existe un pago ${status == "approved" ? "aprobado" : "pendiente"} para esta evaluación. ID: ${doc.id}",
        );

      }

    }

    final paymentDoc =
    _payments.doc();

    final storageRef = _storage
        .ref()
        .child(
      "payment_receipts/${paymentDoc.id}.jpg",
    );

    await storageRef.putFile(
      receiptImage,
    );

    final receiptUrl =
    await storageRef.getDownloadURL();

    final payment = Payment(

      id: paymentDoc.id,

      userId: user.uid,

      expedienteId: expedienteId,

      paymentType: paymentType,

      amount: amount,

      currency: currency,

      paymentMethod: paymentMethod,

      bankId: bankId,

      bankName: bankName,

      receiptUrl: receiptUrl,

      notes: notes,

      status: "pending",

      createdAt: Timestamp.now(),

      updatedAt: Timestamp.now(),

      reviewedAt: null,

      reviewedBy: null,

      adminComment: null,

    );

    await paymentDoc.set(
      payment.toMap(),
    );

    if (paymentType == "service") {

      await _expedienteService.updatePaymentStatus(

        expedienteId: expedienteId,

        paymentStatus: "En revisión",

      );

    }

    if (paymentType == "mrv") {

      await _expedienteService.updateMrvStatus(
        expedienteId: expedienteId,
        status: "En revisión",
      );

    }
    return paymentDoc.id;
  }

  //==================================================
  // OBTENER UN PAGO
  //==================================================

  Future<Payment?> getPayment(
      String paymentId,
      ) async {

    final doc =
    await _payments.doc(paymentId).get();

    if (!doc.exists) {
      return null;
    }

    return Payment.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  //==================================================
  // PAGOS DEL USUARIO
  //==================================================

  Stream<List<Payment>> myPayments() {

    final user =
    _auth.currentUser!;

    return _payments

        .where(
      "userId",
      isEqualTo: user.uid,
    )

        .orderBy(
      "createdAt",
      descending: true,
    )

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

          .map(

            (doc) => Payment.fromMap(
          doc.data(),
          doc.id,
        ),

      )

          .toList(),

    );

  }

  //==================================================
  // PAGOS POR EXPEDIENTE
  //==================================================

  Stream<List<Payment>>
  paymentsByExpediente(
      String expedienteId,
      ) {

    return _payments

        .where(
      "expedienteId",
      isEqualTo: expedienteId,
    )

        .orderBy(
      "createdAt",
      descending: true,
    )

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

          .map(

            (doc) => Payment.fromMap(
          doc.data(),
          doc.id,
        ),

      )

          .toList(),

    );

  }

  //==================================================
  // PAGOS PENDIENTES
  //==================================================

  Stream<List<Payment>> pendingPayments() {

    return _payments

        .where(
      "status",
      isEqualTo: "pending",
    )

        .orderBy(
      "createdAt",
      descending: true,
    )

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

          .map(

            (doc) => Payment.fromMap(
          doc.data(),
          doc.id,
        ),

      )

          .toList(),

    );

  }

  //==================================================
  // TODOS LOS PAGOS (ADMIN)
  //==================================================

  Stream<List<Payment>> allPayments() {

    return _payments

        .orderBy(
      "createdAt",
      descending: true,
    )

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

          .map(

            (doc) => Payment.fromMap(
          doc.data(),
          doc.id,
        ),

      )

          .toList(),

    );

  }

  //==================================================
  // APROBAR PAGO
  //==================================================

  Future<void> approvePayment({

    required String paymentId,

  }) async {

    final admin = _auth.currentUser!;

    final payment =
    await getPayment(paymentId);

    if (payment == null) {
      return;
    }

    final currentPayment = payment;

    await _payments.doc(paymentId).update({

      "status": "approved",

      "reviewedAt": Timestamp.now(),

      "reviewedBy": admin.uid,

      "updatedAt": Timestamp.now(),

    });

    if (payment.paymentType == "service") {

      await _expedienteService.updatePaymentStatus(
        expedienteId: currentPayment.expedienteId,
        paymentStatus: "Aprobado",
      );

      await _expedienteService.updateServiceStatus(
        expedienteId: currentPayment.expedienteId,
        serviceStatus: "contratado",
      );

      //==================================================
      // NOTIFICAR CLIENTE
      //==================================================

      await _notificationService.createNotification(
        userId: currentPayment.userId,
        title: "Pago del servicio aprobado",
        message:
        "Tu pago del servicio Visa Assist ha sido aprobado. Nuestro equipo comenzará a trabajar en tu DS-160 y en la gestión de tus citas.",
        type: "service_payment_approved",
        expedienteId: currentPayment.expedienteId,
        data: {
          "paymentId": currentPayment.id,
          "paymentType": currentPayment.paymentType,
        },
      );
    }

    if (payment.paymentType == "mrv") {

      await _expedienteService.updateMrvStatus(
        expedienteId: currentPayment.expedienteId,
        status: "pago mrv confirmado",
      );

      //==================================================
      // NOTIFICAR CLIENTE - PAGO MRV APROBADO
      //==================================================

      await _notificationService.createNotification(
        userId: currentPayment.userId,
        title: "Pago de la tarifa de visa aprobado",
        message:
        "Tu pago de la tarifa de visa ha sido aprobado. "
            "Visa Assist continuará con la gestión de tu proceso.",
        type: "mrv_payment_approved",
        expedienteId: currentPayment.expedienteId,
        data: {
          "paymentId": currentPayment.id,
          "paymentType": currentPayment.paymentType,
          "amount": currentPayment.amount,
          "currency": currentPayment.currency,
        },
      );

    }

    if (payment.paymentType == "evaluation") {

      await _evaluationService.approvePayment(
        evaluationId: currentPayment.expedienteId,
        adminId: admin.uid,
      );

      //==================================================
      // NOTIFICAR CLIENTE - PREMIUM DESBLOQUEADO
      //==================================================

      await _notificationService.createNotification(
        userId: currentPayment.userId,
        title: "Evaluación Premium desbloqueada",
        message:
        "Tu pago ha sido aprobado. La evaluación Premium ya está desbloqueada y puedes continuar con tu proceso.",
        type: "evaluation_payment_approved",
        expedienteId: currentPayment.expedienteId,
        data: {
          "paymentId": currentPayment.id,
          "paymentType": currentPayment.paymentType,
          "premiumUnlocked": true,
        },
      );
    }

  }

  //==================================================
  // RECHAZAR PAGO
  //==================================================

  Future<void> rejectPayment({

    required String paymentId,

    required String comment,

  }) async {

    final admin = _auth.currentUser!;

    await _payments.doc(paymentId).update({

      "status": "rejected",

      "adminComment": comment,

      "reviewedAt": Timestamp.now(),

      "reviewedBy": admin.uid,

      "updatedAt": Timestamp.now(),

    });

    final payment = await getPayment(paymentId);

    if (payment != null &&
        payment.paymentType == "service") {

      await _expedienteService.updatePaymentStatus(
        expedienteId: payment.expedienteId,
        paymentStatus: "Pendiente",
      );

      await _expedienteService.updateServiceStatus(
        expedienteId: payment.expedienteId,
        serviceStatus: "pendiente",
      );
    }

    if (payment != null &&
        payment.paymentType == "mrv") {

      await _expedienteService.updateMrvStatus(
        expedienteId: payment.expedienteId,
        status: "Pendiente",
      );

      await _notificationService.createNotification(
        userId: payment.userId,
        title: "Pago del servicio rechazado",
        message:
        "Tu comprobante de pago del servicio Visa Assist fue rechazado. Revisa el motivo y vuelve a enviar un comprobante válido.",
        type: "service_payment_rejected",
        expedienteId: payment.expedienteId,
        data: {
          "paymentId": payment.id,
          "paymentType": payment.paymentType,
          "adminComment": comment,
        },
      );
    }

    if (payment != null &&
        payment.paymentType == "evaluation") {

      await _evaluationService.rejectPayment(
        payment.expedienteId,
      );

      //==================================================
      // NOTIFICAR CLIENTE - PREMIUM RECHAZADO
      //==================================================

      await _notificationService.createNotification(
        userId: payment.userId,
        title: "Pago Premium rechazado",
        message:
        "Tu comprobante de pago para la evaluación Premium fue rechazado. Revisa el motivo y vuelve a enviar un comprobante válido.",
        type: "evaluation_payment_rejected",
        expedienteId: payment.expedienteId,
        data: {
          "paymentId": payment.id,
          "paymentType": payment.paymentType,
          "adminComment": comment,
        },
      );
    }
  }

  //==================================================
  // ACTUALIZAR COMENTARIO ADMIN
  //==================================================

  Future<void> updateAdminComment({

    required String paymentId,

    required String comment,

  }) async {

    await _payments.doc(paymentId).update({

      "adminComment": comment,

      "updatedAt": Timestamp.now(),

    });

  }

  //==================================================
  // ELIMINAR PAGO
  //==================================================

  Future<void> deletePayment(
      String paymentId,
      ) async {

    final payment =
    await _payments.doc(paymentId).get();

    if (!payment.exists) return;

    final data = payment.data()!;

    final receiptUrl =
        data["receiptUrl"] ?? "";

    if (receiptUrl.toString().isNotEmpty) {

      try {

        await _storage
            .refFromURL(receiptUrl)
            .delete();

      } catch (_) {}

    }

    await _payments
        .doc(paymentId)
        .delete();

  }

}