import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/applicant.dart';
import '../models/address_information.dart';
import '../models/personal_information.dart';
import '../models/expediente.dart';
import '../models/expediente_status.dart';
import '../models/passport_information.dart';
import '../models/travel_information.dart';
import '../models/travel_companion.dart';
import '../models/us_contact.dart';
import '../models/family_information.dart';
import '../models/work_education_information.dart';
import '../models/security_background.dart';
import '../models/additional_information.dart';
import '../models/travel_history.dart';
import '../models/visa_process_information.dart';

class ExpedienteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _collection =>
      _firestore.collection("expedientes");

  Future<String> createExpediente({
    required String countryCode,
    required String visaType,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    final doc = _collection.doc();

    final expediente = Expediente(
      id: doc.id,
      userId: user.uid,
      countryCode: countryCode,
      visaType: visaType,
      currentStep: 1,
      totalSteps: 18,
      status: ExpedienteStatus.inProgress,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final data = expediente.toFirestore();

    // Garantizamos que el expediente pertenece
    // al usuario autenticado.
    data["userId"] = user.uid;

    await doc.set(data);

    return doc.id;
  }

  Future<Expediente?> getActiveExpediente() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    final result = await _collection
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .where(
      "status",
      isEqualTo: ExpedienteStatus.inProgress.value,
    )
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    final data =
    result.docs.first.data() as Map<String, dynamic>;

    return Expediente.fromFirestore(
      result.docs.first.id,
      data,
    );
  }

  //==================================================
  // OBTENER EXPEDIENTE ACTUAL
  //==================================================

  Future<Expediente?> getExpedienteById(
      String expedienteId,
      ) async {

    final doc =
    await _collection.doc(expedienteId).get();

    if (!doc.exists) {
      return null;
    }

    return Expediente.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }


  //==================================================
// ESCUCHAR EXPEDIENTE EN TIEMPO REAL
//==================================================

  Stream<Expediente?> watchExpediente(
      String expedienteId,
      ) {
    return _collection
        .doc(expedienteId)
        .snapshots()
        .map((doc) {

      if (!doc.exists) {
        return null;
      }

      return Expediente.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    });
  }

  Future<void> updateCurrentStep({
    required String expedienteId,
    required int step,
  }) async {
    await _collection.doc(expedienteId).update({
      "currentStep": step,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ACTUALIZAR PAÍS DEL EXPEDIENTE
  //==================================================

  Future<void> updateCountryCode({
    required String expedienteId,
    required String countryCode,
  }) async {
    await _collection.doc(expedienteId).update({
      "countryCode": countryCode,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ACTUALIZAR TIPO DE VISA DEL EXPEDIENTE
  //==================================================

  Future<void> updateVisaType({
    required String expedienteId,
    required String visaType,
  }) async {
    await _collection.doc(expedienteId).update({
      "visaType": visaType,
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> completeExpediente(
      String expedienteId,
      ) async {
    await _collection.doc(expedienteId).update({
      "status": ExpedienteStatus.completed.value,
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveInterviewResult({
    required String expedienteId,
    required String result,
    String comment = "",
  }) async {
    final bool isFinal =
        result == "Aprobada" ||
            result == "Denegada";

    await _collection.doc(expedienteId).update({
      "finalDecision": result,
      "interviewResultComment": comment,
      "interviewResultAt": Timestamp.now(),
      "updatedAt": Timestamp.now(),
      if (isFinal)
        "status": ExpedienteStatus.completed.value,
    });
  }

  Stream<List<Expediente>> getMyExpedientes() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _collection
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .snapshots()
        .map(
          (snapshot) {
        final expedientes = snapshot.docs
            .map(
              (doc) => Expediente.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        )
            .where(
              (expediente) =>
          expediente.status !=
              ExpedienteStatus.completed,
        )
            .toList();

        expedientes.sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
        );

        return expedientes;
      },
    );
  }

  Stream<List<Expediente>> getMyCompletedExpedientes() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _collection
        .where(
      "userId",
      isEqualTo: user.uid,
    )
        .snapshots()
        .map(
          (snapshot) {
        final expedientes = snapshot.docs
            .map(
              (doc) => Expediente.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        )
            .where(
              (expediente) =>
          expediente.status ==
              ExpedienteStatus.completed,
        )
            .toList();

        expedientes.sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
        );

        return expedientes;
      },
    );
  }
  
  //--------------------------------------------------
  // TODOS LOS EXPEDIENTES (ADMIN)
  //--------------------------------------------------

  Stream<List<Expediente>> getAllExpedientes() {
    return _collection
        .orderBy(
      "updatedAt",
      descending: true,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => Expediente.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Future<void> saveApplicant({
    required String expedienteId,
    required Applicant applicant,
  }) async {
    await _collection.doc(expedienteId).update({
      "applicant": applicant.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> savePersonalInformation({
    required String expedienteId,
    required PersonalInformation personalInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "personalInformation": personalInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> savePassportInformation({
    required String expedienteId,
    required PassportInformation passportInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "passportInformation": passportInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveAddressInformation({
    required String expedienteId,
    required AddressInformation addressInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "addressInformation": addressInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveTravelInformation({
    required String expedienteId,
    required TravelInformation travelInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "travelInformation": travelInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveTravelCompanions({
    required String expedienteId,
    required List<TravelCompanion> travelCompanions,
    required bool travelingWithOthers,
  }) async {
    await _collection.doc(expedienteId).update({
      "travelCompanions":
      travelCompanions.map((e) => e.toMap()).toList(),
      "travelingWithOthers": travelingWithOthers,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // CONTACTO EN EE.UU.
  //--------------------------------------------------

  Future<void> saveUsContact({
    required String expedienteId,
    required UsContact usContact,
  }) async {
    await _collection.doc(expedienteId).update({
      "usContact": usContact.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> deleteUsContact({
    required String expedienteId,
  }) async {
    await _collection.doc(expedienteId).update({
      "usContact": FieldValue.delete(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveTravelHistory({
    required String expedienteId,
    required TravelHistory travelHistory,
  }) async {
    await _collection.doc(expedienteId).update({
      "travelHistory": travelHistory.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveFamilyInformation({
    required String expedienteId,
    required FamilyInformation familyInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "familyInformation": familyInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveWorkEducationInformation({
    required String expedienteId,
    required WorkEducationInformation workEducationInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "workEducationInformation":
      workEducationInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveSecurityBackground({
    required String expedienteId,
    required SecurityBackground securityBackground,
  }) async {
    await _collection.doc(expedienteId).update({
      "securityBackground":
      securityBackground.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> saveAdditionalInformation({
    required String expedienteId,
    required AdditionalInformation additionalInformation,
  }) async {
    await _collection.doc(expedienteId).update({
      "additionalInformation":
      additionalInformation.toMap(),
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL EXPEDIENTE
  //--------------------------------------------------

  Future<void> updateProcessStatus({
    required String expedienteId,
    required String processStatus,
    double? progress,
  }) async {
    final data = <String, dynamic>{
      "processStatus": processStatus,
      "updatedAt": Timestamp.now(),
    };

    if (progress != null) {
      data["progress"] = progress;
    }

    await _collection.doc(expedienteId).update(data);
  }

  //--------------------------------------------------
  // ESTADO DEL EXPEDIENTE EN EL PANEL ADMIN
  //--------------------------------------------------

  Future<void> updateAdminProcessStatus({
    required String expedienteId,
    required String status,
  }) async {
    await _collection.doc(expedienteId).update({
      "adminProcessStatus": status,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // MOVER EXPEDIENTE A EN PROCESO
  //--------------------------------------------------

  Future<void> moveExpedienteToInProcess({
    required String expedienteId,
  }) async {
    await _collection.doc(expedienteId).update({
      "adminProcessStatus": "en_proceso",
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // MOVER EXPEDIENTE A TERMINADO
  //--------------------------------------------------

  Future<void> moveExpedienteToCompleted({
    required String expedienteId,
  }) async {
    await _collection.doc(expedienteId).update({
      "adminProcessStatus": "terminado",
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL PAGO
  //--------------------------------------------------

  Future<void> updatePaymentStatus({
    required String expedienteId,
    required String paymentStatus,
  }) async {
    await _collection.doc(expedienteId).update({
      "paymentStatus": paymentStatus,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL SERVICIO VISA ASSIST
  //--------------------------------------------------

  Future<void> updateServiceStatus({
    required String expedienteId,
    required String serviceStatus,
  }) async {
    await _collection.doc(expedienteId).update({
      "serviceStatus": serviceStatus,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ASIGNAR AGENTE
  //--------------------------------------------------

  Future<void> assignAgent({
    required String expedienteId,
    required String agentId,
    required String agentName,
  }) async {
    await _collection.doc(expedienteId).update({
      "assignedAgentId": agentId,
      "assignedAgentName": agentName,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL DS-160
  //--------------------------------------------------

  Future<void> updateDs160Status({
    required String expedienteId,
    required String status,
  }) async {
    await _collection.doc(expedienteId).update({
      "ds160Status": status,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL CAS
  //--------------------------------------------------

  Future<void> updateCasStatus({
    required String expedienteId,
    required String status,
  }) async {
    await _collection.doc(expedienteId).update({
      "casStatus": status,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR ESTADO DEL MRV
  //--------------------------------------------------

  Future<void> updateMrvStatus({
    required String expedienteId,
    required String status,
  }) async {
    await _collection.doc(expedienteId).update({
      "mrvStatus": status,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
// SOLICITAR MONTO MRV EN PESOS DOMINICANOS
//--------------------------------------------------

  Future<void> requestMrvDopAmount({
    required String expedienteId,
    required double mrvUsdAmount,
  }) async {
    await _collection.doc(expedienteId).update({
      "mrvAmountRequested": true,
      "mrvAmountRequestedAt": Timestamp.now(),
      "mrvAmountRequestedUsd": mrvUsdAmount,
      "mrvAmountRequestStatus": "pending",
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
// RESPONDER MONTO MRV EN PESOS DOMINICANOS
//--------------------------------------------------

  Future<void> setMrvDopAmount({
    required String expedienteId,
    required double dopAmount,
  }) async {
    await _collection.doc(expedienteId).update({
      "mrvDopAmount": dopAmount,
      "mrvAmountRespondedAt": Timestamp.now(),
      "mrvAmountRequestStatus": "responded",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
// SOLICITUDES MRV PENDIENTES DE MONTO
//==================================================

  Stream<List<Expediente>> pendingMrvAmountRequests() {
    return _collection
        .where(
      "mrvAmountRequestStatus",
      isEqualTo: "pending",
    )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expediente.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  //--------------------------------------------------
  // ACTUALIZAR RESULTADO FINAL
  //--------------------------------------------------

  Future<void> updateFinalDecision({
    required String expedienteId,
    required String decision,
  }) async {
    await _collection.doc(expedienteId).update({
      "finalDecision": decision,
      "updatedAt": Timestamp.now(),
    });
  }

  //--------------------------------------------------
  // GUARDAR INFORMACIÓN FINAL VISA ASSIST
  //--------------------------------------------------

  Future<void> saveVisaProcessInformation({
    required String expedienteId,
    required VisaProcessInformation information,
  }) async {

    final docRef =
    _collection.doc(expedienteId);

    final snapshot =
    await docRef.get();

    if (!snapshot.exists) {
      throw Exception(
        "El expediente no existe.",
      );
    }

    final data =
    snapshot.data() as Map<String, dynamic>;

    // ==================================================
    // RECUPERAR INFORMACIÓN EXISTENTE
    // ==================================================

    final existingVisaData =
    data["visaProcessInformation"] != null
        ? Map<String, dynamic>.from(
      data["visaProcessInformation"],
    )
        : <String, dynamic>{};

    // ==================================================
    // SOLO ACTUALIZAR LOS CAMPOS QUE TIENEN VALOR
    // ==================================================

    if (information.ds160PdfUrl != null &&
        information.ds160PdfUrl!.isNotEmpty) {
      existingVisaData["ds160PdfUrl"] =
          information.ds160PdfUrl;
    }

    if (information.ds160FileName != null &&
        information.ds160FileName!.isNotEmpty) {
      existingVisaData["ds160FileName"] =
          information.ds160FileName;
    }

    if (information.casUsername != null &&
        information.casUsername!.isNotEmpty) {
      existingVisaData["casUsername"] =
          information.casUsername;
    }

    if (information.casPassword != null &&
        information.casPassword!.isNotEmpty) {
      existingVisaData["casPassword"] =
          information.casPassword;
    }

    if (information.casDate != null &&
        information.casDate!.isNotEmpty) {
      existingVisaData["casDate"] =
          information.casDate;
    }

    if (information.casTime != null &&
        information.casTime!.isNotEmpty) {
      existingVisaData["casTime"] =
          information.casTime;
    }

    if (information.interviewDate != null &&
        information.interviewDate!.isNotEmpty) {
      existingVisaData["interviewDate"] =
          information.interviewDate;
    }

    if (information.interviewTime != null &&
        information.interviewTime!.isNotEmpty) {
      existingVisaData["interviewTime"] =
          information.interviewTime;
    }

    if (information.interviewLocation != null &&
        information.interviewLocation!.isNotEmpty) {
      existingVisaData["interviewLocation"] =
          information.interviewLocation;
    }

    // ==================================================
    // GUARDAR SIN BORRAR INFORMACIÓN EXISTENTE
    // ==================================================

    final updateData =
    <String, dynamic>{
      "visaProcessInformation":
      existingVisaData,

      "updatedAt":
      Timestamp.now(),
    };

    // ==================================================
    // CAMPOS PRINCIPALES
    // ==================================================

    if (information.casUsername != null &&
        information.casUsername!.isNotEmpty) {
      updateData["casUsername"] =
          information.casUsername;
    }

    if (information.casPassword != null &&
        information.casPassword!.isNotEmpty) {
      updateData["casPassword"] =
          information.casPassword;
    }

    if (information.casDate != null &&
        information.casDate!.isNotEmpty) {
      updateData["casAppointmentDate"] =
          information.casDate;
    }

    if (information.casTime != null &&
        information.casTime!.isNotEmpty) {
      updateData["casAppointmentTime"] =
          information.casTime;
    }

    if (information.interviewDate != null &&
        information.interviewDate!.isNotEmpty) {
      updateData["interviewDate"] =
          information.interviewDate;
    }

    if (information.interviewTime != null &&
        information.interviewTime!.isNotEmpty) {
      updateData["interviewTime"] =
          information.interviewTime;
    }

    if (information.interviewLocation != null &&
        information.interviewLocation!.isNotEmpty) {
      updateData["interviewLocation"] =
          information.interviewLocation;
    }

    await docRef.update(updateData);
  }

  Future<void> updateCasAppointment({
    required String expedienteId,
    required String date,
    required String time,
    required String location,
  }) async {
    await _collection.doc(expedienteId).update({
      "casAppointmentDate": date,
      "casAppointmentTime": time,
      "casLocation": location,
      "updatedAt": Timestamp.now(),
    });
  }
}