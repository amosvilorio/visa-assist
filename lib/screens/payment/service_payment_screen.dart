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
  double usdToDopRate = 0;

// La moneda de este servicio es USD.
  // No utilizamos la moneda global para no afectar
  // otros procesos como la evaluación.
  String currencySymbol = "US\$";

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

    usdToDopRate =
        double.tryParse(
          settings["usdToDopRate"]?.toString() ?? "",
        ) ??
            0;

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
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),
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
              "Realiza el pago de la tarifa oficial de la visa y el pago por contratar el servicio Visa Assist.",   style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------
            // COSTO TOTAL DEL SERVICIO
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
                      "Pago total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$currencySymbol ${servicePrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (usdToDopRate > 0) ...[
                      const SizedBox(height: 8),

                      Text(
                        "RD\$ ${(servicePrice * usdToDopRate).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    const Text(
                      "Pago único por el servicio Visa Assist.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
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
                      "Programación de la cita para foto y huellas",
                    ),

                    const SizedBox(height: 15),

                    buildIncludedItem(
                      "Programación de la cita consular",
                    ),

                    const SizedBox(height: 15),

                    buildIncludedItem(
                      "Pago de la tarifa oficial de la visa",
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
            // AVISO IMPORTANTE
            // --------------------------------------------------

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.amber.shade200,
                ),
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
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Aviso importante",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Text(
                    "El pago indicado incluye la contratación del servicio Visa Assist y el pago de la tarifa oficial de la visa vigente al momento de realizar el pago.",
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "En caso de que la Embajada de los Estados Unidos o las autoridades correspondientes modifiquen la tarifa oficial de la visa después de realizado el pago, el solicitante deberá cubrir el monto adicional correspondiente a la diferencia de la nueva tarifa.",
                    style: TextStyle(
                      height: 1.5,
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
                      builder: (_) =>
                          PaymentMethodScreen(
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