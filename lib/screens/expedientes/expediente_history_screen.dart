import 'package:flutter/material.dart';

import '../../models/expediente.dart';
import '../../services/expediente_service.dart';
import 'expediente_detail_screen.dart';

class ExpedienteHistoryScreen extends StatelessWidget {
  const ExpedienteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpedienteService expedienteService =
    ExpedienteService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial de expedientes",
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<List<Expediente>>(
        stream:
        expedienteService.getMyCompletedExpedientes(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "No se pudo cargar el historial.\n\n"
                      "${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final expedientes =
              snapshot.data ?? [];

          if (expedientes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 70,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "No tienes expedientes completados.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Cuando completes un proceso de visa, "
                          "aparecerá aquí.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: expedientes.length,
            itemBuilder: (context, index) {
              final expediente =
              expedientes[index];

              return _historyCard(
                context,
                expediente,
              );
            },
          );
        },
      ),
    );
  }

  Widget _historyCard(
      BuildContext context,
      Expediente expediente,
      ) {
    final bool approved =
        expediente.finalDecision == "Aprobada";

    final bool denied =
        expediente.finalDecision == "Denegada";

    final Color resultColor = approved
        ? Colors.green
        : denied
        ? Colors.red
        : Colors.orange;

    final IconData resultIcon = approved
        ? Icons.check_circle
        : denied
        ? Icons.cancel
        : Icons.info;

    final String resultText =
    expediente.finalDecision.isEmpty
        ? "Proceso completado"
        : expediente.finalDecision;

    return Card(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor:
                  resultColor.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(
                    resultIcon,
                    color: resultColor,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Visa ${expediente.visaType}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "País: ${expediente.countryCode}",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: resultColor
                    .withValues(alpha: 0.08),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    resultIcon,
                    color: resultColor,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resultado",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          resultText,
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: resultColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.visibility,
                ),
                label: const Text(
                  "VER EXPEDIENTE",
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExpedienteDetailScreen(
                            expediente:
                            expediente,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}