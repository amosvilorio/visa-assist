import 'package:cloud_firestore/cloud_firestore.dart';

import 'us_contact.dart';
import 'applicant.dart';
import 'passport_information.dart';
import 'address_information.dart';
import 'personal_information.dart';
import 'expediente_status.dart';
import 'travel_information.dart';
import 'travel_companion.dart';
import 'family_information.dart';
import 'work_education_information.dart';
import 'security_background.dart';
import 'additional_information.dart';
import 'visa_process_information.dart';
import 'travel_history.dart';


class Expediente {

  final String id;

  final String userId;

  final String countryCode;

  final String visaType;

  final Applicant? applicant;

  final PassportInformation? passportInformation;

  final AddressInformation? addressInformation;

  final TravelInformation? travelInformation;

  final TravelHistory? travelHistory;

  final List<TravelCompanion> travelCompanions;

  final bool? travelingWithOthers;

  final UsContact? usContact;

  final PersonalInformation? personalInformation;

  final FamilyInformation? familyInformation;

  final WorkEducationInformation? workEducationInformation;

  final SecurityBackground? securityBackground;

  final AdditionalInformation? additionalInformation;

  final VisaProcessInformation? visaProcessInformation;

  //-----------------------------
  // Gestión del expediente
  //-----------------------------

  final String processStatus;

  // Estado de organización del expediente en el panel ADMIN
  // por_completar → en_proceso → terminado
  final String adminProcessStatus;

  final String serviceStatus;


  final String paymentStatus;


  final String reviewStatus;


  final String ds160Status;


  final String casStatus;

  final String mrvStatus;

  final bool mrvAmountRequested;

  final DateTime? mrvAmountRequestedAt;

  final double? mrvAmountRequestedUsd;

  final String mrvAmountRequestStatus;

  final double? mrvDopAmount;

  final DateTime? mrvAmountRespondedAt;


  final String interviewStatus;


  final String finalDecision;

  //-----------------------------
// Información CAS y Entrevista
//-----------------------------

  final String casUsername;

  final String casPassword;

  final String casAppointmentDate;

  final String casAppointmentTime;

  final String casLocation;


  final String interviewDate;

  final String interviewTime;

  final String interviewLocation;


  final String assignedAgentId;


  final String assignedAgentName;


  final double progress;


  final int currentStep;


  final int totalSteps;


  final ExpedienteStatus status;


  final DateTime createdAt;


  final DateTime updatedAt;




  const Expediente({

    required this.id,

    required this.userId,

    required this.countryCode,

    required this.visaType,


    this.applicant,

    this.passportInformation,

    this.addressInformation,

    this.travelInformation,

    this.travelHistory,

    this.travelCompanions = const [],

    this.travelingWithOthers,

    this.usContact,

    this.personalInformation,

    this.familyInformation,

    this.workEducationInformation,

    this.securityBackground,

    this.additionalInformation,

    this.visaProcessInformation,

    this.processStatus = "Formulario",

    // Estado inicial del expediente dentro del panel ADMIN
    this.adminProcessStatus = "por_completar",

    this.serviceStatus = "pendiente",

    this.paymentStatus = "Pendiente",

    this.reviewStatus = "Pendiente",

    this.ds160Status = "No iniciado",

    this.casStatus = "Pendiente",

    this.mrvStatus = "Pendiente",

    this.mrvAmountRequested = false,

    this.mrvAmountRequestedAt,

    this.mrvAmountRequestedUsd,

    this.mrvAmountRequestStatus = "none",

    this.mrvDopAmount,

    this.mrvAmountRespondedAt,

    this.interviewStatus = "Pendiente",

    this.finalDecision = "",

    this.casUsername = "",

    this.casPassword = "",

    this.casAppointmentDate = "",

    this.casAppointmentTime = "",

    this.casLocation = "",


    this.interviewDate = "",

    this.interviewTime = "",

    this.interviewLocation = "",

    this.assignedAgentId = "",

    this.assignedAgentName = "",

    this.progress = 0,

    required this.currentStep,

    required this.totalSteps,

    required this.status,

    required this.createdAt,

    required this.updatedAt,

  });

