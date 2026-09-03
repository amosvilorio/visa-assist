import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Términos y Condiciones"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "TÉRMINOS Y CONDICIONES",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Última actualización: Agosto 2026",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "Bienvenido a Visa Assist. Al utilizar esta aplicación usted acepta los presentes Términos y Condiciones de uso.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "1. Objeto de la aplicación",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Visa Assist es una aplicación privada diseñada para ayudar a los usuarios a organizar la información necesaria para la preparación de solicitudes de visa para los Estados Unidos.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "2. Aplicación independiente",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Visa Assist no está afiliada, respaldada, autorizada ni representa al Gobierno de los Estados Unidos, al Departamento de Estado de los Estados Unidos (U.S. Department of State), USCIS ni a ninguna Embajada o Consulado de los Estados Unidos.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "3. Fuentes oficiales",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "La información oficial relacionada con visas debe verificarse directamente en los sitios oficiales del Gobierno de los Estados Unidos.\n\n"
                        "• https://travel.state.gov\n\n"
                        "• https://ceac.state.gov/CEAC\n\n"
                        "• https://www.uscis.gov",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "4. Sin garantía de aprobación",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "El uso de Visa Assist no garantiza la aprobación de ninguna solicitud de visa. Todas las decisiones relacionadas con la aprobación o denegación de una visa son tomadas exclusivamente por las autoridades gubernamentales competentes.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "5. Responsabilidad del usuario",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "El usuario es responsable de proporcionar información veraz, completa y actualizada. Visa Assist no será responsable por errores derivados de información incorrecta suministrada por el usuario.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "6. Modificaciones",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Visa Assist podrá actualizar estos Términos y Condiciones cuando sea necesario. La versión más reciente estará disponible dentro de la aplicación.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "7. Contacto",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Si tiene preguntas relacionadas con estos Términos y Condiciones puede escribir a:\n\n"
                        "amosvilorio@gmail.com",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "Al crear una cuenta o utilizar Visa Assist, usted declara haber leído y aceptado estos Términos y Condiciones.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 40),

                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ACEPTAR",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}