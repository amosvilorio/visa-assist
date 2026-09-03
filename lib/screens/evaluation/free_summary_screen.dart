import 'package:flutter/material.dart';
import '../expedientes/my_expedientes_screen.dart';
import '../../models/evaluation_result.dart';

class FreeSummaryScreen extends StatelessWidget {

  final EvaluationResult result;

  const FreeSummaryScreen({

    super.key,

    required this.result,

  });

  //--------------------------------------------------
  // COLOR DEL PERFIL
  //--------------------------------------------------

  Color get profileColor {

    switch (result.profileLevel) {

      case "Perfil Muy Fuerte":
        return Colors.green;

      case "Perfil Fuerte":
        return Colors.lightGreen;

      case "Perfil Bueno":
        return Colors.blue;

      case "Perfil Moderado":
        return Colors.orange;

      default:
        return Colors.red;

    }

  }

  //--------------------------------------------------
  // ICONO DEL PERFIL
  //--------------------------------------------------

  IconData get profileIcon {

    switch (result.profileLevel) {

      case "Perfil Muy Fuerte":
        return Icons.workspace_premium;

      case "Perfil Fuerte":
        return Icons.verified;

      case "Perfil Bueno":
        return Icons.thumb_up;

      case "Perfil Moderado":
        return Icons.warning_amber;

      default:
        return Icons.error;

    }

  }

  //--------------------------------------------------
  // PORCENTAJE
  //--------------------------------------------------

  double get progress {

    if (result.approvalPercentage <= 0) {
      return .01;
    }

    return result.approvalPercentage / 100;

  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  //--------------------------------------------------
// TARJETA DE CATEGORÍA
//--------------------------------------------------

  Widget categoryCard({
    required String title,
    required int score,
    required int maxScore,
  }) {

    final percent =
    maxScore == 0 ? 0.0 : score / maxScore;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              borderRadius:
              BorderRadius.circular(20),
            ),

          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: const Text(
            "Informe Profesional",
          ),

          centerTitle: true,

        ),

