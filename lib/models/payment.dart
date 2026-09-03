import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;

  /// Usuario que realizó el pago
  final String userId;

  /// Expediente relacionado
  final String expedienteId;

  /// evaluation | service | mrv
  final String paymentType;

  /// Monto pagado
  final double amount;

  /// DOP | USD | EUR
  final String currency;

  /// Transferencia, efectivo, etc.
  final String paymentMethod;

  /// Banco utilizado
  final String bankId;

  /// Nombre del banco utilizado
  final String bankName;

  /// URL del comprobante
  final String receiptUrl;

  /// Observaciones del cliente
  final String notes;

  /// pending | approved | rejected
  final String status;

  final Timestamp createdAt;

  final Timestamp updatedAt;

  /// Fecha de aprobación/rechazo
  final Timestamp? reviewedAt;

  /// Administrador que revisó
  final String? reviewedBy;

  /// Comentario del administrador
  final String? adminComment;

  const Payment({
    required this.id,
    required this.userId,
    required this.expedienteId,
    required this.paymentType,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.bankId,
    required this.bankName,
    required this.receiptUrl,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.adminComment,
  });

  factory Payment.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return Payment(
      id: id,
      userId: map["userId"] ?? "",
      expedienteId: map["expedienteId"] ?? "",
      paymentType: map["paymentType"] ?? "evaluation",
      amount: (map["amount"] ?? 0).toDouble(),
      currency: map["currency"] ?? "DOP",
      paymentMethod: map["paymentMethod"] ?? "Transferencia Bancaria",
      bankId: map["bankId"] ?? "",
      bankName: map["bankName"] ?? "",
      receiptUrl: map["receiptUrl"] ?? "",
      notes: map["notes"] ?? "",
      status: map["status"] ?? "pending",
      createdAt: map["createdAt"] ?? Timestamp.now(),
      updatedAt: map["updatedAt"] ?? Timestamp.now(),
      reviewedAt: map["reviewedAt"],
      reviewedBy: map["reviewedBy"],
      adminComment: map["adminComment"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "expedienteId": expedienteId,
      "paymentType": paymentType,
      "amount": amount,
      "currency": currency,
      "paymentMethod": paymentMethod,
      "bankId": bankId,
      "bankName": bankName,
      "receiptUrl": receiptUrl,
      "notes": notes,
      "status": status,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "reviewedAt": reviewedAt,
      "reviewedBy": reviewedBy,
      "adminComment": adminComment,
    };
  }

  Payment copyWith({
    String? id,
    String? userId,
    String? expedienteId,
    String? paymentType,
    double? amount,
    String? currency,
    String? paymentMethod,
    String? bankId,
    String? bankName,
    String? receiptUrl,
    String? notes,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? reviewedAt,
    String? reviewedBy,
    String? adminComment,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      expedienteId: expedienteId ?? this.expedienteId,
      paymentType: paymentType ?? this.paymentType,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      bankId: bankId ?? this.bankId,
      bankName: bankName ?? this.bankName,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      adminComment: adminComment ?? this.adminComment,
    );
  }

  bool get isPending => status == "pending";

  bool get isApproved => status == "approved";

  bool get isRejected => status == "rejected";

  bool get isEvaluation =>
      paymentType == "evaluation";

  bool get isService =>
      paymentType == "service";

  bool get isMrv =>
      paymentType == "mrv";
}