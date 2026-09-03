import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../services/expediente_service.dart';
import '../../utils/app_colors.dart';
import '../passport/passport_verification_screen.dart';
import 'expediente_history_screen.dart';
import 'expediente_detail_screen.dart';

class MyExpedientesScreen extends StatefulWidget {
  const MyExpedientesScreen({super.key});

  @override
  State<MyExpedientesScreen> createState() =>
      _MyExpedientesScreenState();
}

class _MyExpedientesScreenState
    extends State<MyExpedientesScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: const Color(0xFF082D6B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Mis Solicitudes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 14),

          const Text(
            "Tus solicitudes de visa",
            style: TextStyle(
              color: Color(0xFF082D6B),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: 70,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE30613),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Aquí podrás continuar solicitudes existentes o crear una nueva.",
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 17,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 25),
          StreamBuilder<List<Expediente>>(

            stream: _expedienteService.getMyExpedientes(),

            builder: (context, snapshot) {

              if (snapshot.hasError) {

                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );

              }

              if (snapshot.connectionState == ConnectionState.waiting) {

                return const Center(
                  child: CircularProgressIndicator(),
                );

              }

              if (!snapshot.hasData) {

                return const Center(
                  child: Text("No hay datos."),
                );

              }

              final expedientes = snapshot.data!;

              if (expedientes.isEmpty) {

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(
                      color: const Color(0xFFE30613),
                      width: 1.5,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: const Padding(

                    padding: EdgeInsets.all(20),

                    child: Column(

                      children: [

                        Icon(
                          Icons.description,
                          size: 70,
                        ),

                        SizedBox(height: 15),

                        Text(

                          "Todavía no tienes solicitudes.",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        SizedBox(height: 10),

                        Text(

                          "Presiona el botón inferior para crear tu primera solicitud.",

                          textAlign: TextAlign.center,

                        ),

                      ],

                    ),

                  ),

                );

              }

              return Column(

                children: expedientes.map((expediente) {

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(24),

                      border: Border.all(
                        color: const Color(0xFFE30613),
                        width: 1.5,
                      ),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExpedienteDetailScreen(
                              expediente: expediente,
                            ),
                          ),
                        );
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Row(
                          children: [

                            Container(
                              width: 64,
                              height: 64,

                              decoration: const BoxDecoration(
                                color: Color(0xFFE8EEF9),
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.description_outlined,
                                color: Color(0xFF082D6B),
                                size: 34,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    expediente.applicant != null
                                        ? "Solicitud de ${expediente.applicant!.firstName} ${expediente.applicant!.lastName}"
                                        : "Solicitud en proceso",

                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),

                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8EEF9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      _getCurrentStage(
                                        expediente.currentStep,
                                      ),

                                      style: const TextStyle(
                                        color: Color(0xFF0A3B91),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF082D6B),
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                }).toList(),

              );

            },

          ),

          const SizedBox(height: 35),

          Container(
            height: 76,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: const Color(0xFFE30613),
                width: 1.5,
              ),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFF082D6B),
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ExpedienteHistoryScreen(),
                  ),
                );
              },

              child: Row(
                children: [

                  Container(
                    width: 48,
                    height: 48,

                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EEF9),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.history,
                      color: Color(0xFF082D6B),
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          "HISTORIAL DE SOLICITUDES",
                          style: TextStyle(
                            color: Color(0xFF082D6B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          "Consulta tus procesos finalizados",
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF082D6B),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            height: 62,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: const Color(0xFFE30613),
                width: 1.5,
              ),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFF082D6B),
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              icon: const Icon(
                Icons.add_circle_outline,
                size: 30,
                color: Color(0xFF082D6B),
              ),

              label: const Text(
                "NUEVA SOLICITUD",

                style: TextStyle(
                  color: Color(0xFF082D6B),
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const PassportVerificationScreen(),
                  ),
                );
              },
            ),
          ),
        ],

      ),

    );

  }

  String _getCurrentStage(int step) {

    switch (step) {

      case 1:
        return "Verificación del pasaporte";

      case 2:
        return "Selección del país";

      case 3:
        return "Tipo de visa";

      case 4:
        return "Creación del expediente";

      case 5:
        return "Datos del solicitante";

      case 6:
        return "Información personal";

      case 7:
        return "Información del pasaporte";

      case 8:
        return "Dirección y contacto";

      case 9:
        return "Información del viaje";

      case 10:
        return "Historial de viajes";

      case 11:
        return "Acompañante de viaje";

      case 12:
        return "Contacto en EE.UU.";

      case 13:
        return "Información familiar";

      case 14:
        return "Trabajo y educación";

      case 15:
        return "Seguridad y antecedentes";

      case 16:
        return "Información adicional";

      case 17:
        return "Revisión del expediente";

      case 18:
        return "Servicio contratado";

      default:
        return "En proceso";

    }

  }
}