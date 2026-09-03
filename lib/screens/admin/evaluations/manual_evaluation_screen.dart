import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/evaluation_question.dart';
import '../../../services/question_service.dart';
import '../../../services/notification_service.dart';

class ManualEvaluationScreen extends StatefulWidget {
  final String evaluationId;

  const ManualEvaluationScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  State<ManualEvaluationScreen> createState() =>
      _ManualEvaluationScreenState();
}

class _ManualEvaluationScreenState
    extends State<ManualEvaluationScreen> {

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final QuestionService _questionService =
  QuestionService();

  List<EvaluationQuestion> evaluationQuestions = [];

  bool loading = true;
  bool saving = false;

  Map<String, dynamic>? evaluationData;

  final TextEditingController strengthsController =
  TextEditingController();

  final TextEditingController weaknessesController =
  TextEditingController();

  final TextEditingController recommendationsController =
  TextEditingController();

  final TextEditingController visaAssistController =
  TextEditingController();

  String profileLevel = "Perfil Bueno";

  String riskLevel = "Moderado";

  @override
  void initState() {
    super.initState();
    loadEvaluation();
  }

  @override
  void dispose() {
    strengthsController.dispose();
    weaknessesController.dispose();
    recommendationsController.dispose();
    visaAssistController.dispose();
    super.dispose();
  }

  //==================================================
  // CARGAR EVALUACIÓN
  //==================================================

  Future<void> loadEvaluation() async {

    try {

      final doc = await _db
          .collection("evaluations")
          .doc(widget.evaluationId)
          .get();

      if (!doc.exists) {
        throw Exception(
          "La evaluación no existe.",
        );
      }

      final data = doc.data();

      if (data == null) {
        throw Exception(
          "No se encontraron los datos de la evaluación.",
        );
      }

      evaluationData = data;

      final countryCode =
          data["countryCode"] ?? "";

      final visaType =
          data["visaType"] ?? "";

      evaluationQuestions =
      await _questionService.getQuestions(
        countryCode: countryCode,
        visaType: visaType,
        isPremium: true,
      );

      final existingProfile =
      data["profileLevel"];

      final existingRisk =
      data["riskLevel"];

      if (existingRisk is String &&
          existingRisk.isNotEmpty) {

        riskLevel = existingRisk;

      }

      if (existingProfile is String &&
          existingProfile.isNotEmpty &&
          existingProfile != "Sin evaluar") {

        profileLevel = existingProfile;

      }

      final existingStrengths =
      data["strengths"];

      if (existingStrengths is List) {
        strengthsController.text =
            existingStrengths
                .map((e) => e.toString())
                .join("\n");
      }

      final existingWeaknesses =
      data["weaknesses"];

      if (existingWeaknesses is List) {
        weaknessesController.text =
            existingWeaknesses
                .map((e) => e.toString())
                .join("\n");
      }

      final existingRecommendations =
      data["recommendations"];

      if (existingRecommendations is List) {
        recommendationsController.text =
            existingRecommendations
                .map((e) => e.toString())
                .join("\n");
      }

      final existingVisaAssist =
      data["visaAssistRecommendation"];

      if (existingVisaAssist != null) {
        visaAssistController.text =
            existingVisaAssist.toString();
      }

      if (mounted) {
        setState(() {
          loading = false;
        });
      }

    } catch (e) {

      if (mounted) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error al cargar la evaluación: $e",
            ),
            backgroundColor: Colors.red,
          ),
        );

      }

    }
  }

  //==================================================
  // GUARDAR RESULTADO MANUAL
  //==================================================

  Future<void> saveManualEvaluation() async {

    if (evaluationData == null) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {

      final strengths = strengthsController.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final weaknesses = weaknessesController.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final recommendations =
      recommendationsController.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await _db
          .collection("evaluations")
          .doc(widget.evaluationId)
          .update({

        "profileLevel": profileLevel,

        "riskLevel": riskLevel,

        "strengths": strengths,

        "weaknesses": weaknesses,

        "recommendations": recommendations,

        "visaAssistRecommendation":
        visaAssistController.text.trim(),

        "status": "completed",

        "processingMethod": "manual",

        "adminReviewed": true,

        "processedAt": Timestamp.now(),

        "updatedAt": Timestamp.now(),

      });

      //==================================================
// NOTIFICAR CLIENTE - RESULTADO PREMIUM LISTO
//==================================================

      final userId =
          evaluationData!["userId"]?.toString() ?? "";

      if (userId.isNotEmpty) {

        await NotificationService().createNotification(
          userId: userId,
          title: "Tu evaluación Premium está lista",
          message:
          "Hemos terminado de analizar tu evaluación Premium. Ya puedes consultar tus resultados.",
          type: "premium_evaluation_completed",
          expedienteId: widget.evaluationId,
          data: {
            "evaluationId": widget.evaluationId,
            "processingMethod": "manual",
            "status": "completed",
          },
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Evaluación guardada correctamente.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al guardar: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          saving = false;
        });

      }

    }
  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    }

    if (evaluationData == null) {

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Revisión de evaluación",
          ),
        ),
        body: const Center(
          child: Text(
            "No se pudo cargar la evaluación.",
          ),
        ),
      );

    }

    final firstName =
        evaluationData!["firstName"] ?? "";

    final lastName =
        evaluationData!["lastName"] ?? "";

    final countryCode =
        evaluationData!["countryCode"] ?? "";

    final visaType =
        evaluationData!["visaType"] ?? "";

    final answers =
    Map<String, dynamic>.from(
      evaluationData!["answers"] ?? {},
    );

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Revisión de evaluación",
        ),
        centerTitle: true,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              //==================================================
              // SOLICITANTE
              //==================================================

              _sectionCard(
                title: "Solicitante",
                icon: Icons.person,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      "$firstName $lastName",
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "País: $countryCode",
                    ),

                    Text(
                      "Tipo de visa: $visaType",
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 16),

              //==================================================
              // RESPUESTAS
              //==================================================

              _sectionCard(
                title: "Respuestas del solicitante",
                icon: Icons.question_answer,
                child: answers.isEmpty
                    ? const Text(
                  "No hay respuestas registradas.",
                )
                    : Column(
                  children: evaluationQuestions
                      .where(
                        (question) =>
                        answers.containsKey(
                          question.questionKey,
                        ),
                  )
                      .map(
                        (question) {

                      final answer =
                      answers[question.questionKey];

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                          const Color(0xffF5F7FB),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Pregunta ${question.order}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Respuesta: "
                                  "${_formatAnswer(answer)}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),

                          ],
                        ),
                      );

                    },
                  )
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              //==================================================
              // PERFIL
              //==================================================

              _sectionCard(
                title: "Resultado de Admin",
                icon: Icons.assessment,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Perfil del solicitante",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: profileLevel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "Perfil Muy Fuerte",
                          child: Text("Perfil Muy Fuerte"),
                        ),

                        DropdownMenuItem(
                          value: "Perfil Fuerte",
                          child: Text("Perfil Fuerte"),
                        ),

                        DropdownMenuItem(
                          value: "Perfil Bueno",
                          child: Text("Perfil Bueno"),
                        ),

                        DropdownMenuItem(
                          value: "Perfil Moderado",
                          child: Text("Perfil Moderado"),
                        ),

                        DropdownMenuItem(
                          value: "Perfil Débil",
                          child: Text("Perfil Débil"),
                        ),

                      ],
                      onChanged: saving
                          ? null
                          : (value) {

                        if (value == null) {
                          return;
                        }

                        setState(() {
                          profileLevel = value;
                        });

                      },
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Nivel de riesgo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: riskLevel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(
                          value: "Muy Bajo",
                          child: Text("Muy Bajo"),
                        ),

                        DropdownMenuItem(
                          value: "Bajo",
                          child: Text("Bajo"),
                        ),

                        DropdownMenuItem(
                          value: "Moderado",
                          child: Text("Moderado"),
                        ),

                        DropdownMenuItem(
                          value: "Alto",
                          child: Text("Alto"),
                        ),

                        DropdownMenuItem(
                          value: "Muy Alto",
                          child: Text("Muy Alto"),
                        ),

                      ],
                      onChanged: saving
                          ? null
                          : (value) {

                        if (value == null) {
                          return;
                        }

                        setState(() {
                          riskLevel = value;
                        });

                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //==================================================
              // FORTALEZAS
              //==================================================

              _textSection(
                title: "Fortalezas",
                icon: Icons.thumb_up,
                controller:
                strengthsController,
                hint:
                "Escribe una fortaleza por línea.",
              ),

              const SizedBox(height: 16),

              //==================================================
              // DEBILIDADES
              //==================================================

              _textSection(
                title: "Debilidades",
                icon: Icons.warning_amber,
                controller:
                weaknessesController,
                hint:
                "Escribe una debilidad por línea.",
              ),

              const SizedBox(height: 16),

              //==================================================
              // RECOMENDACIONES
              //==================================================

              _textSection(
                title: "Recomendaciones",
                icon: Icons.lightbulb,
                controller:
                recommendationsController,
                hint:
                "Escribe una recomendación por línea.",
              ),

              const SizedBox(height: 16),

              //==================================================
              // VISA ASSIST
              //==================================================

              _textSection(
                title:
                "Consejo de Visa Assist",
                icon:
                Icons.support_agent,
                controller:
                visaAssistController,
                hint:
                "Escribe el consejo final para el cliente.",
                maxLines: 6,
              ),

              const SizedBox(height: 25),

              //==================================================
              // ADVERTENCIA
              //==================================================

              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(16),

                decoration:
                BoxDecoration(

                  color:
                  Colors.orange.withOpacity(.10),

                  borderRadius:
                  BorderRadius.circular(16),

                  border:
                  Border.all(
                    color:
                    Colors.orange.shade200,
                  ),

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
                        "La evaluación es únicamente una orientación. Ningún resultado garantiza la aprobación de una visa. La decisión final corresponde exclusivamente al oficial consular.",
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),

                    ),

                  ],
                ),
              ),

              const SizedBox(height: 25),

              //==================================================
              // GUARDAR
              //==================================================

              SizedBox(

                width: double.infinity,

                height: 56,

                child: ElevatedButton.icon(

                  icon: saving

                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )

                      : const Icon(
                    Icons.save,
                  ),

                  label: Text(
                    saving
                        ? "GUARDANDO..."
                        : "GUARDAR RESULTADO",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  onPressed:
                  saving
                      ? null
                      : saveManualEvaluation,

                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  //==================================================
  // TARJETA DE SECCIÓN
  //==================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
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
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Icon(
                  icon,
                  color:
                  Colors.blue,
                ),

                const SizedBox(
                  width: 10,
                ),

                Text(
                  title,
                  style:
                  const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(
              height: 15,
            ),

            child,

          ],
        ),
      ),
    );
  }

  //==================================================
  // CAMPO DE TEXTO
  //==================================================

  Widget _textSection({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    int maxLines = 4,
  }) {

    return _sectionCard(

      title: title,

      icon: icon,

      child: TextField(

        controller: controller,

        maxLines: maxLines,

        decoration: InputDecoration(
          hintText: hint,
          border:
          const OutlineInputBorder(),
        ),

      ),
    );
  }

  //==================================================
  // FORMATEAR RESPUESTA
  //==================================================

  String _formatAnswer(dynamic value) {

    if (value is List) {

      return value
          .map(
            (item) => item.toString(),
      )
          .join(", ");

    }

    if (value == null) {
      return "";
    }

    return value.toString();
  }
}