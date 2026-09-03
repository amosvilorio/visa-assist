import 'package:flutter/material.dart';

import '../models/expediente.dart';
import 'expediente_service.dart';

class ProgressService {

  ProgressService._();

  static final ProgressService instance =
  ProgressService._();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  //--------------------------------------------------
  // OBTENER EXPEDIENTE ACTIVO
  //--------------------------------------------------

  Future<Expediente?> getActiveExpediente() async {
    return await _expedienteService.getActiveExpediente();
  }

  //--------------------------------------------------
  // GUARDAR PASO ACTUAL
  //--------------------------------------------------

  Future<void> saveStep({

    required String expedienteId,

    required int step,

  }) async {

    await _expedienteService.updateCurrentStep(

      expedienteId: expedienteId,

      step: step,

    );

  }

  //--------------------------------------------------
  // CONTINUAR SOLICITUD
  //--------------------------------------------------

  Future<int> getCurrentStep() async {

    final expediente =
    await _expedienteService.getActiveExpediente();

    if (expediente == null) {
      return 1;
    }

    return expediente.currentStep;

  }

  //--------------------------------------------------
  // EXISTE SOLICITUD
  //--------------------------------------------------

  Future<bool> hasActiveExpediente() async {

    final expediente =
    await _expedienteService.getActiveExpediente();

    return expediente != null;

  }

}