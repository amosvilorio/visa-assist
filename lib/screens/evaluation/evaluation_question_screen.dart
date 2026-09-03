import 'package:flutter/material.dart';
import 'evaluation_submitted_screen.dart';
import '../../models/evaluation_question.dart';
import '../../services/evaluation_engine.dart';
import '../../services/evaluation_service.dart';
import '../../services/question_service.dart';
import 'continue_evaluation_screen.dart';

class EvaluationQuestionScreen extends StatefulWidget {
  final String evaluationId;
  final String countryCode;
  final String visaType;

  const EvaluationQuestionScreen({
    super.key,
    required this.evaluationId,
    required this.countryCode,
    required this.visaType,
  });

  @override
  State<EvaluationQuestionScreen> createState() =>
      _EvaluationQuestionScreenState();
}

class _EvaluationQuestionScreenState
    extends State<EvaluationQuestionScreen> {

  // ============================================================
  // SERVICIOS
  // ============================================================

  final QuestionService _questionService = QuestionService();

  final EvaluationService _evaluationService =
  EvaluationService();

  // ============================================================
  // DATOS
  // ============================================================

  List<EvaluationQuestion> questions = [];

  final Map<String, dynamic> answers = {};

  bool loading = true;

  /// Índice de la pregunta dentro de LAS PREGUNTAS VISIBLES.
  ///
  /// IMPORTANTE:
  /// Este índice NO se guarda en Firestore.
  /// Solo sirve para mostrar:
  ///
  /// Pregunta 1 de 30
  /// Pregunta 2 de 30
  /// etc.
  int currentIndex = 0;

  bool isPremiumEvaluation = false;

  // ============================================================
  // CONTROLES
  // ============================================================

  final TextEditingController answerController =
  TextEditingController();

  String? radioValue;

  final List<String> checkboxValues = [];

  // ============================================================
  // PREGUNTAS VISIBLES
  // ============================================================

  /// Devuelve únicamente las preguntas que actualmente
  /// cumplen sus condiciones.
  ///
  /// IMPORTANTE:
  ///
  /// El campo "order" de Firestore NO es el número que
  /// verá el usuario.
  ///
  /// Ejemplo:
  ///
  /// order 12 → visible
  /// order 13 → oculto
  /// order 14 → visible
  ///
  /// Para el usuario:
  ///
  /// Pregunta 12
  /// Pregunta 13
  ///
  /// Es decir, el número visual depende de currentIndex.
  List<EvaluationQuestion> get visibleQuestions {

    final result = questions.where((question) {

      // ----------------------------------------------------------
      // EVALUACIÓN GRATUITA
      // ----------------------------------------------------------

      if (!isPremiumEvaluation &&
          question.order > 10) {
        return false;
      }

      // ----------------------------------------------------------
      // CONDICIONES
      // ----------------------------------------------------------

      return shouldShowQuestion(question);

    }).toList();

    // ------------------------------------------------------------
    // MUY IMPORTANTE
    // ------------------------------------------------------------
    //
    // Siempre ordenamos por el "order" real de Firestore.
    //
    // Ese order sirve para saber qué pregunta viene después.
    // NO sirve para mostrar el número al usuario.
    //
    result.sort(
          (a, b) => a.order.compareTo(b.order),
    );

    return result;
  }

  // ============================================================
  // PREGUNTA ACTUAL
  // ============================================================

  EvaluationQuestion get current {
    return visibleQuestions[currentIndex];
  }

  // ============================================================
  // CICLO DE VIDA
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadEvaluation();
  }

  @override
  void dispose() {
    answerController.dispose();

    super.dispose();
  }

  // ============================================================
  // CARGAR EVALUACIÓN
  // ============================================================

  Future<void> loadEvaluation() async {

    try {

      // ----------------------------------------------------------
      // OBTENER EVALUACIÓN
      // ----------------------------------------------------------

      final evaluation =
      await _evaluationService.getEvaluation(
        widget.evaluationId,
      );

      if (!evaluation.exists) {

        if (mounted) {
          setState(() {
            loading = false;
          });
        }

        return;
      }

      final data =
      evaluation.data() as Map<String, dynamic>;

      // ----------------------------------------------------------
      // DETERMINAR PREMIUM
      // ----------------------------------------------------------

      isPremiumEvaluation =
          data["premiumUnlocked"] == true;

      // ----------------------------------------------------------
      // CARGAR PREGUNTAS
      // ----------------------------------------------------------

      await loadQuestions();

      // ----------------------------------------------------------
      // RESTAURAR RESPUESTAS
      // ----------------------------------------------------------

      answers.clear();

      final savedAnswers =
      data["answers"];

      if (savedAnswers is Map) {

        answers.addAll(
          Map<String, dynamic>.from(
            savedAnswers,
          ),
        );
      }

      // ----------------------------------------------------------
      // OBTENER ORDER GUARDADO
      // ----------------------------------------------------------
      //
      // IMPORTANTE:
      //
      // Firestore guarda el "order" real.
      //
      // Ejemplo:
      //
      // currentQuestion = 14
      //
      // Eso NO significa que el usuario vea:
      //
      // Pregunta 14
      //
      // Puede ser:
      //
      // Pregunta 13 de 30
      //
      // si hubo una pregunta condicional oculta.
      //
      final int savedOrder =
      _parseInt(
        data["currentQuestion"],
        1,
      );

      // ----------------------------------------------------------
      // ENCONTRAR PRIMERA PREGUNTA VÁLIDA
      // ----------------------------------------------------------
      //
      // Buscamos por ORDER REAL.
      //
      // No buscamos por número visual.
      //
      final index =
      findVisibleIndexFromOrder(
        savedOrder,
      );

      // ----------------------------------------------------------
      // ESTABLECER ÍNDICE
      // ----------------------------------------------------------

      if (index >= 0) {

        currentIndex = index;

      } else {

        // --------------------------------------------------------
        // SI LA PREGUNTA GUARDADA YA NO ES VÁLIDA
        // --------------------------------------------------------
        //
        // Puede ocurrir si una pregunta condicional dejó de
        // cumplirse después de restaurar las respuestas.
        //
        // En ese caso buscamos la primera pregunta visible.
        // --------------------------------------------------------

        currentIndex = 0;

        debugPrint(
          "========================================",
        );

        debugPrint(
          "LA PREGUNTA GUARDADA YA NO ES VÁLIDA",
        );

        debugPrint(
          "currentQuestion/order guardado: $savedOrder",
        );

        debugPrint(
          "Preguntas visibles: "
              "${visibleQuestions.map((q) => q.order).toList()}",
        );

        debugPrint(
          "Respuestas guardadas: $answers",
        );

        debugPrint(
          "========================================",
        );
      }

      // ----------------------------------------------------------
      // ASEGURAR ÍNDICE VÁLIDO
      // ----------------------------------------------------------

      if (visibleQuestions.isNotEmpty &&
          currentIndex >= visibleQuestions.length) {

        currentIndex =
            visibleQuestions.length - 1;
      }

      if (currentIndex < 0) {
        currentIndex = 0;
      }

      // ----------------------------------------------------------
      // RESTAURAR CONTROL
      // ----------------------------------------------------------

      restoreAnswer();

      // ----------------------------------------------------------
      // FINALIZAR CARGA
      // ----------------------------------------------------------

      loading = false;

      if (mounted) {
        setState(() {});
      }

    } catch (e) {

      debugPrint(
        "Error cargando evaluación: $e",
      );

      if (mounted) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No se pudo cargar la evaluación: $e",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============================================================
  // CONVERTIR A INT
  // ============================================================

  int _parseInt(
      dynamic value,
      int defaultValue,
      ) {

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ??
          defaultValue;
    }

    return defaultValue;
  }

  // ============================================================
  // CARGAR PREGUNTAS
  // ============================================================

  Future<void> loadQuestions() async {

    questions =
    await _questionService.getQuestionsForEvaluation(
      countryCode: widget.countryCode,
      visaType: widget.visaType,
    );

    questions.sort(
          (a, b) => a.order.compareTo(b.order),
    );
  }

  // ============================================================
  // CONDICIONES
  // ============================================================

  bool shouldShowQuestion(
      EvaluationQuestion question,
      ) {

    // ----------------------------------------------------------
    // SIN DEPENDENCIA
    // ----------------------------------------------------------

    if (question.dependsOn == null ||
        question.dependsOn!.trim().isEmpty) {

      return true;
    }

    // ----------------------------------------------------------
    // TODAVÍA NO EXISTE LA RESPUESTA
    // ----------------------------------------------------------

    if (!answers.containsKey(
      question.dependsOn,
    )) {

      return false;
    }

    final answer =
    answers[question.dependsOn];

    // ----------------------------------------------------------
    // SIN VALORES DE DEPENDENCIA
    // ----------------------------------------------------------

    if (question.dependsValues == null ||
        question.dependsValues.isEmpty) {

      return true;
    }

    // ----------------------------------------------------------
    // RESPUESTA MÚLTIPLE
    // ----------------------------------------------------------

    if (answer is List) {

      return answer.any(
            (value) =>
            question.dependsValues.contains(
              value,
            ),
      );
    }

    // ----------------------------------------------------------
    // RESPUESTA SIMPLE
    // ----------------------------------------------------------

    return question.dependsValues.contains(
      answer,
    );
  }

  // ============================================================
  // BUSCAR ÍNDICE VISIBLE DESDE ORDER
  // ============================================================

  int findVisibleIndexFromOrder(
      int order,
      ) {

    final list =
        visibleQuestions;

    // ----------------------------------------------------------
    // PRIMERO BUSCAMOS EXACTAMENTE EL ORDER
    // ----------------------------------------------------------

    final exactIndex =
    list.indexWhere(
          (question) =>
      question.order == order,
    );

    if (exactIndex >= 0) {
      return exactIndex;
    }

    // ----------------------------------------------------------
    // SI NO EXISTE EXACTAMENTE
    // BUSCAMOS LA PRIMERA POSTERIOR
    // ----------------------------------------------------------

    final nextIndex =
    list.indexWhere(
          (question) =>
      question.order > order,
    );

    if (nextIndex >= 0) {
      return nextIndex;
    }

    return -1;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (visibleQuestions.isEmpty) {

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Evaluación",
          ),
        ),
        body: const Center(
          child: Text(
            "No existen preguntas para esta evaluación.",
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // PROTECCIÓN DE ÍNDICE
    // ----------------------------------------------------------

    if (currentIndex >= visibleQuestions.length) {

      currentIndex =
          visibleQuestions.length - 1;
    }

    final question =
    visibleQuestions[currentIndex];

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Evaluación de Perfil",
        ),
        centerTitle: true,
      ),

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ==================================================
              // PREGUNTA
              // ==================================================

              Text(
                question.question,

                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // RESPUESTA
              // ==================================================

              Expanded(

                child:
                SingleChildScrollView(

                  child:
                  buildQuestionWidget(
                    question,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // BOTÓN
              // ==================================================

              SizedBox(

                width:
                double.infinity,

                height: 55,

                child:
                ElevatedButton(

                  onPressed:
                  nextQuestion,

                  child:
                  Text(

                    currentIndex ==
                        visibleQuestions.length - 1
                        ? "FINALIZAR"
                        : "CONTINUAR",

                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET DE PREGUNTA
  // ============================================================

  Widget buildQuestionWidget(
      EvaluationQuestion question,
      ) {

    switch (question.responseType) {

    // ========================================================
    // TEXTO
    // ========================================================

      case "text":

        return TextField(

          controller:
          answerController,

          decoration:
          const InputDecoration(
            border:
            OutlineInputBorder(),
            hintText:
            "Escriba su respuesta",
          ),
        );

    // ========================================================
    // NÚMERO
    // ========================================================

      case "number":

        return TextField(

          controller:
          answerController,

          keyboardType:
          TextInputType.number,

          decoration:
          const InputDecoration(
            border:
            OutlineInputBorder(),
            hintText:
            "Ingrese un número",
          ),
        );

    // ========================================================
    // SI / NO
    // ========================================================

      case "yes_no":

        return Row(

          children: [

            Expanded(

              child:
              SizedBox(

                height: 60,

                child:
                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    radioValue == "Sí"
                        ? Colors.green
                        : Colors.grey.shade300,

                    foregroundColor:
                    radioValue == "Sí"
                        ? Colors.white
                        : Colors.black87,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    elevation:
                    radioValue == "Sí"
                        ? 4
                        : 0,
                  ),

                  onPressed: () {

                    setState(() {

                      radioValue =
                      "Sí";
                    });
                  },

                  child:
                  const Text(
                    "Sí",
                    style:
                    TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(

              child:
              SizedBox(

                height: 60,

                child:
                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    radioValue == "No"
                        ? Colors.red
                        : Colors.grey.shade300,

                    foregroundColor:
                    radioValue == "No"
                        ? Colors.white
                        : Colors.black87,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    elevation:
                    radioValue == "No"
                        ? 4
                        : 0,
                  ),

                  onPressed: () {

                    setState(() {

                      radioValue =
                      "No";
                    });
                  },

                  child:
                  const Text(
                    "No",
                    style:
                    TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

    // ========================================================
    // OPCIÓN ÚNICA
    // ========================================================

      case "single_choice":

        return Column(

          children:
          question.options.map(
                (option) {

              final selected =
                  radioValue ==
                      option;

              return Padding(

                padding:
                const EdgeInsets.only(
                  bottom: 12,
                ),

                child:
                InkWell(

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),

                  onTap: () {

                    setState(() {

                      radioValue =
                          option;
                    });
                  },

                  child:
                  AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds: 200,
                    ),

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      selected
                          ? Colors.green.shade50
                          : Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),

                      border:
                      Border.all(

                        color:
                        selected
                            ? Colors.green
                            : Colors.grey.shade300,

                        width: 2,
                      ),
                    ),

                    child:
                    Row(

                      children: [

                        Icon(

                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,

                          color:
                          selected
                              ? Colors.green
                              : Colors.grey,
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(

                          child:
                          Text(

                            option,

                            style:
                            TextStyle(

                              fontSize: 17,

                              fontWeight:
                              selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );

    // ========================================================
    // DROPDOWN
    // ========================================================

      case "dropdown":

        return DropdownButtonFormField<String>(

          value:
          radioValue,

          isExpanded:
          true,

          borderRadius:
          BorderRadius.circular(
            15,
          ),

          decoration:
          InputDecoration(

            labelText:
            "Seleccione una opción",

            prefixIcon:
            const Icon(
              Icons.list_alt,
            ),

            filled:
            true,

            fillColor:
            Colors.grey.shade100,

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                15,
              ),
            ),

            enabledBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                15,
              ),
            ),

            focusedBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                15,
              ),
              borderSide:
              const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
          ),

          items:
          question.options.map(
                (option) {

              return DropdownMenuItem<String>(

                value:
                option,

                child:
                Text(
                  option,
                  style:
                  const TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            },
          ).toList(),

          onChanged:
              (value) {

            setState(() {

              radioValue =
                  value;
            });
          },
        );

    // ========================================================
    // MÚLTIPLE
    // ========================================================

      case "multiple":

        return Column(

          children:
          question.options.map(
                (option) {

              final selected =
              checkboxValues.contains(
                option,
              );

              return Padding(

                padding:
                const EdgeInsets.only(
                  bottom: 12,
                ),

                child:
                InkWell(

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),

                  onTap: () {

                    setState(() {

                      if (selected) {

                        checkboxValues
                            .remove(
                          option,
                        );

                      } else {

                        checkboxValues
                            .add(
                          option,
                        );
                      }
                    });
                  },

                  child:
                  AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds: 200,
                    ),

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      selected
                          ? Colors.blue.shade50
                          : Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),

                      border:
                      Border.all(

                        color:
                        selected
                            ? Colors.blue
                            : Colors.grey.shade300,

                        width: 2,
                      ),
                    ),

                    child:
                    Row(

                      children: [

                        Icon(

                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,

                          color:
                          selected
                              ? Colors.blue
                              : Colors.grey,
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(

                          child:
                          Text(

                            option,

                            style:
                            TextStyle(

                              fontSize: 17,

                              fontWeight:
                              selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );

    // ========================================================
    // FECHA
    // ========================================================

      case "date":

        return TextField(

          controller:
          answerController,

          readOnly:
          true,

          decoration:
          const InputDecoration(

            border:
            OutlineInputBorder(),

            suffixIcon:
            Icon(
              Icons.calendar_month,
            ),
          ),

          onTap: () async {

            final date =
            await showDatePicker(

              context:
              context,

              firstDate:
              DateTime(1950),

              lastDate:
              DateTime.now(),

              initialDate:
              DateTime.now(),
            );

            if (date == null) {
              return;
            }

            answerController.text =
            "${date.day}/${date.month}/${date.year}";

            setState(() {});
          },
        );

    // ========================================================
    // DEFAULT
    // ========================================================

      default:

        return TextField(

          controller:
          answerController,

          decoration:
          const InputDecoration(
            border:
            OutlineInputBorder(),
          ),
        );
    }
  }

  // ============================================================
  // RESTAURAR RESPUESTA
  // ============================================================

  void restoreAnswer() {

    radioValue = null;

    checkboxValues.clear();

    answerController.clear();

    final list =
        visibleQuestions;

    if (list.isEmpty) {
      return;
    }

    if (currentIndex >= list.length) {
      return;
    }

    final question =
    list[currentIndex];

    final savedAnswer =
    answers[question.questionKey];

    if (savedAnswer == null) {
      return;
    }

    switch (question.responseType) {

      case "text":

      case "number":

      case "date":

        answerController.text =
            savedAnswer.toString();

        break;

      case "yes_no":

      case "single_choice":

      case "dropdown":

        radioValue =
            savedAnswer.toString();

        break;

      case "multiple":

        if (savedAnswer is List) {

          checkboxValues.addAll(
            savedAnswer.map(
                  (value) =>
                  value.toString(),
            ),
          );
        }

        break;
    }
  }

  // ============================================================
  // GUARDAR RESPUESTA
  // ============================================================

  Future<void> saveCurrentAnswer() async {

    dynamic answer;

    switch (current.responseType) {

      case "text":

      case "number":

      case "date":

        answer =
            answerController
                .text
                .trim();

        break;

      case "yes_no":

      case "single_choice":

      case "dropdown":

        answer =
            radioValue;

        break;

      case "multiple":

        answer =
        List<String>.from(
          checkboxValues,
        );

        break;

      default:

        answer =
            answerController
                .text
                .trim();
    }

    // ----------------------------------------------------------
    // ACTUALIZAR MEMORIA LOCAL
    // ----------------------------------------------------------

    answers[current.questionKey] =
        answer;

    // ----------------------------------------------------------
    // GUARDAR EN FIRESTORE
    // ----------------------------------------------------------

    await _evaluationService.updateAnswer(

      evaluationId:
      widget.evaluationId,

      questionId:
      current.questionKey,

      answer:
      answer,
    );
  }

  // ============================================================
  // LIMPIAR CONTROLES
  // ============================================================

  void clearControls() {

    radioValue = null;

    checkboxValues.clear();

    answerController.clear();
  }

  // ============================================================
  // VALIDAR RESPUESTA
  // ============================================================

  bool validateCurrentAnswer() {

    switch (current.responseType) {

      case "text":

      case "number":

      case "date":

        return answerController
            .text
            .trim()
            .isNotEmpty;

      case "yes_no":

      case "single_choice":

      case "dropdown":

        return radioValue != null;

      case "multiple":

        return checkboxValues
            .isNotEmpty;

      default:

        return true;
    }
  }

  // ============================================================
  // BUSCAR SIGUIENTE PREGUNTA
  // ============================================================

  EvaluationQuestion? findNextQuestion() {

    // ----------------------------------------------------------
    // ORDER REAL DE LA PREGUNTA ACTUAL
    // ----------------------------------------------------------

    final currentOrder =
        current.order;

    // ----------------------------------------------------------
    // BUSCAR EN TODAS LAS PREGUNTAS
    // ----------------------------------------------------------
    //
    // NO buscamos en visibleQuestions.
    //
    // Buscamos en questions porque queremos que el sistema
    // determine cuál es la siguiente pregunta real.
    //
    // Después verificamos si cumple las condiciones.
    // ----------------------------------------------------------

    final candidates =
    questions
        .where(
          (question) {

        // Solo posteriores
        if (question.order <=
            currentOrder) {
          return false;
        }

        // Evaluación gratuita
        if (!isPremiumEvaluation &&
            question.order > 10) {
          return false;
        }

        return true;
      },
    )
        .toList();

    // ----------------------------------------------------------
    // ORDENAR
    // ----------------------------------------------------------

    candidates.sort(
          (a, b) =>
          a.order.compareTo(
            b.order,
          ),
    );

    // ----------------------------------------------------------
    // BUSCAR PRIMERA QUE CUMPLA
    // ----------------------------------------------------------

    for (final question
    in candidates) {

      if (shouldShowQuestion(
        question,
      )) {

        return question;
      }
    }

    // ----------------------------------------------------------
    // NO EXISTE OTRA PREGUNTA
    // ----------------------------------------------------------

    return null;
  }

  // ============================================================
  // SIGUIENTE PREGUNTA
  // ============================================================

  Future<void> nextQuestion() async {

    try {

      // ========================================================
      // VALIDAR
      // ========================================================

      if (!validateCurrentAnswer()) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          const SnackBar(

            content:
            Text(
              "Debes responder la pregunta antes de continuar.",
            ),
          ),
        );

        return;
      }

      // ========================================================
      // GUARDAR RESPUESTA
      // ========================================================

      await saveCurrentAnswer();

      // ========================================================
      // CALCULAR RESULTADO
      // ========================================================

      final result =
      EvaluationEngine().analyze(

        questions:
        questions,

        answers:
        answers,
      );

      await _evaluationService
          .saveEvaluationResult(

        evaluationId:
        widget.evaluationId,

        result:
        result.toMap(),
      );

      // ========================================================
      // BUSCAR SIGUIENTE PREGUNTA
      // ========================================================

      final next =
      findNextQuestion();

      // ========================================================
      // NO HAY SIGUIENTE
      // ========================================================

      if (next == null) {

        // ------------------------------------------------------
        // PRIMERA ETAPA GRATUITA
        // ------------------------------------------------------

        if (!isPremiumEvaluation) {

          // ----------------------------------------------------
          // IMPORTANTE
          //
          // La evaluación gratuita termina cuando ya no existen
          // preguntas aplicables dentro de la etapa gratuita.
          // ----------------------------------------------------

          await _evaluationService
              .waitingPayment(
            widget.evaluationId,
          );

          if (!mounted) {
            return;
          }

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  ContinueEvaluationScreen(

                    evaluationId:
                    widget.evaluationId,

                    result:
                    result,
                  ),
            ),
          );

          return;
        }

        // ------------------------------------------------------
// PREMIUM TERMINADA
// ------------------------------------------------------

        await _evaluationService
            .submitForProcessing(
          widget.evaluationId,
        );

        if (!mounted) {
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EvaluationSubmittedScreen(
              evaluationId: widget.evaluationId,
              countryCode: widget.countryCode,
              visaType: widget.visaType,
            ),
          ),
        );

        return;
      }

      // ========================================================
      // ENCONTRAMOS SIGUIENTE PREGUNTA
      // ========================================================

      // --------------------------------------------------------
      // BUSCAR SU POSICIÓN VISUAL
      // --------------------------------------------------------

      final nextIndex =
      visibleQuestions.indexWhere(
            (question) =>
        question.questionKey ==
            next.questionKey,
      );

      if (nextIndex < 0) {

        throw Exception(
          "No se pudo determinar la posición de la siguiente pregunta.",
        );
      }

      // --------------------------------------------------------
      // CAMBIAR ÍNDICE VISUAL
      // --------------------------------------------------------

      currentIndex =
          nextIndex;

      // --------------------------------------------------------
      // GUARDAR ORDER REAL EN FIRESTORE
      // --------------------------------------------------------
      //
      // IMPORTANTE:
      //
      // Guardamos:
      //
      // next.order
      //
      // NO:
      //
      // currentIndex + 1
      //
      // Porque currentIndex + 1 es únicamente el número visual.
      // --------------------------------------------------------

      await _evaluationService
          .updateCurrentQuestion(

        evaluationId:
        widget.evaluationId,

        currentQuestion:
        next.order,
      );

      // ========================================================
      // LIMPIAR CONTROLES
      // ========================================================

      clearControls();

      // ========================================================
      // RESTAURAR SI YA EXISTÍA RESPUESTA
      // ========================================================

      restoreAnswer();

      // ========================================================
      // ACTUALIZAR PANTALLA
      // ========================================================

      if (!mounted) {
        return;
      }

      setState(() {});

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content:
          Text(
            "No se pudo continuar: $e",
          ),

          backgroundColor:
          Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // VOLVER ATRÁS
  // ============================================================

  Future<bool> _onWillPop() async {

    final salir =
    await showDialog<bool>(

      context:
      context,

      builder: (_) =>
          AlertDialog(

            title:
            const Text(
              "Salir de la evaluación",
            ),

            content:
            const Text(
              "Tu progreso ha sido guardado automáticamente. ¿Deseas salir de la evaluación?",
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(
                    context,
                    false,
                  );
                },

                child:
                const Text(
                  "Cancelar",
                ),
              ),

              ElevatedButton(

                onPressed: () {

                  Navigator.pop(
                    context,
                    true,
                  );
                },

                child:
                const Text(
                  "Salir",
                ),
              ),
            ],
          ),
    );

    return salir ?? false;
  }
}