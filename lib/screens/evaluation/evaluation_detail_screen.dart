import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'evaluation_question_screen.dart';
import '../payment/payment_screen.dart';
import '../../models/evaluation_question.dart';
import '../../services/question_service.dart';
import '../expedientes/my_expedientes_screen.dart';

class EvaluationDetailScreen extends StatefulWidget {
  final String evaluationId;

  const EvaluationDetailScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  State<EvaluationDetailScreen> createState() =>
      _EvaluationDetailScreenState();
}

class _EvaluationDetailScreenState
    extends State<EvaluationDetailScreen> {

  final QuestionService _questionService =
  QuestionService();

  bool loadingQuestions = true;

  List<EvaluationQuestion> questions = [];

  Map<String, dynamic>? evaluationData;

  @override
  void initState() {
    super.initState();

    loadEvaluation();
  }

  //==============================================================
  // CARGAR EVALUACIÓN
  //==============================================================

  Future<void> loadEvaluation() async {

    try {

      final snapshot =
      await FirebaseFirestore.instance
          .collection('evaluations')
          .doc(widget.evaluationId)
          .get();

      if (!snapshot.exists) {

        if (mounted) {
          setState(() {
            loadingQuestions = false;
          });
        }

        return;
      }

      final data =
      snapshot.data() as Map<String, dynamic>;

      evaluationData = data;

      //============================================================
      // CARGAR PREGUNTAS
      //============================================================

      final countryCode =
          data['countryCode'] ?? 'usa';

      final visaType =
          data['visaType'] ?? 'turismo';

      final loadedQuestions =
      await _questionService
          .getQuestionsForEvaluation(
        countryCode: countryCode,
        visaType: visaType,
      );

      loadedQuestions.sort(
            (a, b) =>
            a.order.compareTo(b.order),
      );

      //============================================================
// DETERMINAR CUÁNTAS PREGUNTAS PUEDE VER
//============================================================

      final premiumUnlocked =
          data['premiumUnlocked'] == true;

      final premiumPaid =
          data['premiumPaid'] == true;

      final evaluationStatus =
          data['status'] ?? 'in_progress';

// Si el usuario pagó y tiene Premium desbloqueado,
// puede ver todas las preguntas.
// Si ya terminó la evaluación, también puede verlas todas.
// De lo contrario, solamente puede ver las primeras 10.

      final canViewFullEvaluation =
          (premiumUnlocked && premiumPaid) ||
              evaluationStatus == 'completed';

      if (canViewFullEvaluation) {

        questions = loadedQuestions;

      } else {

        questions = loadedQuestions
            .where(
              (question) =>
          question.order <= 10,
        )
            .toList();
      }

      if (mounted) {
        setState(() {
          loadingQuestions = false;
        });
      }

    } catch (e) {

      debugPrint(
        "Error cargando detalle de evaluación: $e",
      );

      if (mounted) {
        setState(() {
          loadingQuestions = false;
        });
      }
    }
  }

  //==============================================================
  // BUILD
  //==============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Mi evaluación',
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  //==============================================================
  // BODY
  //==============================================================

  Widget _buildBody() {

    if (loadingQuestions) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (evaluationData == null) {

      return const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Text(
            'Esta evaluación ya no está disponible.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    final data =
    evaluationData!;

    final status =
        data['status'] ??
            'in_progress';

    final firstName =
        data['firstName'] ??
            '';

    final lastName =
        data['lastName'] ??
            '';

    final countryCode =
        data['countryCode'] ??
            'usa';

    final visaType =
        data['visaType'] ??
            'turismo';

    final profileLevel =
        data['profileLevel'] ??
            'Sin evaluar';

    final approvalPercentage =
    _toDouble(
      data['approvalPercentage'],
    );

    final riskLevel =
        data['riskLevel'] ??
            '';

    final answers =
    _getAnswers(
      data['answers'],
    );

    final strengths =
    List<String>.from(
      data['strengths'] ?? [],
    );

    final weaknesses =
    List<String>.from(
      data['weaknesses'] ?? [],
    );

    final recommendations =
    List<String>.from(
      data['recommendations'] ?? [],
    );

    return SingleChildScrollView(

      padding:
      const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          //========================================================
          // ENCABEZADO
          //========================================================

          const SizedBox(height: 10),

          Center(
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color:
                Colors.blue.withOpacity(0.10),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_turned_in,
                color: Colors.blue,
                size: 55,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              status == 'completed'
                  ? 'Resultado completo'
                  : 'Resultado preliminar',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              '$firstName $lastName',
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 25),

          //========================================================
          // ESTADO
          //========================================================

          _buildStatusCard(
            status,
          ),

          const SizedBox(height: 20),

          //========================================================
          // RESULTADO DEL PERFIL
          //========================================================

          _buildProfileResult(
            profileLevel:
            profileLevel,
            approvalPercentage:
            approvalPercentage,
            riskLevel:
            riskLevel,
          ),

          const SizedBox(height: 20),

          //========================================================
          // INFORMACIÓN
          //========================================================

          _buildInformationCard(
            firstName:
            firstName,
            lastName:
            lastName,
            countryCode:
            countryCode,
            visaType:
            visaType,
          ),

          const SizedBox(height: 25),

          //========================================================
          // LAS 10 PREGUNTAS
          //========================================================

          Text(
            'Tus respuestas',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            status == 'completed'
                ? 'Estas son todas las respuestas registradas en tu evaluación completa.'
                : 'Estas son las respuestas registradas en tu evaluación preliminar.',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          _buildAnswersSection(
            answers,
          ),

          if (status == 'completed') ...[
            if (strengths.isNotEmpty)
              _resultSection(
                title: 'Fortalezas',
                icon: Icons.check_circle,
                color: Colors.green,
                items: strengths,
              ),

            if (weaknesses.isNotEmpty)
              _resultSection(
                title: 'Aspectos a mejorar',
                icon: Icons.warning,
                color: Colors.orange,
                items: weaknesses,
              ),

            if (recommendations.isNotEmpty)
              _resultSection(
                title: 'Recomendaciones',
                icon: Icons.lightbulb,
                color: Colors.blue,
                items: recommendations,
              ),

            const SizedBox(height: 5),
          ],


          const SizedBox(height: 25),

          //========================================================
          // VISA ASSIST PLUS
          //========================================================

          _buildPremiumCard(),

          const SizedBox(height: 25),

          //========================================================
          // AVISO LEGAL
          //========================================================

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(18),

            decoration:
            BoxDecoration(
              color:
              Colors.grey.shade100,

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: const Text(
              'Esta evaluación es únicamente una orientación y no garantiza la aprobación de una visa. La decisión final corresponde exclusivamente al Oficial Consular.',
              textAlign:
              TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 25),

          //========================================================
          // VOLVER
          //========================================================

          SizedBox(
            width:
            double.infinity,

            height: 52,

            child:
            ElevatedButton(

              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child:
              const Text(
                'VOLVER AL HISTORIAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //==============================================================
  // ESTADO
  //==============================================================

  Widget _buildStatusCard(
      String status,
      ) {

    String title;
    String description;
    Color color;
    IconData icon;

    switch (status) {

      case 'waiting_payment':

        title =
        'Evaluación preliminar completada';

        description =
        'Ya completaste las preguntas iniciales. Puedes consultar tus respuestas y el resultado preliminar.';

        color =
            Colors.orange;

        icon =
            Icons.payment;

        break;

      case 'payment_pending':

        title =
        'Pago en revisión';

        description =
        'Tu comprobante de pago está siendo revisado.';

        color =
            Colors.blue;

        icon =
            Icons.hourglass_top;

        break;

      case 'in_progress':

        title =
        'Evaluación en progreso';

        description =
        'La evaluación todavía está en proceso.';

        color =
            Colors.orange;

        icon =
            Icons.edit_document;

        break;

      case 'completed':

        title =
        'Evaluación completada';

        description =
        'El resultado de tu evaluación está disponible.';

        color =
            Colors.green;

        icon =
            Icons.check_circle;

        break;

      default:

        title =
        'Estado de la evaluación';

        description =
        'Consulta la información de tu evaluación.';

        color =
            Colors.blue;

        icon =
            Icons.info_outline;
    }

    return Container(

      width:
      double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(

        color:
        color.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(18),

        border:
        Border.all(
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
            size: 32,
          ),

          const SizedBox(width: 14),

          Expanded(
            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style:
                  TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    color,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style:
                  const TextStyle(
                    fontSize: 15,
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

  //==============================================================
  // RESULTADO DEL PERFIL
  //==============================================================

  Widget _buildProfileResult({
    required String profileLevel,
    required double approvalPercentage,
    required String riskLevel,
  }) {

    return Container(

      width:
      double.infinity,

      padding:
      const EdgeInsets.all(22),

      decoration:
      BoxDecoration(

        color:
        Colors.green.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(20),

        border:
        Border.all(
          color:
          Colors.green.withOpacity(0.25),
        ),
      ),

      child:
      Column(

        children: [

          const Text(
            'Tu perfil preliminar',
            style:
            TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            profileLevel,
            textAlign:
            TextAlign.center,

            style:
            const TextStyle(
              fontSize: 25,
              fontWeight:
              FontWeight.bold,
              color:
              Colors.green,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            '${approvalPercentage.toStringAsFixed(1)}%',
            style:
            const TextStyle(
              fontSize: 42,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const Text(
            'orientación del perfil',
            style:
            TextStyle(
              color:
              Colors.grey,
            ),
          ),

          if (riskLevel
              .toString()
              .trim()
              .isNotEmpty) ...[

            const SizedBox(height: 18),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),

              decoration:
              BoxDecoration(
                color:
                Colors.white,
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Text(
                'Nivel de riesgo: $riskLevel',
                style:
                const TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  //==============================================================
  // INFORMACIÓN
  //==============================================================

  Widget _buildInformationCard({
    required String firstName,
    required String lastName,
    required String countryCode,
    required String visaType,
  }) {

    return Card(

      elevation:
      2,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),

      child:
      Padding(

        padding:
        const EdgeInsets.all(
          18,
        ),

        child:
        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Información de la evaluación',
              style:
              TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            _infoRow(
              'Solicitante',
              '$firstName $lastName',
            ),

            _infoRow(
              'País',
              countryCode,
            ),

            _infoRow(
              'Tipo de visa',
              visaType,
            ),
          ],
        ),
      ),
    );
  }

  //==============================================================
  // RESPUESTAS
  //==============================================================

  Widget _buildAnswersSection(
      Map<String, dynamic> answers,
      ) {

    if (answers.isEmpty) {

      return Container(

        width:
        double.infinity,

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(

          color:
          Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(16),
        ),

        child:
        const Text(
          'Todavía no hay respuestas registradas.',
          textAlign:
          TextAlign.center,
        ),
      );
    }

    final answerCards =
    <Widget>[];

    for (final question
    in questions) {

      if (!answers.containsKey(
        question.questionKey,
      )) {
        continue;
      }

      final answer =
      answers[
      question.questionKey];

      answerCards.add(
        _buildAnswerCard(
          number: question.order,
          question: question.question,
          answer: answer,
        ),
      );
    }

    if (answerCards.isEmpty) {

      return Container(

        width:
        double.infinity,

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(

          color:
          Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(16),
        ),

        child:
        const Text(
          'No se pudieron relacionar las respuestas con las preguntas.',
          textAlign:
          TextAlign.center,
        ),
      );
    }

    return Column(
      children:
      answerCards,
    );
  }

  //==============================================================
  // TARJETA DE RESPUESTA
  //==============================================================

  Widget _buildAnswerCard({
    required int number,
    required String question,
    required dynamic answer,
  }) {

    String answerText;

    if (answer is List) {

      answerText =
          answer
              .map(
                (value) =>
                value.toString(),
          )
              .join(', ');

    } else {

      answerText =
          answer?.toString() ??
              'Sin respuesta';
    }

    return Container(

      width:
      double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(

        color:
        Colors.white,

        borderRadius:
        BorderRadius.circular(17),

        border:
        Border.all(
          color:
          Colors.grey.shade300,
        ),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius:
            6,

            offset:
            const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            'Pregunta $number',
            style:
            const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.bold,
              color:
              Colors.blue,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            question,
            style:
            const TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          Container(

            width:
            double.infinity,

            padding:
            const EdgeInsets.all(
              14,
            ),

            decoration:
            BoxDecoration(

              color:
              Colors.blue.withOpacity(
                0.05,
              ),

              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),

            child:
            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(
                  'Tu respuesta',
                  style:
                  TextStyle(
                    fontSize: 13,
                    color:
                    Colors.grey,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  answerText,
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // VISA ASSIST PLUS
  //==============================================================

  Widget _buildPremiumCard() {

    final data =
        evaluationData ?? {};

    final status =
        data['status'] ??
            'waiting_payment';

    final premiumUnlocked =
        data['premiumUnlocked'] == true;

    final premiumPaid =
        data['premiumPaid'] == true;

    final currentQuestion =
    _toInt(
      data['currentQuestion'],
    );

//============================================================
// COMPROBAR SI YA EXISTE UN PAGO ENVIADO
//============================================================

    final paymentReceipt =
    data['paymentReceipt'];

    final paymentReference =
    data['paymentReference'];

    final paymentDate =
    data['paymentDate'];

    final paymentSubmitted =
        status == 'payment_pending' ||
            paymentReceipt != null &&
                paymentReceipt.toString().trim().isNotEmpty ||
            paymentReference != null &&
                paymentReference.toString().trim().isNotEmpty ||
            paymentDate != null;

    //============================================================
// EVALUACIÓN COMPLETA
//============================================================

    if (status == 'completed') {

      return Container(

        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(

          color: Colors.green.withOpacity(0.08),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: Colors.green.withOpacity(0.30),
          ),
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                const Icon(
                  Icons.workspace_premium,
                  color: Colors.green,
                  size: 32,
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Visa Assist Plus completado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Text(
              'Has completado todas las preguntas de la evaluación. Aquí puedes consultar tus respuestas y el resultado completo.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.description_outlined,
                ),
                label: const Text(
                  'INICIAR PROCESO DE VISA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const MyExpedientesScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

//============================================================
// PAGO YA APROBADO - CONTINUAR DESDE LA 11
//============================================================

    if (premiumUnlocked &&
        premiumPaid &&
        currentQuestion >= 11) {

      return Container(

        width:
        double.infinity,

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(

          color:
          Colors.green.withOpacity(0.08),

          borderRadius:
          BorderRadius.circular(20),

          border:
          Border.all(
            color:
            Colors.green.withOpacity(0.30),
          ),
        ),

        child:
        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                const Icon(
                  Icons.workspace_premium,
                  color:
                  Colors.green,
                  size:
                  32,
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child:
                  Text(
                    'Visa Assist Plus desbloqueado',
                    style:
                    TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Text(
              'Tu pago fue aprobado. Ya puedes continuar con la evaluación completa desde la pregunta 11.',
              style:
              TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(

              width:
              double.infinity,

              height:
              55,

              child:
              ElevatedButton.icon(

                icon:
                const Icon(
                  Icons.play_arrow,
                ),

                label:
                const Text(
                  'CONTINUAR CON LA PREGUNTA 11',
                  style:
                  TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                onPressed: () {

                  final countryCode =
                      data['countryCode'] ??
                          'usa';

                  final visaType =
                      data['visaType'] ??
                          'turismo';

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          EvaluationQuestionScreen(

                            evaluationId:
                            widget.evaluationId,

                            countryCode:
                            countryCode,

                            visaType:
                            visaType,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    //============================================================
    // PAGO EN REVISIÓN
    //============================================================

    if (paymentSubmitted &&
        !premiumUnlocked &&
        !premiumPaid) {

      return Container(

        width:
        double.infinity,

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(

          color:
          Colors.blue.withOpacity(0.08),

          borderRadius:
          BorderRadius.circular(20),

          border:
          Border.all(
            color:
            Colors.blue.withOpacity(0.25),
          ),
        ),

        child:
        const Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Icon(
                  Icons.hourglass_top,
                  color:
                  Colors.blue,
                  size:
                  32,
                ),

                SizedBox(width: 12),

                Expanded(
                  child:
                  Text(
                    'Pago en revisión',
                    style:
                    TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),

            Text(
              'Ya registramos tu pago y recibimos tu comprobante. El pago está pendiente de aprobación por nuestro equipo. No necesitas realizar otro pago. Cuando sea aprobado podrás continuar desde la pregunta 11.',
              style:
              TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    //============================================================
    // PENDIENTE DE PAGO
    //============================================================

    return Container(

      width:
      double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(

        color:
        Colors.orange.withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(20),

        border:
        Border.all(
          color:
          Colors.orange.withOpacity(0.30),
        ),
      ),

      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              const Icon(
                Icons.workspace_premium,
                color:
                Colors.orange,
                size:
                32,
              ),

              const SizedBox(width: 12),

              const Expanded(
                child:
                Text(
                  'Visa Assist Plus',
                  style:
                  TextStyle(
                    fontSize: 21,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Ya completaste las 10 preguntas iniciales. Puedes continuar con la evaluación completa y acceder al análisis Premium.',
            style:
            TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(

            width:
            double.infinity,

            height:
            56,

            child:
            ElevatedButton.icon(

              icon:
              const Icon(
                Icons.payment,
              ),

              label:
              const Text(
                'PAGAR Y CONTINUAR',
                style:
                TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        PaymentScreen(

                          evaluationId:
                          widget.evaluationId,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // CONVERTIR RESPUESTAS
  //==============================================================

  Map<String, dynamic> _getAnswers(
      dynamic value,
      ) {

    if (value is Map) {

      return Map<String, dynamic>.from(
        value,
      );
    }

    return {};
  }

  //==============================================================
  // CONVERTIR DOUBLE
  //==============================================================

  //==============================================================
// CONVERTIR DOUBLE
//==============================================================

  double _toDouble(
      dynamic value,
      ) {

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(
        value,
      ) ??
          0.0;
    }

    return 0.0;
  }

//==============================================================
// CONVERTIR INT
//==============================================================

  int _toInt(
      dynamic value,
      ) {

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(
        value,
      ) ??
          0;
    }

    return 0;
  }

  //==============================================================
  // FILA DE INFORMACIÓN
  //==============================================================

  Widget _infoRow(
      String title,
      String value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),

      child:
      Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            width:
            120,

            child:
            Text(
              title,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child:
            Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

//==============================================================
// SECCIÓN DE RESULTADOS
//==============================================================

  Widget _resultSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {

    return Container(

      width:
      double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(

        color:
        color.withOpacity(0.07),

        borderRadius:
        BorderRadius.circular(18),

        border:
        Border.all(
          color:
          color.withOpacity(0.25),
        ),
      ),

      child:
      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Icon(
                icon,
                color:
                color,
                size:
                30,
              ),

              const SizedBox(width: 12),

              Expanded(
                child:
                Text(
                  title,
                  style:
                  TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                    color:
                    color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...items.map(
                (item) => Padding(

              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),

              child:
              Row(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.circle,
                    size: 8,
                    color:
                    color,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    Text(
                      item,
                      style:
                      const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}