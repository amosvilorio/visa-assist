import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/settings_service.dart';
import 'upload_receipt_screen.dart';
import 'payment_pending_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String evaluationId;

  const PaymentScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final SettingsService _settingsService =
  SettingsService();

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  bool loading = true;

  Map<String, dynamic> settings = {};

  String paymentMethod = "transfer";

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  //============================================================
  // CARGAR CONFIGURACIÓN
  //============================================================

  Future<void> loadSettings() async {
    try {
      settings =
      await _settingsService.getSettings();

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint(
        'Error cargando configuración de pago: $e',
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  //============================================================
  // PROCESAR ESTADO DE LA EVALUACIÓN
  //============================================================

  void handleEvaluationStatus(
      BuildContext context,
      Map<String, dynamic> data,
      ) {
    final status =
        data['status'] ?? 'waiting_payment';

    final premiumUnlocked =
        data['premiumUnlocked'] == true;

    final premiumPaid =
        data['premiumPaid'] == true;

    final paymentReceipt =
    data['paymentReceipt'];

    final paymentReference =
    data['paymentReference'];

    final paymentDate =
    data['paymentDate'];

    final paymentSubmitted =
        status == 'payment_pending' ||
            (paymentReceipt != null &&
                paymentReceipt
                    .toString()
                    .trim()
                    .isNotEmpty) ||
            (paymentReference != null &&
                paymentReference
                    .toString()
                    .trim()
                    .isNotEmpty) ||
            paymentDate != null;

    //============================================================
    // PAGO APROBADO
    //============================================================

    if (premiumUnlocked && premiumPaid) {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          if (!context.mounted) return;

          Navigator.pop(context);
        },
      );

      return;
    }

    //============================================================
    // PAGO YA ENVIADO
    //============================================================

    if (paymentSubmitted &&
        !premiumUnlocked &&
        !premiumPaid) {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          if (!context.mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PaymentPendingScreen(
                    evaluationId:
                    widget.evaluationId,
                  ),
            ),
          );
        },
      );
    }
  }

  Widget buildIncludedItem(String text) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
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

    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: _db
          .collection('evaluations')
          .doc(widget.evaluationId)
          .snapshots(),

      builder: (context, snapshot) {
        //========================================================
        // CARGANDO EVALUACIÓN
        //========================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //========================================================
        // ERROR
        //========================================================

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Pago de Evaluación",
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No se pudo consultar el estado de la evaluación.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        //========================================================
        // DOCUMENTO NO EXISTE
        //========================================================

        if (!snapshot.hasData ||
            !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Pago de Evaluación",
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No se encontró la evaluación.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final data =
            snapshot.data!.data() ?? {};

        //========================================================
        // REVISAR ESTADO EN TIEMPO REAL
        //========================================================

        handleEvaluationStatus(
          context,
          data,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Pago de Evaluación",
            ),
            centerTitle: true,
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  const Center(
                    child: Icon(
                      Icons.workspace_premium,
                      size: 90,
                      color: Colors.amber,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      "Desbloquea la Evaluación Premium",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Realiza el pago para continuar con la evaluación completa y recibir un análisis profesional de tu perfil migratorio.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  //================================================
                  // PRECIO
                  //================================================

                  Card(
                    elevation: 5,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                        22,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Valor de la Evaluación",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "${settings["currencySymbol"] ?? "RD\$"} ${settings["evaluationPrice"] ?? 0}",
                            style:
                            const TextStyle(
                              fontSize: 38,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Selecciona el método de pago",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Card(
                    elevation: 3,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                    child:
                    RadioListTile<String>(
                      value: "transfer",
                      groupValue:
                      paymentMethod,
                      title: const Text(
                        "Transferencia o Depósito Bancario",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      subtitle:
                      const Text(
                        "Realiza una transferencia, sube el comprobante y un administrador aprobará tu pago.",
                      ),
                      secondary:
                      const Icon(
                        Icons.account_balance,
                        color: Colors.green,
                      ),
                      onChanged: (value) {
                        setState(() {
                          paymentMethod =
                          value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  //================================================
                  // CUENTAS BANCARIAS
                  //================================================

                  StreamBuilder<
                      QuerySnapshot<
                          Map<String,
                              dynamic>>>(
                    stream: _db
                        .collection("banks")
                        .where(
                      "active",
                      isEqualTo: true,
                    )
                        .snapshots(),

                    builder:
                        (context, snapshot) {
                      if (!snapshot
                          .hasData) {
                        return const SizedBox();
                      }

                      final banks =
                          snapshot.data!.docs;

                      if (banks.isEmpty) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            "Cuentas disponibles para el pago",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          ...banks.map(
                                (bank) {
                              final data =
                              bank.data();

                              return Card(
                                margin:
                                const EdgeInsets
                                    .only(
                                  bottom: 12,
                                ),
                                child:
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(
                                    15,
                                  ),
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        data[
                                        "bankName"],
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          18,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      Text(
                                        "Titular: ${data["accountHolder"]}",
                                      ),

                                      Text(
                                        "Cuenta: ${data["accountNumber"]}",
                                      ),

                                      Text(
                                        "Tipo: ${data["accountType"]}",
                                      ),

                                      Text(
                                        "Moneda: ${data["currency"]}",
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      );
                    },
                  ),

                  //================================================
                  // AVISO
                  //================================================

                  Container(
                    padding:
                    const EdgeInsets.all(
                      18,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.amber.shade50,
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color: Colors.amber,
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color:
                          Colors.orange,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Después de realizar el pago deberás subir el comprobante. Una vez aprobado por un administrador, podrás continuar desde la pregunta 11 sin perder tu progreso.",
                            style:
                            TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  //================================================
                  // VOLVER
                  //================================================

                  SizedBox(
                    width:
                    double.infinity,
                    height: 55,
                    child:
                    OutlinedButton.icon(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      label: const Text(
                        "VOLVER",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //================================================
                  // CONTINUAR
                  //================================================

                  SizedBox(
                    width:
                    double.infinity,
                    height: 58,
                    child:
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                      label: const Text(
                        "CONTINUAR",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (paymentMethod ==
                            "transfer") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UploadReceiptScreen(
                                    evaluationId:
                                    widget
                                        .evaluationId,
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}