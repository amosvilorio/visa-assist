import 'package:flutter/material.dart';

import 'payment_method_screen.dart';
import '../../utils/app_colors.dart';
import '../../services/settings_service.dart';

class ServicePaymentScreen extends StatefulWidget {

  final String expedienteId;

  const ServicePaymentScreen({
    super.key,
    required this.expedienteId,
  });

  @override
  State<ServicePaymentScreen> createState() =>
      _ServicePaymentScreenState();
}

class _ServicePaymentScreenState
    extends State<ServicePaymentScreen> {
  final SettingsService _settingsService =
  SettingsService();

  double servicePrice = 0;

  String currencySymbol = "RD\$";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadServicePrice();
  }

  Future<void> loadServicePrice() async {
    final settings =
    await _settingsService.getSettings();

    servicePrice =
        (settings["servicePrice"] ?? 0).toDouble();

    currencySymbol =
        settings["currencySymbol"] ?? "RD\$";

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Widget buildIncludedItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Contratar Servicio",
        ),
      ),

        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              35,
            ),
            children: [
          const Text(
            "PASO 18 DE 18",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Contratar Servicio Visa Assist",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Para que nuestro equipo comience a trabajar en tu expediente, debes contratar el servicio Visa Assist.",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 25),

          // --------------------------------------------------
          // COSTO DEL SERVICIO
          // --------------------------------------------------

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Costo del servicio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "$currencySymbol ${servicePrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // --------------------------------------------------
          // LO QUE INCLUYE
          // --------------------------------------------------

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lo que incluye el servicio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  buildIncludedItem(
                    "Revisión completa de tu expediente",
                  ),

                  const SizedBox(height: 15),

                  buildIncludedItem(
                    "Llenado profesional del formulario DS-160",
                  ),

                  const SizedBox(height: 15),

                  buildIncludedItem(
                    "Creación y configuración del perfil CAS",
                  ),

                  const SizedBox(height: 15),

                  buildIncludedItem(
                    "Gestión y creación de la cita para foto y huellas",
                  ),

                  const SizedBox(height: 15),

                  buildIncludedItem(
                    "Gestión y creación de la cita consular",
                  ),

                  const SizedBox(height: 15),

                  buildIncludedItem(
                    "Seguimiento y asesoría durante el proceso",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // --------------------------------------------------
          // AVISO SOBRE PAGOS OFICIALES
          // --------------------------------------------------

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Importante",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  "El pago indicado corresponde únicamente al servicio Visa Assist. Las tarifas, impuestos y pagos oficiales del proceso de visa no están incluidos y deberán ser pagados por el solicitante cuando corresponda.",

                  style: TextStyle(
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Una vez realizado el pago oficial correspondiente, nuestro equipo gestionará la creación de la cita para foto y huellas y la cita consular.",

                  style: TextStyle(
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // --------------------------------------------------
          // CONTINUAR AL PAGO
          // --------------------------------------------------

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.payment,
              ),

              label: const Text(
                "CONTINUAR AL PAGO",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentMethodScreen(
                      paymentType: "service",
                      paymentTitle:
                      "Expediente Visa Assist",
                      amount: servicePrice,
                      currencySymbol:
                      currencySymbol,
                      expedienteId:
                      widget.expedienteId,
                    ),
                  ),
                );
              },
            ),
          ),

              const SizedBox(height: 20),
            ],
          ),
        ),
    );
  }
}