  factory Expediente.fromFirestore(
      String id,
      Map<String, dynamic> json,
      ) {

    return Expediente(

      id: id,

      userId:
      json["userId"] ?? "",


      countryCode:
      json["countryCode"] ?? "",


      visaType:
      json["visaType"] ?? "",



      applicant:
      json["applicant"] != null

          ? Applicant.fromMap(
        Map<String, dynamic>.from(
          json["applicant"],
        ),
      )

          : null,



      passportInformation:
      json["passportInformation"] != null

          ? PassportInformation.fromMap(
        Map<String, dynamic>.from(
          json["passportInformation"],
        ),
      )

          : null,



      addressInformation:
      json["addressInformation"] != null

          ? AddressInformation.fromMap(
        Map<String, dynamic>.from(
          json["addressInformation"],
        ),
      )

          : null,

      travelInformation:
      json["travelInformation"] != null

          ? TravelInformation.fromMap(
        Map<String, dynamic>.from(
          json["travelInformation"],
        ),
      )

          : null,

      travelHistory:
      json["travelHistory"] != null

          ? TravelHistory.fromMap(
        Map<String, dynamic>.from(
          json["travelHistory"],
        ),
      )

          : null,

      travelCompanions:
      json["travelCompanions"] != null

          ? (json["travelCompanions"] as List)

          .map(

            (e) => TravelCompanion.fromMap(
          Map<String, dynamic>.from(e),
        ),
      )

          .toList()

          : const [],

      travelingWithOthers:
      json["travelingWithOthers"],




      usContact:
      json["usContact"] != null

          ? UsContact.fromMap(
        Map<String, dynamic>.from(
          json["usContact"],
        ),
      )

          : null,




      personalInformation:
      json["personalInformation"] != null

          ? PersonalInformation.fromMap(
        Map<String, dynamic>.from(
          json["personalInformation"],
        ),
      )

          : null,




      familyInformation:
      json["familyInformation"] != null

          ? FamilyInformation.fromMap(
        Map<String, dynamic>.from(
          json["familyInformation"],
        ),
      )

          : null,




      workEducationInformation:
      json["workEducationInformation"] != null

          ? WorkEducationInformation.fromMap(
        Map<String, dynamic>.from(
          json["workEducationInformation"],
        ),
      )

          : null,




      securityBackground:
      json["securityBackground"] != null

          ? SecurityBackground.fromMap(
        Map<String, dynamic>.from(
          json["securityBackground"],
        ),
      )

          : null,




      additionalInformation:
      json["additionalInformation"] != null

          ? AdditionalInformation.fromMap(
        Map<String, dynamic>.from(
          json["additionalInformation"],
        ),
      )

          : null,




      visaProcessInformation:
      json["visaProcessInformation"] != null

          ? VisaProcessInformation.fromMap(
        Map<String, dynamic>.from(
          json["visaProcessInformation"],
        ),
      )

          : null,




      currentStep:
      json["currentStep"] ?? 1,

      totalSteps:
      json["totalSteps"] ?? 18,

      processStatus:
      json["processStatus"] ?? "Formulario",

      adminProcessStatus:
      json["adminProcessStatus"] ?? "por_completar",

      serviceStatus:
      json["serviceStatus"] ?? "pendiente",

      paymentStatus:
      json["paymentStatus"] ?? "Pendiente",

      reviewStatus:
      json["reviewStatus"] ?? "Pendiente",

      ds160Status:
      json["ds160Status"] ?? "No iniciado",

      casStatus:
      json["casStatus"] ?? "Pendiente",

      mrvStatus:
      json["mrvStatus"] ?? "Pendiente",


//---------------------------------------------
// Solicitud de monto MRV
//---------------------------------------------

      mrvAmountRequested:
      json["mrvAmountRequested"] ?? false,

      mrvAmountRequestedAt:
      json["mrvAmountRequestedAt"] != null
          ? (json["mrvAmountRequestedAt"] as Timestamp).toDate()
          : null,

      mrvAmountRequestedUsd:
      json["mrvAmountRequestedUsd"] != null
          ? (json["mrvAmountRequestedUsd"] as num).toDouble()
          : null,

      mrvAmountRequestStatus:
      json["mrvAmountRequestStatus"] ?? "none",

      mrvDopAmount:
      json["mrvDopAmount"] != null
          ? (json["mrvDopAmount"] as num).toDouble()
          : null,

      mrvAmountRespondedAt:
      json["mrvAmountRespondedAt"] != null
          ? (json["mrvAmountRespondedAt"] as Timestamp).toDate()
          : null,


      interviewStatus:
      json["interviewStatus"] ?? "Pendiente",

      casUsername:
      json["casUsername"] ?? "",


      casPassword:
      json["casPassword"] ?? "",


      casAppointmentDate:
      json["casAppointmentDate"] ?? "",


      casAppointmentTime:
      json["casAppointmentTime"] ?? "",


      casLocation:
      json["casLocation"] ?? "",


      interviewDate:
      json["interviewDate"] ?? "",


      interviewTime:
      json["interviewTime"] ?? "",


      interviewLocation:
      json["interviewLocation"] ?? "",



      finalDecision:
      json["finalDecision"] ?? "",



      assignedAgentId:
      json["assignedAgentId"] ?? "",



      assignedAgentName:
      json["assignedAgentName"] ?? "",



      progress:
      (json["progress"] ?? 0).toDouble(),



      status:
      ExpedienteStatusExtension.fromString(
        json["status"] ?? "in_progress",
      ),



      createdAt:
      (json["createdAt"] as Timestamp).toDate(),



      updatedAt:
      (json["updatedAt"] as Timestamp).toDate(),

    );

  }

