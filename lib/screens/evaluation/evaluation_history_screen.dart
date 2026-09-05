import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/evaluation_service.dart';
import 'evaluation_detail_screen.dart';

class EvaluationHistoryScreen extends StatelessWidget {
  const EvaluationHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final EvaluationService evaluationService =
    EvaluationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de evaluaciones',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: evaluationService.watchMyEvaluations(),
          builder: (
              context,
              snapshot,
              ) {
            //==================================================
            // CARGANDO
            //==================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //==================================================
            // ERROR
            //==================================================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'No pudimos cargar tus evaluaciones.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final evaluations =
                snapshot.data?.docs ?? [];

            //==================================================
            // SIN EVALUACIONES
            //==================================================

            if (evaluations.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'No tienes evaluaciones todavía.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Cuando realices una evaluación aparecerá aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            //==================================================
            // LISTA
            //==================================================

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: evaluations.length,
              separatorBuilder: (
                  context,
                  index,
                  ) {
                return const SizedBox(
                  height: 15,
                );
              },
              itemBuilder: (
                  context,
                  index,
                  ) {
                final evaluation =
                evaluations[index];

                return _EvaluationCard(
                  evaluation: evaluation,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//==============================================================
// TARJETA DE EVALUACIÓN
//==============================================================

class _EvaluationCard extends StatelessWidget {
  final DocumentSnapshot evaluation;

  const _EvaluationCard({
    required this.evaluation,
  });

  //==================================================
  // CONFIRMAR ELIMINACIÓN
  //==================================================

  Future<void> _confirmDelete(
      BuildContext context,
      String evaluationId,
      ) async {

    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            '¿Eliminar evaluación?',
          ),
          content: const Text(
            'Esta acción eliminará esta evaluación '
                'y no se puede deshacer.',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'CANCELAR',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'ELIMINAR',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {

      await EvaluationService()
          .deleteEvaluation(
        evaluationId,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Evaluación eliminada correctamente.',
          ),
        ),
      );

    } catch (e) {

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString()
                .replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
    evaluation.data()
    as Map<String, dynamic>;

    final evaluationId =
        evaluation.id;

    final status =
        data['status'] ?? 'in_progress';

    final countryCode =
        data['countryCode'] ?? 'usa';

    final visaType =
        data['visaType'] ?? 'turismo';

    final firstName =
        data['firstName'] ?? '';

    final lastName =
        data['lastName'] ?? '';

    final updatedAt =
    data['updatedAt'] as Timestamp?;

    //==================================================
    // PERMITIR ELIMINACIÓN
    //==================================================

    final canDelete = true;

    //==================================================
    // ESTADO VISUAL
    //==================================================

    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'in_progress':
        statusText = 'En progreso';
        statusColor = Colors.orange;
        statusIcon = Icons.edit_document;
        break;

      case 'waiting_payment':
        statusText = 'Pendiente de pago';
        statusColor = Colors.orange;
        statusIcon = Icons.payment;
        break;

      case 'payment_pending':
        statusText = 'Pago en revisión';
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_top;
        break;

      case 'pending_processing':
        statusText = 'En proceso';
        statusColor = Colors.deepOrange;
        statusIcon = Icons.hourglass_empty;
        break;

      case 'completed':
        statusText = 'Resultado disponible';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;

      case 'cancelled':
        statusText = 'Cancelada';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;

      default:
        statusText = 'Estado desconocido';
        statusColor = Colors.grey;
        statusIcon = Icons.info_outline;
    }

    //==================================================
    // FECHA
    //==================================================

    String dateText = '';

    if (updatedAt != null) {
      final date =
      updatedAt.toDate();

      dateText =
      '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    //==================================================
    // BUILD
    //==================================================

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
        side: BorderSide(
          color:
          statusColor.withOpacity(0.35),
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            //================================================
            // TÍTULO
            //================================================

            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: statusColor,
                  size: 30,
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Evaluación de perfil',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            //================================================
            // PERSONA
            //================================================

            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            //================================================
            // PAÍS
            //================================================

            Text(
              'País: $countryCode',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 5),

            //================================================
            // VISA
            //================================================

            Text(
              'Visa: $visaType',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            if (dateText.isNotEmpty) ...[
              const SizedBox(height: 5),

              Text(
                'Última actualización: $dateText',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],

            const SizedBox(height: 15),

            //================================================
            // ESTADO
            //================================================

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color:
                statusColor.withOpacity(
                  0.10,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            //================================================
            // BOTÓN VER
            //================================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  status == 'completed'
                      ? Icons.visibility
                      : Icons.arrow_forward,
                ),
                label: Text(
                  status == 'completed'
                      ? 'VER RESULTADO'
                      : 'VER EVALUACIÓN',
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EvaluationDetailScreen(
                            evaluationId:
                            evaluationId,
                          ),
                    ),
                  );
                },
              ),
            ),

            //================================================
            // BOTÓN ELIMINAR
            //================================================

            if (canDelete) ...[

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'ELIMINAR EVALUACIÓN',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _confirmDelete(
                      context,
                      evaluationId,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}