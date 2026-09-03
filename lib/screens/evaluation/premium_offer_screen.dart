import 'package:flutter/material.dart';

class PremiumOfferScreen extends StatelessWidget {
  const PremiumOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Visa Assist Plus"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  const SizedBox(height: 10),

              Container(
                width: 95,
                height: 95,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.green,
                  size: 60,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Continúa con Visa Assist Plus",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Has completado correctamente la primera etapa de tu evaluación.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Ahora puedes desbloquear el análisis profesional y recibir acompañamiento durante todo tu proceso de visa.",
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
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [

                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 30,
                          ),

                          SizedBox(width: 10),

                          Text(
                            "Todo lo que incluye",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 25),

                      benefit(
                        Icons.analytics,
                        "Evaluación completa de tu perfil migratorio.",
                      ),

                      benefit(
                        Icons.check_circle,
                        "Identificación de fortalezas de tu perfil.",
                      ),

                      benefit(
                        Icons.warning_amber,
                        "Detección de debilidades y factores de riesgo.",
                      ),

                      benefit(
                        Icons.psychology,
                        "Recomendaciones personalizadas para aumentar tus posibilidades de aprobación.",
                      ),

                      benefit(
                        Icons.folder_shared,
                        "Creación de tu expediente de visa paso a paso.",
                      ),

                      benefit(
                        Icons.description,
                        "Preparación de toda la información necesaria para el formulario DS-160.",
                      ),

                      benefit(
                        Icons.notifications_active,
                        "Seguimiento del proceso con recordatorios importantes.",
                      ),

                      benefit(
                        Icons.support_agent,
                        "Acompañamiento durante todas las etapas de tu solicitud de visa.",
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.amber.shade300,
                  ),
                ),
                child: const Column(
                  children: [

                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      size: 34,
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Muchos solicitantes son rechazados por errores que pueden evitarse antes de presentar la solicitud.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Visa Assist Plus analiza tu perfil, identifica posibles riesgos y te ayuda a fortalecer tu caso antes de iniciar el proceso consular.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 30),

                    const Text(
                      "Inversión",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "RD\$ 0.00",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Pago único",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: const Text(
                          "CONTINUAR AL PAGO",
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
                          // PaymentScreen()
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
                          "MÁS TARDE",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Tu progreso quedará guardado para que puedas continuar la evaluación cuando lo desees.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
              ),
            ),
        ),
    );
  }

  Widget benefit(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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