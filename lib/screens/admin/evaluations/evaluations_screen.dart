import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../services/evaluation_service.dart';
import '../../../services/question_service.dart';
import '../../../services/evaluation_engine.dart';
import 'manual_evaluation_screen.dart';
import '../../../services/notification_service.dart';

class EvaluationsScreen extends StatefulWidget {
  const EvaluationsScreen({super.key});

  @override
  State<EvaluationsScreen> createState() =>
      _EvaluationsScreenState();
}

class _EvaluationsScreenState
    extends State<EvaluationsScreen> {

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final EvaluationService _evaluationService =
  EvaluationService();

  final QuestionService _questionService =
  QuestionService();

  final Set<String> _selectedIds = {};

  bool processing = false;

  Stream<QuerySnapshot<Map<String, dynamic>>>
  get _evaluationsToProcess {

    return _db
        .collection('evaluations')
        .orderBy(
      'submittedAt',
      descending: false,
    )
        .snapshots();
  }

  //==================================================
  // SELECCIONAR / DESELECCIONAR
  //==================================================

  void toggleSelection(String id) {

    setState(() {

      if (_selectedIds.contains(id)) {

        _selectedIds.remove(id);

      } else {

        _selectedIds.add(id);

      }

    });

  }

  //==================================================
  // SELECCIONAR TODAS
  //==================================================

  void toggleSelectAll(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) {

    setState(() {

      if (_selectedIds.length == docs.length) {

        _selectedIds.clear();

      } else {

        final selectableDocs = docs.where((doc) {
          return doc.data()['status'] == 'pending_processing';
        }).toList();

        _selectedIds
          ..clear()
          ..addAll(
            selectableDocs.map(
                  (doc) => doc.id,
            ),
          );

      }

    });

  }

  //==================================================
  // PROCESAR AUTOMÁTICAMENTE
  //==================================================

  Future<void> sendToAutomatic() async {

    if (_selectedIds.isEmpty) {

      _showMessage(
        "Selecciona al menos una evaluación.",
      );

      return;
    }

    setState(() {
      processing = true;
    });

    try {

      int processed = 0;

      for (final id in _selectedIds) {

        final evaluation =
        await _evaluationService.getEvaluation(id);

        if (!evaluation.exists) {
          continue;
        }

        final data =
        evaluation.data() as Map<String, dynamic>;

        final countryCode =
            data["countryCode"] ?? "";

        final visaType =
            data["visaType"] ?? "";

        final answers =
        Map<String, dynamic>.from(
          data["answers"] ?? {},
        );

        final questions =
        await _questionService.getAllQuestions();

        final filteredQuestions =
        questions.where((question) {

          return question.countryCode ==
              countryCode &&
              question.visaType ==
                  visaType;

        }).toList();

        if (filteredQuestions.isEmpty) {
          continue;
        }

        final result =
        EvaluationEngine().analyze(
          questions: filteredQuestions,
          answers: answers,
        );

        await _evaluationService.saveEvaluationResult(
          evaluationId: id,
          result: {
            ...result.toMap(),
            "status": "completed",
            "processingMethod": "automatic",
            "processedAt": Timestamp.now(),
          },
        );

//==================================================
// NOTIFICAR CLIENTE - RESULTADO PREMIUM LISTO
//==================================================

        final userId =
            data["userId"]?.toString() ?? "";

        if (userId.isNotEmpty) {
          await NotificationService().createNotification(
            userId: userId,
            title: "Tu evaluación Premium está lista",
            message:
            "Hemos terminado de analizar tu evaluación Premium. Ya puedes consultar tus resultados.",
            type: "premium_evaluation_completed",
            expedienteId: id,
            data: {
              "evaluationId": id,
              "processingMethod": "automatic",
              "status": "completed",
            },
          );
        }

        processed++;
      }

      setState(() {
        _selectedIds.clear();
      });

      _showMessage(
        "$processed evaluación(es) procesada(s) automáticamente.",
        success: true,
      );

    } catch (e) {

      _showMessage(
        "Error durante el procesamiento automático: $e",
      );

    } finally {

      if (mounted) {

        setState(() {
          processing = false;
        });

      }

    }
  }

  //==================================================
  // ENVIAR A REVISIÓN MANUAL
  //==================================================

  Future<void> sendToManual() async {

    if (_selectedIds.isEmpty) {

      _showMessage(
        "Selecciona al menos una evaluación.",
      );

      return;
    }

    setState(() {
      processing = true;
    });

    try {

      final batch = _db.batch();

      for (final id in _selectedIds) {

        final ref = _db
            .collection('evaluations')
            .doc(id);

        batch.update(
          ref,
          {
            'processingMethod': 'manual',
            'status': 'manual_review',
            'processingAssignedAt':
            Timestamp.now(),
          },
        );

      }

      await batch.commit();

      setState(() {
        _selectedIds.clear();
      });

      _showMessage(
        "Evaluaciones enviadas a revisión manual.",
        success: true,
      );

    } catch (e) {

      _showMessage(
        "Error al enviar las evaluaciones: $e",
      );

    } finally {

      if (mounted) {

        setState(() {
          processing = false;
        });

      }

    }
  }

  //==================================================
  // MENSAJE
  //==================================================

  void _showMessage(
      String message, {
        bool success = false,
      }) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        success ? Colors.green : Colors.red,
      ),
    );

  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Evaluaciones",
        ),

        centerTitle: true,

      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>
      >(

        stream: _evaluationsToProcess,

        builder: (
            context,
            snapshot,
            ) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Error al cargar las evaluaciones:\n\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );

          }

          final allDocs =
              snapshot.data?.docs ?? [];

          final docs = allDocs.where((doc) {

            final status =
            doc.data()['status'];

            return status == 'pending_processing' ||
                status == 'manual_review';

          }).toList();

          return Column(

            children: [

              //==================================================
              // RESUMEN
              //==================================================

              Padding(
                padding: const EdgeInsets.all(16),

                child: Card(

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

                            const CircleAvatar(

                              backgroundColor:
                              Color(0xffE8F0FE),

                              child: Icon(
                                Icons.fact_check,
                                color: Colors.blue,
                              ),

                            ),

                            const SizedBox(width: 12),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  const Text(
                                    "Pendientes de procesamiento",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "${docs.length} evaluación(es) esperando asignación.",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),

                        if (docs.isNotEmpty) ...[

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              Checkbox(

                                value:
                                _selectedIds.length ==
                                    docs.length,

                                onChanged: processing
                                    ? null
                                    : (_) {

                                  toggleSelectAll(
                                    docs,
                                  );

                                },

                              ),

                              const Text(
                                "Seleccionar todas",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const Spacer(),

                              if (_selectedIds.isNotEmpty)

                                Text(
                                  "${_selectedIds.length} seleccionada(s)",
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    Colors.blue,
                                  ),
                                ),

                            ],
                          ),

                        ],

                      ],
                    ),
                  ),
                ),
              ),

              //==================================================
              // LISTA
              //==================================================

              Expanded(

                child: docs.isEmpty

                    ? const Center(

                  child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.check_circle_outline,
                        size: 70,
                        color: Colors.green,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "No hay evaluaciones pendientes.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Todas las evaluaciones han sido procesadas.",
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),

                )

                    : ListView.builder(

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    150,
                  ),

                  itemCount:
                  docs.length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                    docs[index];

                    final data =
                    doc.data();

                    final status =
                        data['status'] ?? '';

                    final selected =
                    _selectedIds.contains(
                      doc.id,
                    );

                    final firstName =
                        data['firstName'] ??
                            '';

                    final lastName =
                        data['lastName'] ??
                            '';

                    final countryCode =
                        data['countryCode'] ??
                            '';

                    final visaType =
                        data['visaType'] ??
                            '';

                    final submittedAt =
                    data['submittedAt'];

                    return Card(

                      margin:
                      const EdgeInsets.only(
                        bottom: 12,
                      ),

                      elevation: 3,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                        side: BorderSide(
                          color: selected
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),

                      child: InkWell(

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),

                        onTap: processing
                            ? null
                            : () {

                          if (status == 'manual_review') {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ManualEvaluationScreen(
                                      evaluationId: doc.id,
                                    ),
                              ),
                            );

                          } else {

                            toggleSelection(
                              doc.id,
                            );

                          }

                        },

                        child: Padding(

                          padding:
                          const EdgeInsets.all(
                            16,
                          ),

                          child: Row(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Checkbox(
                                value: status == 'manual_review'
                                    ? false
                                    : selected,
                                onChanged: processing ||
                                    status == 'manual_review'
                                    ? null
                                    : (_) {
                                  toggleSelection(
                                    doc.id,
                                  );
                                },
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      "$firstName $lastName"
                                          .trim()
                                          .isEmpty
                                          ? "Solicitante sin nombre"
                                          : "$firstName $lastName",

                                      style:
                                      const TextStyle(

                                        fontSize: 17,

                                        fontWeight:
                                        FontWeight.bold,

                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      "País: $countryCode",
                                    ),

                                    Text(
                                      "Tipo de visa: $visaType",
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    if (submittedAt
                                    is Timestamp)

                                      Text(

                                        "Enviada: "
                                            "${_formatDate(submittedAt)}",

                                        style:
                                        const TextStyle(
                                          fontSize: 12,
                                          color:
                                          Colors.grey,
                                        ),
                                      ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: status == 'manual_review'
                                            ? Colors.deepPurple.withOpacity(.10)
                                            : Colors.orange.withOpacity(.10),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status == 'manual_review'
                                            ? "Revisión manual"
                                            : "Pendiente de procesamiento",
                                        style: TextStyle(
                                          color: status == 'manual_review'
                                              ? Colors.deepPurple
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),

            ],
          );

        },
      ),

      //==================================================
      // BOTONES DE PROCESAMIENTO
      //==================================================

      bottomNavigationBar:
      _selectedIds.isEmpty

          ? null

          : SafeArea(

        child: Container(

          padding:
          const EdgeInsets.all(12),

          decoration:
          BoxDecoration(

            color: Colors.white,

            boxShadow: [

              BoxShadow(
                color:
                Colors.black.withOpacity(.12),
                blurRadius: 10,
                offset:
                const Offset(0, -3),
              ),

            ],
          ),

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Text(
                "${_selectedIds.length} evaluación(es) seleccionada(s)",
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Row(

                children: [

                  Expanded(

                    child:
                    ElevatedButton.icon(

                      icon:
                      const Icon(
                        Icons.smart_toy,
                      ),

                      label:
                      const Text(
                        "AUTOMÁTICO",
                      ),

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.blue,

                        foregroundColor:
                        Colors.white,

                      ),

                      onPressed:
                      processing
                          ? null
                          : sendToAutomatic,

                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(

                    child:
                    ElevatedButton.icon(

                      icon:
                      const Icon(
                        Icons.person,
                      ),

                      label:
                      const Text(
                        "MANUAL",
                      ),

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.deepPurple,

                        foregroundColor:
                        Colors.white,

                      ),

                      onPressed:
                      processing
                          ? null
                          : sendToManual,

                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),

    );
  }

  //==================================================
  // FORMATEAR FECHA
  //==================================================

  String _formatDate(
      Timestamp timestamp,
      ) {

    final date =
    timestamp.toDate();

    final day =
    date.day
        .toString()
        .padLeft(
      2,
      '0',
    );

    final month =
    date.month
        .toString()
        .padLeft(
      2,
      '0',
    );

    final year =
    date.year.toString();

    final hour =
    date.hour
        .toString()
        .padLeft(
      2,
      '0',
    );

    final minute =
    date.minute
        .toString()
        .padLeft(
      2,
      '0',
    );

    return "$day/$month/$year $hour:$minute";
  }
}