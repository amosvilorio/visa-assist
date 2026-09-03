import 'package:cloud_firestore/cloud_firestore.dart';


class SettingsService {

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _settings =>
      _db.collection("settings").doc("general");

  //==========================================
  // OBTENER CONFIGURACIÓN GENERAL
  //==========================================

  Future<Map<String, dynamic>> getSettings() async {

    final doc =
    await _settings.get();

    if (!doc.exists) {

      return {};

    }

    return doc.data() ?? {};

  }


  //==========================================
  // PRECIOS
  //==========================================


  Future<double> getEvaluationPrice() async {

    final settings =
    await getSettings();


    return (settings["evaluationPrice"] ?? 0)
        .toDouble();

  }



  Future<double> getServicePrice() async {

    final settings =
    await getSettings();


    return (settings["servicePrice"] ?? 0)
        .toDouble();

  }



  Future<double> getMrvPrice() async {

    final settings =
    await getSettings();


    return (settings["mrvPrice"] ?? 0)
        .toDouble();

  }



  //==========================================
  // ESTADOS DE SERVICIOS
  //==========================================


  Future<bool> isEvaluationEnabled() async {

    final settings =
    await getSettings();


    return settings["evaluationEnabled"] ?? true;

  }



  Future<bool> isServiceEnabled() async {

    final settings =
    await getSettings();


    return settings["serviceEnabled"] ?? true;

  }



  Future<bool> isMrvEnabled() async {

    final settings =
    await getSettings();


    return settings["mrvEnabled"] ?? true;

  }



  //==========================================
  // MONEDA
  //==========================================


  Future<String> getCurrencySymbol() async {

    final settings =
    await getSettings();


    return settings["currencySymbol"] ?? "RD\$";

  }



  Future<String> getCurrency() async {

    final settings =
    await getSettings();


    return settings["currency"] ?? "DOP";

  }



  //==========================================
  // ESCUCHAR CAMBIOS
  //==========================================


  Stream<Map<String, dynamic>> watchSettings() {

    return _settings.snapshots()
        .map((doc) {

      if (!doc.exists) {

        return {};

      }


      return doc.data() ?? {};

    });

  }



  //==========================================
  // ACTUALIZAR CONFIGURACIÓN
  //==========================================


  Future<void> updateSettings(
      Map<String, dynamic> data,
      ) async {

    await _settings.set(

      data,

      SetOptions(
        merge: true,
      ),

    );

  }



  //==========================================
  // ACTUALIZAR UN SOLO CAMPO
  //==========================================


  Future<void> updateField({

    required String field,

    required dynamic value,

  }) async {


    await _settings.set(

      {

        field: value,

      },

      SetOptions(
        merge: true,
      ),

    );

  }

}