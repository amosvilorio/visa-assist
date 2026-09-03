import 'package:flutter/material.dart';

class UnlockEvaluationScreen extends StatelessWidget {
  const UnlockEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Evaluación de Perfil"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                  children: [

                  const SizedBox(height: 15),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.psychology_alt,
                  color: Colors.green,
                  size: 55,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Primera etapa completada",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Ya analizamos la información básica de tu perfil migratorio.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Ahora puedes continuar con la evaluación completa para recibir un diagnóstico profesional y recomendaciones personalizadas.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [

                          Icon(
                            Icons.workspace_premium,
                            color: Colors.amber,
                            size: 32,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "La Evaluación Completa incluye:",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 25),

                      feature(
                        Icons.check_circle,
                        "Análisis completo de tu perfil migratorio.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Fortalezas detectadas en tu perfil.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Debilidades que podrían afectar tu solicitud.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Riesgos de una posible negación.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Recomendaciones personalizadas para fortalecer tu perfil.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Preparación del expediente para tu solicitud de visa.",
                      ),

                      feature(
                        Icons.check_circle,
                        "Acceso a todas las etapas del proceso hasta la entrevista consular.",
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Todavía no hemos terminado de evaluar tu perfil. Las primeras preguntas recopilan información básica; la segunda etapa permite generar un diagnóstico profesional mucho más preciso.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: const Text(
                          "CONTINUAR EVALUACIÓN COMPLETA",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // Próximo paso:
                          // Pantalla de pago
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "FINALIZAR AQUÍ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Podrás continuar tu evaluación más adelante sin perder tu progreso.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                  ],
              ),
            ),
        ),
    );
  }

  Widget feature(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}