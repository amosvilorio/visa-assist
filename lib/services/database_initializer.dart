import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseInitializer {
  DatabaseInitializer._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await _createSettings();

    await _createCountries();

    await _createVisaTypes();
  }

  //==================================================
  // SETTINGS
  //==================================================

  static Future<void> _createSettings() async {
    final doc =
    _db.collection("settings").doc("app");

    if ((await doc.get()).exists) return;

    await doc.set({
      "companyName": "Visa Assist",

      "logo": "",

      "email": "",

      "phone": "",

      "whatsapp": "",

      "website": "",

      "facebook": "",

      "instagram": "",

      "currency": "DOP",

      "currencySymbol": "RD\$",

      "visaAssistPlusPrice": 0,

      "evaluationPrice": 2500,

      "initialQuestions": 10,

      "evaluationCurrency": "DOP",

      "evaluationCurrencySymbol": "RD\$",

      "promotionEnabled": false,

      "promotionPrice": 0,

      "promotionTitle": "",

      "promotionDescription": "",

      "evaluationTitle":
      "Evaluación Completa",

      "evaluationDescription":
      "Obtén un análisis completo de tu perfil migratorio.",

      "evaluationEnabled": true,

      "maintenanceMode": false,

      "visaRequestEnabled": true,

      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  //==================================================
  // PAISES
  //==================================================

  static Future<void> _createCountries() async {
    final countries =
    _db.collection("countries");

    final result =
    await countries.limit(1).get();

    if (result.docs.isNotEmpty) return;

    await countries.doc("usa").set({
      "name": "Estados Unidos",
      "code": "usa",
      "active": true,
      "createdAt":
      FieldValue.serverTimestamp(),
    });
  }

  //==================================================
  // TIPOS DE VISA
  //==================================================

  static Future<void> _createVisaTypes() async {
    final visas =
    _db.collection("visa_types");

    final result =
    await visas.limit(1).get();

    if (result.docs.isNotEmpty) return;

    await visas.doc("tourism").set({
      "name": "Turismo",
      "code": "b1_b2",
      "active": true,
      "createdAt":
      FieldValue.serverTimestamp(),
    });

    await visas.doc("student").set({
      "name": "Estudiante",
      "code": "f1",
      "active": true,
      "createdAt":
      FieldValue.serverTimestamp(),
    });

    await visas.doc("work").set({
      "name": "Trabajo",
      "code": "h1b",
      "active": true,
      "createdAt":
      FieldValue.serverTimestamp(),
    });
  }
}