  Map<String, dynamic> toFirestore() {

    return {

      "userId": userId,

      "countryCode": countryCode,

      "visaType": visaType,


      "applicant":
      applicant?.toMap(),


      "passportInformation":
      passportInformation?.toMap(),


      "addressInformation":
      addressInformation?.toMap(),


      "travelInformation":
      travelInformation?.toMap(),

      "travelHistory":
      travelHistory?.toMap(),

      "travelCompanions":
      travelCompanions
          .map((e) => e.toMap())
          .toList(),

      "travelingWithOthers":
      travelingWithOthers,

      "usContact":
      usContact?.toMap(),

      "personalInformation":
      personalInformation?.toMap(),

      "familyInformation":
      familyInformation?.toMap(),


      "workEducationInformation":
      workEducationInformation?.toMap(),


      "securityBackground":
      securityBackground?.toMap(),


      "additionalInformation":
      additionalInformation?.toMap(),


      "visaProcessInformation":
      visaProcessInformation?.toMap(),



      "currentStep":
      currentStep,

      "totalSteps":
      totalSteps,

      "processStatus":
      processStatus,

      "adminProcessStatus":
      adminProcessStatus,

      "serviceStatus":
      serviceStatus,

      "paymentStatus":
      paymentStatus,

      "reviewStatus":
      reviewStatus,

      "ds160Status":
      ds160Status,

      "casStatus":
      casStatus,


      "mrvStatus":
      mrvStatus,


//---------------------------------------------
// Solicitud de monto MRV
//---------------------------------------------

      "mrvAmountRequested":
      mrvAmountRequested,

      "mrvAmountRequestedAt":
      mrvAmountRequestedAt != null
          ? Timestamp.fromDate(
        mrvAmountRequestedAt!,
      )
          : null,

      "mrvAmountRequestedUsd":
      mrvAmountRequestedUsd,

      "mrvAmountRequestStatus":
      mrvAmountRequestStatus,

      "mrvDopAmount":
      mrvDopAmount,

      "mrvAmountRespondedAt":
      mrvAmountRespondedAt != null
          ? Timestamp.fromDate(
        mrvAmountRespondedAt!,
      )
          : null,


      "interviewStatus":
      interviewStatus,

      "casUsername":
      casUsername,


      "casPassword":
      casPassword,


      "casAppointmentDate":
      casAppointmentDate,


      "casAppointmentTime":
      casAppointmentTime,


      "casLocation":
      casLocation,


      "interviewDate":
      interviewDate,


      "interviewTime":
      interviewTime,


      "interviewLocation":
      interviewLocation,


      "finalDecision":
      finalDecision,


      "assignedAgentId":
      assignedAgentId,


      "assignedAgentName":
      assignedAgentName,


      "progress":
      progress,

      "status":
      status.value,

      "createdAt":
      Timestamp.fromDate(createdAt),

      "updatedAt":
      Timestamp.fromDate(updatedAt),

    };

  }

