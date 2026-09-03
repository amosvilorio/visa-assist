import 'package:flutter/material.dart';

import 'new_evaluation_screen.dart';
import 'evaluation_history_screen.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({
    super.key,
  });

  static const Color navy = Color(0xff073477);
  static const Color blue = Color(0xff1455A3);
  static const Color red = Color(0xffE30613);
  static const Color lightBlue = Color(0xffEEF5FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Evaluación de Perfil',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            20,
            18,
            30,
          ),
          child: Column(
            children: [

              //================================================
// ENCABEZADO DE EVALUACIÓN
//================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  15,
                  16,
                  15,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff073477),
                      Color(0xff154F9C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    //================================================
                    // INFORMACIÓN DE LA EVALUACIÓN
                    //================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: const [

                          Text(
                            'EVALUACIÓN',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),

                          SizedBox(height: 7),

                          Text(
                            'Perfil migratorio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Analiza tu perfil antes de solicitar tu visa',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //================================================
                    // VISA ASSIST
                    //================================================

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: const [

                        Text(
                          'VISA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 0.95,
                          ),
                        ),

                        Text(
                          'ASSIST',
                          style: TextStyle(
                            color: Color(0xffE30613),
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            height: 0.95,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================================================
              // NUEVA EVALUACIÓN
              //================================================

              _MenuCard(
                icon: Icons.add_circle_outline,
                title: 'Nueva evaluación',
                subtitle:
                'Analiza tu perfil migratorio',
                iconColor: red,
                buttonText: 'COMENZAR',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const NewEvaluationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              //================================================
              // HISTORIAL
              //================================================

              _MenuCard(
                icon: Icons.history,
                title: 'Mis evaluaciones',
                subtitle:
                'Consulta tus evaluaciones anteriores',
                iconColor: navy,
                buttonText: 'VER HISTORIAL',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const EvaluationHistoryScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              //================================================
              // QUÉ RECIBIRÉ
              //================================================

              _MenuCard(
                icon: Icons.card_giftcard_outlined,
                title: '¿Qué recibiré?',
                subtitle:
                'Conoce lo que incluye tu evaluación',
                iconColor: const Color(0xff1687D9),
                buttonText: 'VER INFORMACIÓN',
                onPressed: () {
                  _showBenefits(context);
                },
              ),

              const SizedBox(height: 22),

              //================================================
              // MENSAJE PEQUEÑO
              //================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: blue.withOpacity(0.20),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: navy,
                      size: 22,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Tu información se mantiene protegida durante todo el proceso.',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          height: 1.35,
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
  }

  //============================================================
  // VENTANA ¿QUÉ RECIBIRÉ?
  //============================================================

  static void _showBenefits(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                // Barra superior
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: red.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: red,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  '¿Qué recibiré?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Al completar tu evaluación podrás conocer:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 22),

                _BenefitItem(
                  icon: Icons.analytics_outlined,
                  title: 'Análisis de tu perfil',
                  description:
                  'Evaluamos diferentes aspectos de tu situación.',
                ),

                _BenefitItem(
                  icon: Icons.thumb_up_alt_outlined,
                  title: 'Fortalezas',
                  description:
                  'Identificamos los aspectos favorables de tu perfil.',
                ),

                _BenefitItem(
                  icon: Icons.warning_amber_outlined,
                  title: 'Posibles riesgos',
                  description:
                  'Señalamos aspectos que podrían requerir atención.',
                ),

                _BenefitItem(
                  icon: Icons.lightbulb_outline,
                  title: 'Recomendaciones',
                  description:
                  'Recibirás orientación basada en tus respuestas.',
                ),

                _BenefitItem(
                  icon: Icons.history,
                  title: 'Consulta posterior',
                  description:
                  'Podrás consultar tu evaluación desde tu historial.',
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: red,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'CERRAR',
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//==============================================================
// TARJETA PRINCIPAL
//==============================================================

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onPressed;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          //====================================================
          // ICONO
          //====================================================

          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 31,
            ),
          ),

          const SizedBox(width: 15),

          //====================================================
          // TEXTO + BOTÓN
          //====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff222222),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 11),

                SizedBox(
                  height: 39,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xffE30613),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Color(0xff073477),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//==============================================================
// ELEMENTO DE BENEFICIO
//==============================================================

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xff073477)
                  .withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xff073477),
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff073477),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}