import 'package:flutter/material.dart';

import '../portal/portal_screen.dart';

class EvaluationSubmittedScreen extends StatelessWidget {
  final String evaluationId;
  final String countryCode;
  final String visaType;

  const EvaluationSubmittedScreen({
    super.key,
    required this.evaluationId,
    required this.countryCode,
    required this.visaType,
  });

  String get countryName {
    switch (countryCode.toUpperCase()) {
      case 'US':
      case 'USA':
        return 'Estados Unidos';

      case 'CA':
        return 'Canadá';

      case 'ES':
        return 'España';

      case 'MX':
        return 'México';

      case 'DO':
        return 'República Dominicana';

      default:
        return countryCode;
    }
  }

  String get visaName {
    switch (visaType.toLowerCase()) {
      case 'b1':
        return 'Turismo / Negocios B1';

      case 'b2':
        return 'Turismo B2';

      case 'b1/b2':
      case 'b1b2':
        return 'Turismo / Negocios B1/B2';

      case 'f1':
        return 'Estudiante F1';

      case 'j1':
        return 'Intercambio J1';

      default:
        return visaType;
    }
  }

  void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const PortalScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Evaluación enviada',
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 25),

              //==================================================
              // ICONO DE CONFIRMACIÓN
              //==================================================

              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 85,
                ),
              ),

              const SizedBox(height: 30),

              //==================================================
              // TÍTULO
              //==================================================

              const Text(
                '¡Evaluación enviada!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Tu evaluación de perfil fue enviada correctamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              //==================================================
              // INFORMACIÓN DE LA EVALUACIÓN
              //==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
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
                      'Evaluación realizada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _InfoRow(
                      icon: Icons.public,
                      title: 'País',
                      value: countryName,
                    ),

                    const SizedBox(height: 18),

                    _InfoRow(
                      icon: Icons.assignment,
                      title: 'Categoría / Visa',
                      value: visaName,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //==================================================
              // INFORMACIÓN AL CLIENTE
              //==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 45,
                    ),

                    SizedBox(height: 15),

                    Text(
                      '¿Qué sigue ahora?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      'Hemos recibido correctamente la información proporcionada durante tu evaluación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Cuando el resultado esté disponible podrás consultarlo desde la sección de tus evaluaciones.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              //==================================================
              // BOTÓN HOME
              //==================================================

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    goToHome(context);
                  },
                  icon: const Icon(
                    Icons.home,
                  ),
                  label: const Text(
                    'IR AL HOME',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //==================================================
              // AVISO LEGAL
              //==================================================

              const Text(
                'Esta evaluación es únicamente una orientación y no garantiza la aprobación de una visa. La decisión final corresponde exclusivamente a la autoridad consular.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

//==============================================================
// FILA DE INFORMACIÓN
//==============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 28,
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}