        body: SafeArea(

            child: SingleChildScrollView(

                padding: const EdgeInsets.all(20),

                child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                    children: [

                  //--------------------------------------------------
                  // ENCABEZADO
                  //--------------------------------------------------

                  Card(

                  elevation: 6,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(20),

                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(24),

                    child: Column(

                      children: [

                        Icon(

                          profileIcon,

                          color: profileColor,

                          size: 90,

                        ),

                        const SizedBox(height: 20),

                        const Text(

                          "Resultado de la Evaluación",

                          style: TextStyle(

                            fontSize: 26,

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        const SizedBox(height: 10),

                        Text(

                          result.profileLevel,

                          style: TextStyle(

                            fontSize: 22,

                            fontWeight: FontWeight.bold,

                            color: profileColor,

                          ),

                        ),

                        const SizedBox(height: 25),

                        ClipRRect(

                          borderRadius:

                          BorderRadius.circular(30),

                          child: LinearProgressIndicator(

                            value: progress,

                            minHeight: 16,

                            color: profileColor,

                            backgroundColor:

                            Colors.grey.shade300,

                          ),

                        ),

                        const SizedBox(height: 18),

                        Text(

                          "${result.approvalPercentage.toStringAsFixed(1)} %",

                          style: TextStyle(

                            fontSize: 36,

                            fontWeight: FontWeight.bold,

                            color: profileColor,

                          ),

                        ),

                        const Text(

                          "Probabilidad estimada",

                          style: TextStyle(

                            fontSize: 16,

                            color: Colors.grey,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),

              const SizedBox(height: 25),

              //--------------------------------------------------
              // RESUMEN
              //--------------------------------------------------

              Card(

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(20),

                ),

                child: Padding(

                  padding: const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      ListTile(

                        leading: const Icon(

                          Icons.shield,

                        ),

                        title: const Text(

                          "Nivel de riesgo",

                        ),

                        trailing: Text(

                          result.riskLevel,

                          style: const TextStyle(

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                      ),

                      const Divider(),

                      ListTile(

                        leading: const Icon(

                          Icons.score,

                        ),

                        title: const Text(

                          "Puntaje obtenido",

                        ),

                        trailing: Text(

                          "${result.totalScore} / ${result.maxScore}",

                          style: const TextStyle(

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 25),

                      //--------------------------------------------------
// RESULTADO POR CATEGORÍAS
//--------------------------------------------------

                      const SizedBox(height: 25),

                      const Text(
                        "Resultado por categorías",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...result.categoryScores.entries.map(

                            (entry) {

                          return categoryCard(

                            title: entry.key,

                            score: entry.value,

                            maxScore:
                            result.categoryMaxScores[entry.key] ?? 0,

                          );

                        },

                      ),

                      //--------------------------------------------------
// FORTALEZAS
//--------------------------------------------------

                      if (result.strengths.isNotEmpty) ...[

                        const SizedBox(height: 25),

                        const Text(
                          "Fortalezas",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: result.strengths.map((item) {

                                return ListTile(
                                  leading: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  title: Text(item),
                                );

                              }).toList(),
                            ),
                          ),
                        ),

                      ],

                      //--------------------------------------------------
// DEBILIDADES
//--------------------------------------------------

                      if (result.weaknesses.isNotEmpty) ...[

                        const SizedBox(height: 25),

                        const Text(
                          "Debilidades",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: result.weaknesses.map((item) {

                                return ListTile(
                                  leading: const Icon(
                                    Icons.warning_amber,
                                    color: Colors.orange,
                                  ),
                                  title: Text(item),
                                );

                              }).toList(),
                            ),
                          ),
                        ),

                      ],

                      //--------------------------------------------------
// RECOMENDACIONES
//--------------------------------------------------

                      if (result.recommendations.isNotEmpty) ...[

                        const SizedBox(height: 25),

                        const Text(
                          "Recomendaciones",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: result.recommendations.map((item) {

                                return ListTile(
                                  leading: const Icon(
                                    Icons.lightbulb,
                                    color: Colors.blue,
                                  ),
                                  title: Text(item),
                                );

                              }).toList(),
                            ),
                          ),
                        ),

                      ],

              //--------------------------------------------------
              // RECOMENDACIÓN VISA ASSIST
              //--------------------------------------------------

              Card(

                color: Colors.blue.shade50,

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(20),

                ),

                child: Padding(

                  padding: const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Row(

                        children: [

                          Icon(
                            Icons.tips_and_updates,
                            color: Colors.blue,
                          ),

                          SizedBox(width: 10),

                          Text(

                            "Recomendación Visa Assist",

                            style: TextStyle(

                              fontSize: 20,

                              fontWeight: FontWeight.bold,

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 15),

                      Text(

                        result.visaAssistRecommendation,

                        style: const TextStyle(

                          fontSize: 17,

                          height: 1.5,

                        ),

                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 25),

              //--------------------------------------------------
              // MENSAJE LEGAL
              //--------------------------------------------------

              Card(

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(20),

                ),

                child: Padding(

                  padding: const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Row(

                        children: [

                          Icon(

                            Icons.gavel,

                            color: Colors.orange,

                          ),

                          SizedBox(width: 10),

                          Text(

                            "Aviso Legal",

                            style: TextStyle(

                              fontSize: 20,

                              fontWeight: FontWeight.bold,

                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 15),

                      Text(

                        result.legalMessage,

                        style: const TextStyle(

                          fontSize: 16,

                          height: 1.5,

                        ),

                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

                      //--------------------------------------------------
// BOTONES
//--------------------------------------------------

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.description),
                          label: const Text(
                            "INICIAR PROCESO DE VISA",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyExpedientesScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.home),
                          label: const Text(
                            "VOLVER AL INICIO",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                                  (route) => route.isFirst,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                    ],

                ),

            ),

        ),

    );

  }

}