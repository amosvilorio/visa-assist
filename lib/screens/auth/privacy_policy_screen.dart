import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Política de Privacidad"),
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
                    "POLÍTICA DE PRIVACIDAD",
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
                    "Visa Assist es una aplicación privada diseñada para ayudar a los usuarios a organizar la información necesaria para la preparación de solicitudes de visa para los Estados Unidos. Nuestra prioridad es proteger su privacidad y garantizar el tratamiento responsable de su información personal.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "1. Información que recopilamos",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Podemos recopilar la siguiente información:\n\n"
                        "• Nombre y apellidos.\n"
                        "• Dirección de correo electrónico.\n"
                        "• Número de teléfono.\n"
                        "• Información requerida para completar expedientes de visa.\n"
                        "• Documentos e imágenes que el usuario decida cargar.\n"
                        "• Información necesaria para brindar recomendaciones dentro de la aplicación.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "2. Uso de la información",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "La información recopilada se utiliza exclusivamente para:\n\n"
                        "• Crear y administrar expedientes.\n"
                        "• Ayudar al usuario a organizar la información necesaria para su solicitud de visa.\n"
                        "• Generar recomendaciones dentro de la aplicación.\n"
                        "• Mejorar nuestros servicios.\n"
                        "• Brindar soporte cuando sea necesario.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "3. Protección de los datos",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "La información es almacenada utilizando servicios seguros de Google Firebase. Aplicamos medidas técnicas y organizativas para proteger los datos frente a accesos no autorizados, alteraciones o pérdidas.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "4. Compartición de información",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Visa Assist no vende, alquila ni comercializa la información personal de sus usuarios. La información únicamente podrá ser compartida cuando exista una obligación legal o sea requerida por una autoridad competente conforme a la legislación aplicable.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "5. Eliminación de la cuenta",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "El usuario podrá solicitar la eliminación de su cuenta y de su información personal desde la aplicación o escribiendo al correo de soporte indicado en esta política.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "6. Aplicación independiente",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Visa Assist es una aplicación privada e independiente. No está afiliada, respaldada, autorizada ni representa al Gobierno de los Estados Unidos, al Departamento de Estado de los Estados Unidos (U.S. Department of State), USCIS ni a ninguna Embajada o Consulado de los Estados Unidos.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "7. Fuentes oficiales",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "La información oficial relacionada con visas debe verificarse siempre en los sitios oficiales del Gobierno de los Estados Unidos.\n\n"
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
                    "8. Cambios en esta política",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Esta Política de Privacidad podrá actualizarse periódicamente para reflejar mejoras en nuestros servicios o cambios legales. La versión más reciente estará siempre disponible dentro de la aplicación.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 25),

                  Text(
                    "9. Contacto",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Si tiene preguntas relacionadas con esta Política de Privacidad o desea solicitar la eliminación de su cuenta, puede comunicarse con nosotros a través del siguiente correo:\n\n"
                        "amosvilorio@gmail.com",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 35),

                  Text(
                    "Al utilizar Visa Assist, usted acepta esta Política de Privacidad.",
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