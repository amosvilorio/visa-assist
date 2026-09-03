import 'package:flutter/material.dart';
import '../payment/mrv_upload_receipt_screen.dart';
import '../../services/expediente_service.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';
import '../../services/settings_service.dart';

class MrvPaymentScreen extends StatefulWidget {
  final Expediente expediente;

  const MrvPaymentScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<MrvPaymentScreen> createState() =>
      _MrvPaymentScreenState();
}

class _MrvPaymentScreenState
    extends State<MrvPaymentScreen> {
  final SettingsService _settingsService =
  SettingsService();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  double mrvPrice = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadMrvPrice();
  }

  // ============================================================
  // CARGAR TARIFA MRV
  // ============================================================

  Future<void> loadMrvPrice() async {
    try {
      final price =
      await _settingsService.getMrvPrice();

      if (!mounted) return;

      setState(() {
        mrvPrice = price;
        loading = false;
      });
    } catch (e) {
      debugPrint(
        "Error cargando tarifa MRV: $e",
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  // ============================================================
  // SOLICITAR MONTO EN RD$
  // ============================================================

  Future<void> _solicitarMontoRD({
    required Expediente expedienteActual,
  }) async {
    try {
      await _expedienteService.requestMrvDopAmount(
        expedienteId: expedienteActual.id,
        mrvUsdAmount: mrvPrice,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Solicitud enviada. Visa Assist te indicará el monto en pesos dominicanos.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint(
        "Error solicitando monto MRV: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No se pudo enviar la solicitud. Intenta nuevamente.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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

    return StreamBuilder<Expediente?>(
      stream: _expedienteService.watchExpediente(
        widget.expediente.id,
      ),
      builder: (
          context,
          snapshot,
          ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                "No se pudo cargar el expediente.",
              ),
            ),
          );
        }

        final expedienteActual =
            snapshot.data ?? widget.expediente;

        final String mrvStatus =
            expedienteActual.mrvStatus;

        final String mrvRequestStatus =
            expedienteActual.mrvAmountRequestStatus;

        return Scaffold(
          backgroundColor:
          AppColors.background,

          appBar: AppBar(
            title: const Text(
              "Pago de tarifa MRV",
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
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // ==================================================
                // TÍTULO
                // ==================================================

                const Text(
                  "Pago de la tarifa MRV",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Visa Assist gestionará el pago de la "
                      "tarifa oficial correspondiente a tu "
                      "solicitud de visa.",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color:
                    AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // ESTADO
                // ==================================================

                _sectionCard(
                  title: "Estado del proceso",
                  child: _statusCard(
                    mrvStatus,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TARIFA OFICIAL EN DÓLARES
                // ==================================================

                _sectionCard(
                  title: "💰 Tarifa oficial",
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Tarifa oficial",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "US\$${mrvPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Este monto corresponde a la tarifa "
                            "oficial configurada para tu tipo "
                            "de solicitud.",
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color:
                          Colors.amber.shade50,

                          borderRadius:
                          BorderRadius.circular(14),
                        ),

                        child: const Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Icon(
                              Icons.info_outline,
                              color:
                              Colors.orange,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "La tarifa oficial puede cambiar "
                                    "en cualquier momento si la Embajada "
                                    "de los Estados Unidos modifica el "
                                    "monto vigente.",
                                style: TextStyle(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // SOLICITUD DEL MONTO EN RD$
                // ==================================================

                _sectionCard(
                  title:
                  "🇩🇴 Monto en pesos dominicanos",
                  child: _mrvAmountSection(
                    expedienteActual:
                    expedienteActual,

                    mrvRequestStatus:
                    mrvRequestStatus,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // CÓMO FUNCIONA
                // ==================================================

                _sectionCard(
                  title: "¿Cómo funciona?",
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      _step(
                        number: "1",
                        title:
                        "Solicitas el monto en RD\$",
                        text:
                        "Presionas el botón para solicitar "
                            "el equivalente en pesos dominicanos "
                            "correspondiente a la tarifa oficial.",
                      ),

                      _step(
                        number: "2",
                        title:
                        "Visa Assist calcula el monto",
                        text:
                        "Nuestro equipo verificará la tasa "
                            "utilizada para ese día y te indicará "
                            "el monto que debes entregar.",
                      ),

                      _step(
                        number: "3",
                        title:
                        "Realizas el depósito",
                        text:
                        "Una vez recibido el monto en RD\$, "
                            "realizas el depósito o transferencia "
                            "a Visa Assist.",
                      ),

                      _step(
                        number: "4",
                        title:
                        "Envías el comprobante",
                        text:
                        "Subes desde la aplicación el "
                            "comprobante del depósito o "
                            "transferencia.",
                      ),

                      _step(
                        number: "5",
                        title:
                        "Verificamos los fondos",
                        text:
                        "Nuestro equipo revisará el "
                            "comprobante y confirmará la "
                            "recepción del dinero.",
                      ),

                      _step(
                        number: "6",
                        title:
                        "Gestionamos el pago oficial",
                        text:
                        "Una vez confirmados los fondos, "
                            "Visa Assist gestionará el pago "
                            "oficial de la tarifa MRV.",
                      ),

                      _step(
                        number: "7",
                        title:
                        "Confirmamos el pago",
                        text:
                        "Te notificaremos cuando el pago "
                            "oficial haya sido confirmado y "
                            "podamos continuar con la siguiente "
                            "etapa.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // IMPORTANTE
                // ==================================================

                Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color:
                    Colors.amber.shade50,

                    borderRadius:
                    BorderRadius.circular(16),
                  ),

                  child: const Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Icon(
                        Icons.info_outline,
                        color:
                        Colors.orange,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          "Importante: la tarifa MRV es un "
                              "pago oficial del proceso de visa "
                              "y no está incluida en el costo "
                              "del servicio Visa Assist.",
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // ESTADOS DEL PAGO
                // ==================================================

                if (mrvStatus ==
                    "En revisión") ...[

                  _messageCard(
                    icon:
                    Icons.hourglass_top,

                    title:
                    "Comprobante en revisión",

                    message:
                    "Hemos recibido tu comprobante. "
                        "Nuestro equipo está verificando "
                        "la recepción de los fondos.",

                    color:
                    Colors.orange,
                  ),

                  const SizedBox(height: 20),
                ],

                if (mrvStatus ==
                    "Pago MRV confirmado") ...[

                  _messageCard(
                    icon:
                    Icons.check_circle,

                    title:
                    "Pago MRV confirmado",

                    message:
                    "Hemos confirmado la recepción de los fondos "
                        "y el pago oficial de la tarifa MRV. "
                        "No necesitas realizar otro pago.",

                    color:
                    Colors.green,
                  ),

                  const SizedBox(height: 20),
                ],

                if (mrvStatus ==
                    "En proceso") ...[

                  _messageCard(
                    icon:
                    Icons.sync,

                    title:
                    "Pago en proceso",

                    message:
                    "Visa Assist está gestionando "
                        "el pago oficial de la tarifa MRV.",

                    color:
                    Colors.blue,
                  ),

                  const SizedBox(height: 20),
                ],

                if (mrvStatus ==
                    "Pagado") ...[

                  _messageCard(
                    icon:
                    Icons.check_circle,

                    title:
                    "Tarifa MRV pagada",

                    message:
                    "El pago de la tarifa oficial ha "
                        "sido confirmado correctamente. "
                        "Puedes continuar con la siguiente "
                        "etapa del proceso.",

                    color:
                    Colors.green,
                  ),

                  const SizedBox(height: 20),
                ],

                if (mrvStatus ==
                    "Rechazado") ...[

                  _messageCard(
                    icon:
                    Icons.error_outline,

                    title:
                    "Comprobante rechazado",

                    message:
                    "El comprobante enviado no pudo "
                        "ser verificado. Revisa la información "
                        "y envía nuevamente el comprobante.",

                    color:
                    Colors.red,
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child:
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.upload_file,
                      ),

                      label: const Text(
                        "ENVIAR NUEVO COMPROBANTE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Aquí conectaremos nuevamente "
                                  "la carga del comprobante.",
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SECCIÓN MONTO RD$
  // ============================================================

  Widget _mrvAmountSection({
    required Expediente expedienteActual,
    required String mrvRequestStatus,
  }) {

    // ----------------------------------------------------------
    // PAGO MRV CONFIRMADO
    // ----------------------------------------------------------

    if (expedienteActual.mrvStatus ==
        "Pago MRV confirmado") {

      return _messageCard(
        icon: Icons.check_circle,

        title: "Pago MRV confirmado",

        message:
        "Hemos confirmado la recepción de los fondos. "
            "Visa Assist continuará con la gestión del "
            "pago oficial de la tarifa MRV. "
            "No es necesario realizar otro pago.",

        color: Colors.green,
      );
    }
    // ----------------------------------------------------------
    // SIN SOLICITUD
    // ----------------------------------------------------------

    if (mrvRequestStatus == "none" ||
        mrvRequestStatus.isEmpty) {
      return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            "Para conocer el monto exacto en pesos "
                "dominicanos que debes entregar, solicita "
                "el cálculo correspondiente a la tarifa "
                "oficial de hoy.",
            style: TextStyle(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 55,

            child:
            ElevatedButton.icon(
              icon: const Icon(
                Icons.request_quote,
              ),

              label: const Text(
                "SOLICITAR MONTO EN RD\$",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              onPressed: () {
                _solicitarMontoRD(
                  expedienteActual:
                  expedienteActual,
                );
              },
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------------------
    // SOLICITUD PENDIENTE
    // ----------------------------------------------------------

    if (mrvRequestStatus == "pending") {
      return _messageCard(
        icon:
        Icons.hourglass_top,

        title:
        "Solicitud enviada",

        message:
        "Hemos recibido tu solicitud. "
            "Nuestro equipo está calculando el "
            "monto en pesos dominicanos que "
            "deberás entregar.",

        color:
        Colors.orange,
      );
    }

    // ----------------------------------------------------------
    // MONTO RESPONDIDO
    // ----------------------------------------------------------

    if (mrvRequestStatus == "responded") {
      return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            "Monto confirmado por Visa Assist",
            style: TextStyle(
              fontSize: 15,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            expedienteActual.mrvDopAmount !=
                null
                ? "RD\$${expedienteActual.mrvDopAmount!.toStringAsFixed(2)}"
                : "Pendiente",
            style: const TextStyle(
              fontSize: 32,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.primary,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Este es el monto en pesos dominicanos "
                "que debes entregar a Visa Assist para "
                "la gestión del pago oficial.",
            style: TextStyle(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding:
            const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color:
              Colors.amber.shade50,

              borderRadius:
              BorderRadius.circular(14),
            ),

            child: const Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Icon(
                  Icons.info_outline,
                  color:
                  Colors.orange,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "El monto en pesos corresponde al "
                        "cálculo realizado para la solicitud "
                        "y puede depender de la tasa utilizada "
                        "en el momento de la gestión.",
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 55,

            child:
            ElevatedButton.icon(
              icon: const Icon(
                Icons.upload_file,
              ),

              label: const Text(
                "ENVIAR COMPROBANTE DE DEPÓSITO",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              onPressed: () {
                final montoMrv = expedienteActual.mrvDopAmount;

                if (montoMrv == null || montoMrv <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "El monto de la tarifa MRV todavía no está disponible. "
                            "Espera a que Visa Assist confirme el monto.",
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );

                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MrvUploadReceiptScreen(
                      expedienteId: expedienteActual.id,
                      bankId: "mrv",
                      bankName: "Visa Assist",
                      amount: montoMrv,
                      currency: "RD\$",
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // ----------------------------------------------------------
    // ESTADO DESCONOCIDO
    // ----------------------------------------------------------

    return _messageCard(
      icon:
      Icons.hourglass_empty,

      title:
      "Solicitud en proceso",

      message:
      "Tu solicitud del monto en pesos "
          "dominicanos está siendo procesada.",

      color:
      Colors.orange,
    );
  }

  // ============================================================
  // TARJETA
  // ============================================================

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 3,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            child,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ESTADO
  // ============================================================

  Widget _statusCard(
      String status,
      ) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case "En revisión":
        color = Colors.orange;
        icon =
            Icons.hourglass_top;
        text =
        "Comprobante en revisión";
        break;

      case "Pago MRV confirmado":
        color = Colors.green;
        icon =
            Icons.check_circle;
        text =
        "Pago MRV confirmado";
        break;

      case "En proceso":
        color = Colors.blue;
        icon =
            Icons.sync;
        text =
        "Pago oficial en proceso";
        break;

      case "Pagado":
        color = Colors.green;
        icon =
            Icons.check_circle;
        text =
        "Tarifa MRV pagada";
        break;

      case "Rechazado":
        color = Colors.red;
        icon =
            Icons.error_outline;
        text =
        "Comprobante rechazado";
        break;

      default:
        color = Colors.orange;
        icon =
            Icons.pending;
        text =
        "Pago pendiente";
    }

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
        color.withOpacity(0.10),

        borderRadius:
        BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color:
            color,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,

              style: TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.bold,
                color:
                color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PASO
  // ============================================================

  Widget _step({
    required String number,
    required String title,
    required String text,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          CircleAvatar(
            radius: 15,

            backgroundColor:
            AppColors.primary,

            child: Text(
              number,

              style:
              const TextStyle(
                color:
                Colors.white,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  text,

                  style:
                  const TextStyle(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENSAJE DE ESTADO
  // ============================================================

  Widget _messageCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
        color.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          color.withOpacity(0.25),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color:
            color,
            size: 28,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    color,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  message,

                  style:
                  const TextStyle(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}