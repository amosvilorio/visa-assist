import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ============================================================
          // FONDO
          // ============================================================

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF041B4D),
                  Color(0xFF082A6A),
                  Color(0xFF041B4D),
                ],
              ),
            ),
          ),

          // ============================================================
          // DEGRADADO INFERIOR
          // ============================================================

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFF0A3B91),
                    Color(0xFFE30613),
                  ],
                ),
              ),
            ),
          ),

          // ============================================================
          // CONTENIDO
          // ============================================================

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // ==================================================
                      // PARTE SUPERIOR
                      // ==================================================

                      Column(
                        children: [

                          const SizedBox(height: 4),

                          // LOGO
                          RichText(
                            text: const TextSpan(
                              children: [

                                TextSpan(
                                  text: "VISA ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 43,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),

                                TextSpan(
                                  text: "ASSIST",
                                  style: TextStyle(
                                    color: Color(0xFFE31C24),
                                    fontSize: 43,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 3),

                          // LINEA + ESTRELLA
                          const Row(
                            children: [

                              Expanded(
                                child: Divider(
                                  color: Colors.white54,
                                  thickness: 1,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 9,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: Colors.white54,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          // ESLOGAN
                          const Text(
                            "PREPÁRATE • CONFÍA • LOGRA TU VISA",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: .4,
                            ),
                          ),

                          const SizedBox(height: 13),

                          // TITULO
                          const Text(
                            "Visa Assist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // DESCRIPCIÓN
                          const Text(
                            "Tu asistente para organizar y preparar\n"
                                "la información de tu solicitud de visa.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                              height: 1.25,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ==================================================
                          // FUNCIONES
                          // ==================================================

                          feature("Evaluación"),
                          feature("Expedientes familiares"),
                          feature("Orientación personalizada"),
                          feature("Seguimiento del proceso"),
                        ],
                      ),

                      // ==================================================
                      // PARTE INFERIOR
                      // ==================================================

                      Column(
                        children: [

                          const SizedBox(height: 8),

                          // ==================================================
                          // INICIAR SESIÓN
                          // ==================================================

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 6,
                                shadowColor: Colors.black38,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "INICIAR SESIÓN",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 9),

                          // ==================================================
                          // CREAR CUENTA
                          // ==================================================

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "CREAR CUENTA",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==================================================
                          // INFORMACIÓN LEGAL
                          // ==================================================

                          const Divider(
                            color: Colors.white38,
                            thickness: 1,
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Visa Assist ayuda a organizar la información necesaria\n"
                                "para preparar una solicitud de visa.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.25,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Row(
                            children: [

                              Expanded(
                                child: Divider(
                                  color: Colors.white38,
                                  thickness: 1,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: Colors.white38,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "La aprobación depende exclusivamente de la\n"
                                "autoridad consular correspondiente.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 3),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ELEMENTO DE CARACTERÍSTICA
  // ============================================================

  Widget feature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.check,
              color: AppColors.primary,
              size: 16,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}