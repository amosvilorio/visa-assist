import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/expediente_service.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';
import 'dart:async';

class VisaAssistProcessScreen extends StatefulWidget {
  final Expediente expediente;

  const VisaAssistProcessScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<VisaAssistProcessScreen> createState() =>
      _VisaAssistProcessScreenState();
}

class _VisaAssistProcessScreenState
    extends State<VisaAssistProcessScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  bool _savingResult = false;

  late Expediente _currentExpediente;

  StreamSubscription<Expediente?>? _expedienteSubscription;

  @override
  void initState() {
    super.initState();

    _currentExpediente = widget.expediente;

    _expedienteSubscription =
        _expedienteService
            .watchExpediente(widget.expediente.id)
            .listen((expedienteActualizado) {

          if (!mounted || expedienteActualizado == null) {
            return;
          }

          setState(() {
            _currentExpediente = expedienteActualizado;
          });
        });
  }

  @override
  void dispose() {
    _expedienteSubscription?.cancel();
    super.dispose();
  }


  bool _canRegisterInterviewResult() {
    final interviewDate =
        _currentExpediente.visaProcessInformation?.interviewDate;

    if (interviewDate == null ||
        interviewDate.trim().isEmpty ||
        interviewDate.toLowerCase() == "pendiente") {
      return false;
    }

    DateTime? fechaCita;

    // Formato yyyy-MM-dd
    fechaCita = DateTime.tryParse(interviewDate);

    // Formato dd/MM/yyyy o dd-MM-yyyy
    if (fechaCita == null) {
      final parts = interviewDate.split(
        RegExp(r'[/\-]'),
      );

      if (parts.length == 3) {
        final dia = int.tryParse(parts[0]);
        final mes = int.tryParse(parts[1]);
        final anio = int.tryParse(parts[2]);

        if (dia != null &&
            mes != null &&
            anio != null) {
          fechaCita = DateTime(
            anio,
            mes,
            dia,
          );
        }
      }
    }

    if (fechaCita == null) {
      return false;
    }

    final ahora = DateTime.now();

    final hoy = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
    );

    final cita = DateTime(
      fechaCita.year,
      fechaCita.month,
      fechaCita.day,
    );

    return !hoy.isBefore(cita);
  }

  Future<void> _registerInterviewResult() async {
    String? selectedResult;
    final TextEditingController commentController =
    TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Resultado de la entrevista",
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Seleccione el resultado recibido:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    RadioListTile<String>(
                      value: "Aprobada",
                      groupValue: selectedResult,
                      title: const Text(
                        "Visa aprobada",
                      ),
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedResult = value;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      value: "Denegada",
                      groupValue: selectedResult,
                      title: const Text(
                        "Visa denegada",
                      ),
                      activeColor: Colors.red,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedResult = value;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      value: "Proceso administrativo",
                      groupValue: selectedResult,
                      title: const Text(
                        "Proceso administrativo",
                      ),
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedResult = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Comentario (opcional)",
                        hintText:
                        "Agregue información adicional...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  onPressed: selectedResult == null
                      ? null
                      : () {
                    Navigator.pop(
                      dialogContext,
                      selectedResult,
                    );
                  },
                  child: const Text(
                    "Guardar resultado",
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) {
      commentController.dispose();
      return;
    }

    setState(() {
      _savingResult = true;
    });

    try {
      await _expedienteService.saveInterviewResult(
        expedienteId: widget.expediente.id,
        result: result,
        comment: commentController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _savingResult = false;
      });

      if (result == "Aprobada" ||
          result == "Denegada") {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Resultado guardado. El expediente ha sido completado y trasladado al historial.",
            ),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Resultado guardado. El expediente continúa activo por encontrarse en proceso administrativo.",
            ),
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      setState(() {
        _savingResult = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo guardar el resultado: $e",
          ),
        ),
      );

    } finally {
      commentController.dispose();
    }
  }

  // ============================================================
  // VERIFICAR SI YA PASÓ LA FECHA DEL CAS
  // ============================================================

  bool _casYaPaso() {
    final fechaCas =
    _currentExpediente.casAppointmentDate.trim();

    if (fechaCas.isEmpty ||
        fechaCas.toLowerCase() == "pendiente") {
      return false;
    }

    DateTime? fechaCita;

    // Formato yyyy-MM-dd
    fechaCita = DateTime.tryParse(fechaCas);

    // Formato dd/MM/yyyy o dd-MM-yyyy
    if (fechaCita == null) {
      final partes = fechaCas.split(
        RegExp(r'[/\-]'),
      );

      if (partes.length == 3) {
        final dia = int.tryParse(partes[0]);
        final mes = int.tryParse(partes[1]);
        final anio = int.tryParse(partes[2]);

        if (dia != null &&
            mes != null &&
            anio != null) {
          fechaCita = DateTime(
            anio,
            mes,
            dia,
          );
        }
      }
    }

    if (fechaCita == null) {
      return false;
    }

    final ahora = DateTime.now();

    final hoy = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
    );

    final cita = DateTime(
      fechaCita.year,
      fechaCita.month,
      fechaCita.day,
    );

    return hoy.isAfter(cita);
  }


  // ============================================================
  // UBICACIONES FIJAS
  // ============================================================

  static const String _casAddress =
      "Av. John F. Kennedy, esquina Paseo Los Aviadores, "
      "Plaza Sambil, Nivel Kennedy, Local K-86, "
      "Santo Domingo, República Dominicana";

  static const String _consularAddress =
      "Av. República de Colombia #57, "
      "Santo Domingo, República Dominicana";

  // ============================================================
  // ABRIR GOOGLE MAPS
  // ============================================================

  Future<void> _abrirGoogleMaps({
    required String query,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query="
          "${Uri.encodeComponent(query)}",
    );

    try {
      final bool abierto = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto) {
        throw Exception("No se pudo abrir Google Maps");
      }
    } catch (e) {
      debugPrint("Error al abrir Google Maps: $e");
    }
  }

  // ============================================================
  // ABRIR DOCUMENTO DS-160
  // ============================================================

  Future<void> _abrirDs160(
      BuildContext context,
      String url,
      ) async {
    final Uri documentoUrl = Uri.parse(url);

    try {
      final bool abierto = await launchUrl(
        documentoUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No se pudo abrir el documento DS-160.",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error al abrir DS-160: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No se pudo abrir el documento DS-160.",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expediente = _currentExpediente;
    final visaInfo = expediente.visaProcessInformation;

    final ds160Disponible =
        visaInfo?.ds160PdfUrl?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Proceso Visa Assist",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // DS-160
            // ==================================================

            // ==================================================
// AVISO DE COMUNICACIÓN CON EL CLIENTE
// ==================================================

            if (!ds160Disponible)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.blue.shade200,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.blue.shade700,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mantente atento a nuestros mensajes",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Durante la preparación de tu solicitud, "
                              "nuestro equipo podría solicitarte información "
                              "o documentos adicionales cuando sean necesarios. "
                              "Podemos contactarte por WhatsApp o mediante "
                              "la mensajería de la aplicación.",
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "📌 Revisa tus mensajes periódicamente para evitar "
                              "retrasos en tu proceso.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _sectionCard(
              title: "📄 Formulario DS-160",
              children: [

                Text(
                  visaInfo?.ds160PdfUrl != null &&
                      visaInfo!.ds160PdfUrl!.isNotEmpty
                      ? "Documento disponible"
                      : "Aún no disponible",
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),
                    label: const Text(
                      "VER DOCUMENTO DS-160",
                    ),
                    onPressed:
                    visaInfo?.ds160PdfUrl == null ||
                        visaInfo!.ds160PdfUrl!.isEmpty
                        ? null
                        : () {
                      _abrirDs160(
                        context,
                        visaInfo.ds160PdfUrl!,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // PERFIL CAS
            // ==================================================

            _sectionCard(
              title: "🔐 Perfil CAS",
              children: [

                _item(
                  "Usuario",
                  visaInfo?.casUsername ?? "Pendiente",
                ),

                _item(
                  "Contraseña",
                  visaInfo?.casPassword ?? "Pendiente",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CITA CAS
            // ==================================================

            _sectionCard(
              title: "📸 Cita CAS (Huella y fotografía)",
              pasoActual: !_casYaPaso(),
              children: [

                _item(
                  "Fecha",
                  visaInfo?.casDate ?? "Pendiente",
                ),

                _item(
                  "Hora",
                  visaInfo?.casTime ?? "Pendiente",
                ),

                _item(
                  "Lugar",
                  _casAddress,
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.location_on,
                    ),
                    label: const Text(
                      "VER UBICACIÓN EN GOOGLE MAPS",
                    ),
                    onPressed: () {
                      _abrirGoogleMaps(
                        query:
                        "Centro de Atención de Visas VAC "
                            "Sambil Santo Domingo",
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // ENTREVISTA CONSULAR
            // ==================================================

            _sectionCard(
              title: "🏛 Entrevista Consular",
              pasoActual: _casYaPaso(),
              children: [

                _item(
                  "Fecha",
                  visaInfo?.interviewDate ?? "Pendiente",
                ),

                _item(
                  "Hora",
                  visaInfo?.interviewTime ?? "Pendiente",
                ),

                _item(
                  "Lugar",
                  _consularAddress,
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.location_on,
                    ),
                    label: const Text(
                      "VER UBICACIÓN EN GOOGLE MAPS",
                    ),
                    onPressed: () {
                      _abrirGoogleMaps(
                        query:
                        "Embajada de los Estados Unidos "
                            "Santo Domingo Av. República de Colombia 57",
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // RESULTADO DE LA ENTREVISTA
            // ==================================================

            _sectionCard(
              title: "📝 Resultado de la entrevista",
              children: [

                if (expediente.finalDecision.isEmpty) ...[

                  const Text(
                    "Después de asistir a su entrevista consular, "
                        "registre aquí el resultado que recibió.",
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (!_canRegisterInterviewResult())
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                        BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "El registro del resultado estará "
                                  "disponible a partir del día de su "
                                  "entrevista consular. Podrá registrarlo "
                                  "ese mismo día o cualquier día posterior.",
                              style: TextStyle(
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        _canRegisterInterviewResult()
                            ? Icons.assignment_turned_in
                            : Icons.lock_outline,
                      ),
                      label: Text(
                        _canRegisterInterviewResult()
                            ? "REGISTRAR RESULTADO"
                            : "RESULTADO BLOQUEADO",
                      ),
                      onPressed:
                      _savingResult ||
                          !_canRegisterInterviewResult()
                          ? null
                          : _registerInterviewResult,
                    ),
                  ),
                ] else ...[

                  _item(
                    "Resultado",
                    expediente.finalDecision,
                  ),

                  const SizedBox(height: 10),

                  if (expediente.finalDecision ==
                      "Aprobada")
                    const Text(
                      "🎉 ¡Felicidades! El resultado de su "
                          "entrevista fue registrado como aprobado.",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),

                  if (expediente.finalDecision ==
                      "Denegada")
                    const Text(
                      "El resultado de su entrevista ha sido "
                          "registrado como denegado.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),

                  if (expediente.finalDecision ==
                      "Proceso administrativo")
                    const Text(
                      "Su solicitud continúa en proceso "
                          "administrativo. El expediente permanecerá "
                          "activo mientras este proceso continúe.",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                ],
              ],
            ),

            // ==================================================
            // ESPACIO FINAL
            // ==================================================

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TARJETA
  // ============================================================

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
    bool pasoActual = false,
  }) {
    return Card(
      elevation: pasoActual ? 6 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: pasoActual
            ? BorderSide(
          color: AppColors.primary,
          width: 2,
        )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (pasoActual)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "PASO ACTUAL",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...children,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ELEMENTO DE INFORMACIÓN
  // ============================================================

  Widget _item(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 100,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }
}