import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    final collection = _db.collection('evaluation_questions');

    final existing = await collection.limit(1).get();

    if (existing.docs.isNotEmpty) {
      return;
    }

    // =====================================================
    // BLOQUE 1
    // SITUACIÓN PERSONAL
    // =====================================================

    await collection.doc("q1").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 1,
      "blockName": "Situación Personal",
      "isPremium": false,
      "order": 1,
      "category": "family",
      "question": "¿Cuál es tu estado civil?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Soltero(a)",
        "Casado(a)",
        "Unión libre",
        "Divorciado(a)",
        "Viudo(a)"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await collection.doc("q2").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 1,
      "blockName": "Situación Personal",
      "isPremium": false,
      "order": 2,
      "category": "family",
      "question": "¿Tienes hijos?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Sí",
        "No"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await collection.doc("q3").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 1,
      "blockName": "Situación Personal",
      "isPremium": false,
      "order": 3,
      "category": "education",
      "question": "¿Cuál es tu nivel académico más alto alcanzado?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Primaria",
        "Secundaria",
        "Técnico",
        "Universitario",
        "Postgrado"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // =====================================================
    // BLOQUE 2
    // ESTABILIDAD LABORAL Y ECONÓMICA
    // =====================================================

    await collection.doc("q4").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 2,
      "blockName": "Estabilidad Laboral y Económica",
      "isPremium": false,
      "order": 4,
      "category": "employment",
      "question": "¿Cuál es tu situación laboral actual?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Empleado",
        "Independiente",
        "Empresario",
        "Jubilado",
        "No trabajo actualmente"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await collection.doc("q5").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 2,
      "blockName": "Estabilidad Laboral y Económica",
      "isPremium": false,
      "order": 5,
      "category": "employment",
      "question": "¿Desde hace cuánto tiempo tienes tu ocupación actual?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Menos de 6 meses",
        "De 6 meses a 1 año",
        "De 1 a 3 años",
        "Más de 3 años"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await collection.doc("q6").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 2,
      "blockName": "Estabilidad Laboral y Económica",
      "isPremium": false,
      "order": 6,
      "category": "income",
      "question": "¿Cuál es tu ingreso mensual aproximado?",
      "type": "number",
      "required": true,
      "affectsProfile": true,
      "options": [],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // =====================================================
    // BLOQUE 3
    // HISTORIAL MIGRATORIO
    // =====================================================

    await collection.doc("q7").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 3,
      "blockName": "Historial Migratorio",
      "isPremium": false,
      "order": 7,
      "category": "travel_history",
      "question": "¿Has viajado anteriormente fuera de tu país?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Nunca",
        "Una vez",
        "Varias veces"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    await collection.doc("q8").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 3,
      "blockName": "Historial Migratorio",
      "isPremium": false,
      "order": 8,
      "category": "visa_history",
      "question": "¿Alguna vez te han negado una visa?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Sí",
        "No"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // =====================================================
    // BLOQUE 4
    // VÍNCULOS CON TU PAÍS
    // =====================================================

    await collection.doc("q9").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 4,
      "blockName": "Vínculos con tu País",
      "isPremium": false,
      "order": 9,
      "category": "assets",
      "question": "¿Cuáles de los siguientes bienes posees?",
      "type": "checkbox",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Vivienda",
        "Vehículo",
        "Terreno",
        "Negocio",
        "Ninguno"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });

    // =====================================================
    // BLOQUE 5
    // OBJETIVO DEL VIAJE
    // =====================================================

    await collection.doc("q10").set({
      "countryCode": "usa",
      "visaType": "all",
      "block": 5,
      "blockName": "Objetivo del Viaje",
      "isPremium": false,
      "order": 10,
      "category": "travel_purpose",
      "question": "¿Cuál es el motivo principal de tu viaje?",
      "type": "radio",
      "required": true,
      "affectsProfile": true,
      "options": [
        "Turismo",
        "Negocios",
        "Estudios",
        "Trabajo",
        "Visita Familiar",
        "Tratamiento Médico",
        "Otro"
      ],
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}