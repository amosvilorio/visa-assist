import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  final String id;

  final String userId;

  final bool isForAnotherPerson;

  final String firstName;

  final String lastName;

  final String countryCode;

  final String visaType;

  final bool isPremium;

  final bool premiumUnlocked;

  final bool premiumPaid;

  final String? paymentMethod;

  final String? paymentReference;

  final String? paymentReceipt;

  final Timestamp? paymentDate;

  final Timestamp? paymentApprovedAt;

  final String? paymentApprovedBy;

  final int currentBlock;

  final int currentQuestion;

  final String profileLevel;

  final String status;

  final Map<String, dynamic> answers;

  final List<String> strengths;

  final List<String> weaknesses;

  final List<String> recommendations;

  final Timestamp createdAt;

  final Timestamp updatedAt;

  final Timestamp? completedAt;

  Evaluation({
    required this.id,
    required this.userId,
    required this.isForAnotherPerson,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.visaType,
    required this.isPremium,
    required this.premiumUnlocked,
    required this.premiumPaid,
    this.paymentMethod,

    this.paymentReference,

    this.paymentReceipt,

    this.paymentDate,

    this.paymentApprovedAt,

    this.paymentApprovedBy,
    required this.currentBlock,
    required this.currentQuestion,
    required this.profileLevel,
    required this.status,
    required this.answers,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory Evaluation.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return Evaluation(
      id: id,
      userId: map['userId'] ?? '',
      isForAnotherPerson:
      map['isForAnotherPerson'] ?? false,

      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',

      countryCode: map['countryCode'] ?? 'usa',
      visaType: map['visaType'] ?? 'all',

      isPremium: map['isPremium'] ?? false,
      premiumUnlocked:
      map['premiumUnlocked'] ?? false,
      premiumPaid:
      map['premiumPaid'] ?? false,

      paymentMethod: map['paymentMethod'],

      paymentReference: map['paymentReference'],

      paymentReceipt: map['paymentReceipt'],

      paymentDate: map['paymentDate'],

      paymentApprovedAt: map['paymentApprovedAt'],

      paymentApprovedBy: map['paymentApprovedBy'],

      currentBlock: map['currentBlock'] ?? 1,
      currentQuestion:
      map['currentQuestion'] ?? 1,

      profileLevel:
      map['profileLevel'] ?? 'Sin evaluar',

      status: map['status'] ?? 'in_progress',

      answers: Map<String, dynamic>.from(
        map['answers'] ?? {},
      ),

      strengths: List<String>.from(
        map['strengths'] ?? [],
      ),

      weaknesses: List<String>.from(
        map['weaknesses'] ?? [],
      ),

      recommendations: List<String>.from(
        map['recommendations'] ?? [],
      ),

      createdAt:
      map['createdAt'] ?? Timestamp.now(),

      updatedAt:
      map['updatedAt'] ?? Timestamp.now(),

      completedAt: map['completedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,

      'isForAnotherPerson': isForAnotherPerson,

      'firstName': firstName,
      'lastName': lastName,

      'countryCode': countryCode,
      'visaType': visaType,

      'isPremium': isPremium,
      'premiumUnlocked': premiumUnlocked,
      'premiumPaid': premiumPaid,

      'paymentMethod': paymentMethod,

      'paymentReference': paymentReference,

      'paymentReceipt': paymentReceipt,

      'paymentDate': paymentDate,

      'paymentApprovedAt': paymentApprovedAt,

      'paymentApprovedBy': paymentApprovedBy,

      'currentBlock': currentBlock,
      'currentQuestion': currentQuestion,

      'profileLevel': profileLevel,

      'status': status,

      'answers': answers,

      'strengths': strengths,

      'weaknesses': weaknesses,

      'recommendations': recommendations,

      'createdAt': createdAt,

      'updatedAt': updatedAt,

      'completedAt': completedAt,
    };
  }
}