  Expediente copyWith({

    String? id,

    String? userId,

    String? countryCode,

    String? visaType,

    Applicant? applicant,

    PassportInformation? passportInformation,

    AddressInformation? addressInformation,

    TravelInformation? travelInformation,

    TravelHistory? travelHistory,

    List<TravelCompanion>? travelCompanions,

    bool? travelingWithOthers,

    UsContact? usContact,

    PersonalInformation? personalInformation,

    FamilyInformation? familyInformation,

    WorkEducationInformation? workEducationInformation,

    SecurityBackground? securityBackground,

    AdditionalInformation? additionalInformation,

    VisaProcessInformation? visaProcessInformation,

    String? processStatus,

    String? adminProcessStatus,

    String? serviceStatus,

    String? paymentStatus,

    String? reviewStatus,

    String? ds160Status,

    String? casStatus,

    String? mrvStatus,

    bool? mrvAmountRequested,

    DateTime? mrvAmountRequestedAt,

    double? mrvAmountRequestedUsd,

    String? mrvAmountRequestStatus,

    double? mrvDopAmount,

    DateTime? mrvAmountRespondedAt,

    String? interviewStatus,

    String? finalDecision,

    String? casUsername,

    String? casPassword,

    String? casAppointmentDate,

    String? casAppointmentTime,

    String? casLocation,

    String? interviewDate,

    String? interviewTime,

    String? interviewLocation,

    String? assignedAgentId,

    String? assignedAgentName,

    double? progress,

    int? currentStep,

    int? totalSteps,

    ExpedienteStatus? status,

    DateTime? createdAt,

    DateTime? updatedAt,

  }) {

    return Expediente(

      id:
      id ?? this.id,

      userId:
      userId ?? this.userId,

      countryCode:
      countryCode ?? this.countryCode,

      visaType:
      visaType ?? this.visaType,

      applicant:
      applicant ?? this.applicant,

      passportInformation:
      passportInformation ??
          this.passportInformation,

      addressInformation:
      addressInformation ??
          this.addressInformation,

      travelInformation:
      travelInformation ??
          this.travelInformation,

      travelHistory:
      travelHistory ??
          this.travelHistory,

      travelCompanions:
      travelCompanions ??
          this.travelCompanions,

      travelingWithOthers:
      travelingWithOthers ??
          this.travelingWithOthers,

      usContact:
      usContact ??
          this.usContact,

      personalInformation:
      personalInformation ??
          this.personalInformation,

      familyInformation:
      familyInformation ??
          this.familyInformation,

      workEducationInformation:
      workEducationInformation ??
          this.workEducationInformation,

      securityBackground:
      securityBackground ??
          this.securityBackground,

      additionalInformation:
      additionalInformation ??
          this.additionalInformation,

      visaProcessInformation:
      visaProcessInformation ??
          this.visaProcessInformation,

      processStatus:
      processStatus ??
          this.processStatus,

      adminProcessStatus:
      adminProcessStatus ??
          this.adminProcessStatus,

      serviceStatus:
      serviceStatus ??
          this.serviceStatus,

      paymentStatus:
      paymentStatus ??
          this.paymentStatus,

      reviewStatus:
      reviewStatus ??
          this.reviewStatus,

      ds160Status:
      ds160Status ??
          this.ds160Status,

      casStatus:
      casStatus ??
          this.casStatus,

      mrvStatus:
      mrvStatus ??
          this.mrvStatus,


      mrvAmountRequested:
      mrvAmountRequested ??
          this.mrvAmountRequested,

      mrvAmountRequestedAt:
      mrvAmountRequestedAt ??
          this.mrvAmountRequestedAt,

      mrvAmountRequestedUsd:
      mrvAmountRequestedUsd ??
          this.mrvAmountRequestedUsd,

      mrvAmountRequestStatus:
      mrvAmountRequestStatus ??
          this.mrvAmountRequestStatus,

      mrvDopAmount:
      mrvDopAmount ??
          this.mrvDopAmount,

      mrvAmountRespondedAt:
      mrvAmountRespondedAt ??
          this.mrvAmountRespondedAt,


      interviewStatus:
      interviewStatus ??
          this.interviewStatus,

      casUsername:
      casUsername ??
          this.casUsername,


      casPassword:
      casPassword ??
          this.casPassword,


      casAppointmentDate:
      casAppointmentDate ??
          this.casAppointmentDate,


      casAppointmentTime:
      casAppointmentTime ??
          this.casAppointmentTime,

      casLocation:
      casLocation ??
          this.casLocation,

      interviewDate:
      interviewDate ??
          this.interviewDate,

      interviewTime:
      interviewTime ??
          this.interviewTime,

      interviewLocation:
      interviewLocation ??
          this.interviewLocation,

      finalDecision:
      finalDecision ??
          this.finalDecision,

      assignedAgentId:
      assignedAgentId ??
          this.assignedAgentId,

      assignedAgentName:
      assignedAgentName ??
          this.assignedAgentName,

      progress:
      progress ??
          this.progress,

      currentStep:
      currentStep ??
          this.currentStep,

      totalSteps:
      totalSteps ??
          this.totalSteps,

      status:
      status ??
          this.status,

      createdAt:
      createdAt ??
          this.createdAt,

      updatedAt:
      updatedAt ??
          this.updatedAt,

    );

  }

}