import 'package:flutter/material.dart';

import '../../../models/expediente.dart';
import '../../../services/expediente_service.dart';
import '../../../utils/app_colors.dart';

class MrvRequestsScreen extends StatefulWidget {
  const MrvRequestsScreen({
    super.key,
  });

  @override
  State<MrvRequestsScreen> createState() =>
      _MrvRequestsScreenState();
}

class _MrvRequestsScreenState
    extends State<MrvRequestsScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final Map<String, TextEditingController>
  _controllers = {};

  @override
  void dispose() {
    for (final controller
    in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  TextEditingController _getController(
      String expedienteId) {

    if (!_controllers.containsKey(
        expedienteId)) {
      _controllers[expedienteId] =
          TextEditingController();
    }

    return _controllers[expedienteId]!;
  }

  Future<void> _confirmarMonto(
      Expediente expediente) async {

    final controller =
    _getController(expediente.id);

    final text =
    controller.text.trim();

    final amount =
    double.tryParse(text);

    if (amount == null ||
        amount <= 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Introduce un monto válido en pesos dominicanos.",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {

      await _expedienteService.setMrvDopAmount(
        expedienteId:
        expediente.id,
        dopAmount:
        amount,
      );

      controller.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Monto enviado correctamente al cliente.",
          ),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {

      debugPrint(
        "Error confirmando monto MRV: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "No se pudo enviar el monto al cliente.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        title: const Text(
          "Solicitudes MRV",
        ),

        centerTitle: true,
      ),

      body: StreamBuilder<List<Expediente>>(

        stream:
        _expedienteService
            .pendingMrvAmountRequests(),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Text(
                  "Error cargando las solicitudes:\n${snapshot.error}",
                  textAlign:
                  TextAlign.center,
                ),
              ),
            );
          }

          final expedientes =
              snapshot.data ?? [];

          if (expedientes.isEmpty) {

            return const Center(
              child: Padding(
                padding:
                EdgeInsets.all(30),

                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Icon(
                      Icons.check_circle_outline,
                      size: 70,
                      color: Colors.green,
                    ),

                    SizedBox(height: 15),

                    Text(
                      "No hay solicitudes MRV pendientes.",
                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Cuando un cliente solicite el monto en pesos dominicanos, aparecerá aquí.",
                      textAlign:
                      TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount:
            expedientes.length,

            itemBuilder:
                (context, index) {

              final expediente =
              expedientes[index];

              final controller =
              _getController(
                expediente.id,
              );

              final usdAmount =
                  expediente
                      .mrvAmountRequestedUsd;

              final requestedAt =
                  expediente
                      .mrvAmountRequestedAt;

              return Card(

                margin:
                const EdgeInsets.only(
                  bottom: 18,
                ),

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

                      Row(
                        children: [

                          Container(
                            padding:
                            const EdgeInsets.all(10),

                            decoration:
                            BoxDecoration(
                              color: AppColors.primary
                                  .withOpacity(0.10),

                              borderRadius:
                              BorderRadius.circular(12),
                            ),

                            child: const Icon(
                              Icons
                                  .request_quote,
                              color:
                              AppColors.primary,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          const Expanded(
                            child: Text(
                              "Solicitud de monto MRV",

                              style:
                              TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      _infoRow(
                        "Expediente",
                        expediente.id,
                      ),

                      _infoRow(
                        "Tarifa oficial",
                        usdAmount != null
                            ? "US\$${usdAmount.toStringAsFixed(2)}"
                            : "No disponible",
                      ),

                      _infoRow(
                        "Fecha de solicitud",
                        requestedAt != null
                            ? _formatDate(
                          requestedAt,
                        )
                            : "No disponible",
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        "Monto a indicar al cliente",

                        style:
                        TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      TextField(

                        controller:
                        controller,

                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),

                        decoration:
                        InputDecoration(

                          prefixText:
                          "RD\$ ",

                          hintText:
                          "Ej. 11050.00",

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      SizedBox(
                        width:
                        double.infinity,

                        height: 52,

                        child:
                        ElevatedButton.icon(

                          icon: const Icon(
                            Icons.send,
                          ),

                          label: const Text(
                            "CONFIRMAR MONTO AL CLIENTE",

                            style:
                            TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          onPressed: () {
                            _confirmarMonto(
                              expediente,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 125,

            child: Text(
              "$title:",

              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
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

  String _formatDate(
      DateTime date) {

    final day =
    date.day
        .toString()
        .padLeft(2, "0");

    final month =
    date.month
        .toString()
        .padLeft(2, "0");

    final year =
    date.year.toString();

    final hour =
    date.hour
        .toString()
        .padLeft(2, "0");

    final minute =
    date.minute
        .toString()
        .padLeft(2, "0");

    return "$day/$month/$year $hour:$minute";
  }
}