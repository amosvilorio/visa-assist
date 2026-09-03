import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'free_summary_screen.dart';
import '../payment/payment_screen.dart';
import '../../models/evaluation_result.dart';


class ContinueEvaluationScreen extends StatefulWidget {

  final String evaluationId;

  final EvaluationResult result;

  const ContinueEvaluationScreen({

    super.key,

    required this.evaluationId,

    required this.result,

  });

  @override
  State<ContinueEvaluationScreen> createState() =>
      _ContinueEvaluationScreenState();
}

class _ContinueEvaluationScreenState
    extends State<ContinueEvaluationScreen> {

  Map<String, dynamic>? settings;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {

    final doc = await FirebaseFirestore.instance
        .collection("settings")
        .doc("general")
        .get();

    if (!doc.exists) {
      throw Exception(
        "No existe la configuración general de la aplicación.",
      );
    }

    settings = doc.data()!;

    if (mounted) {
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {

    if (settings == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 10),

              const Icon(
                Icons.assignment_turned_in,
                color: Colors.green,
                size: 90,
              ),

              const SizedBox(height: 25),

              const Text(
                "Tu evaluación inicial ha finalizado",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Ya analizamos una parte importante de tu perfil migratorio.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Con esta información podemos ofrecerte una orientación general. Sin embargo, todavía existen factores importantes que pueden influir en una decisión consular y que aún no han sido analizados.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Al continuar obtendrás:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              beneficio(Icons.check_circle, "Evaluación completa de tu perfil."),

              beneficio(Icons.check_circle, "Fortalezas detectadas."),

              beneficio(Icons.check_circle, "Debilidades detectadas."),

              beneficio(Icons.check_circle, "Recomendaciones personalizadas."),

              beneficio(Icons.check_circle, "Análisis por categorías."),

              beneficio(Icons.check_circle, "Riesgos que pueden afectar tu solicitud."),

              beneficio(Icons.check_circle, "Informe profesional disponible cuando lo necesites."),

              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F7FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.shade100,
                  ),
                ),
                child: Column(
                  children: [

                    const Text(
                      "Valor de la evaluación completa",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${settings!["currencySymbol"] ?? "RD\$"} ${settings!["evaluationPrice"] ?? 0}",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Podrás continuar exactamente donde terminó tu evaluación.",
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FreeSummaryScreen(
                          result: widget.result,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "FINALIZAR POR AHORA",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(

                  onPressed: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => PaymentScreen(

                          evaluationId: widget.evaluationId,

                        ),

                      ),

                    );

                  },

                  child: const Text(
                    "CONTINUAR EVALUACIÓN",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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

  Widget beneficio(
      IconData icon,
      String texto,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: Colors.green,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 17,
                height: 1.4,
              ),
            ),
          ),

        ],
      ),
    );
  }
}