import 'package:flutter/material.dart';

import 'case_status_list_screen.dart';
import '../../../models/expediente.dart';
import '../../../services/expediente_service.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() =>
      _CasesScreenState();
}

class _CasesScreenState
    extends State<CasesScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  //==================================================
  // ABRIR SECCIÓN
  //==================================================

  void _abrirSeccion({
    required BuildContext context,
    required String status,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CaseStatusListScreen(
              status: status,
              title: title,
              subtitle: subtitle,
              color: color,
              icon: icon,
            ),
      ),
    );
  }

  //==================================================
  // TARJETA DE OPCIÓN
  //==================================================

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String status,
    required Color color,
    required IconData icon,
    required int count,
  }) {

    return Card(

      elevation: 3,

      margin:
      const EdgeInsets.only(
        bottom: 15,
      ),

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: InkWell(

        borderRadius:
        BorderRadius.circular(18),

        onTap: () {

          _abrirSeccion(
            context: context,
            status: status,
            title: title,
            subtitle: subtitle,
            color: color,
            icon: icon,
          );
        },

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Row(

            children: [

              CircleAvatar(

                radius: 30,

                backgroundColor:
                color.withOpacity(.12),

                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 18,
              ),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      title,

                      style:
                      const TextStyle(
                        fontSize: 19,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      subtitle,
                      style:
                      const TextStyle(
                        color: Colors.grey,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(

                      count == 1
                          ? "1 expediente"
                          : "$count expedientes",

                      style:
                      TextStyle(
                        color: color,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Expedientes",
        ),

        centerTitle: true,
      ),

      body:

      StreamBuilder<
          List<Expediente>>(
        stream:
        _expedienteService
            .getAllExpedientes(),

        builder:
            (context, snapshot) {

          if (snapshot
              .connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          final expedientes =
              snapshot.data ?? [];

          final porCompletar =
              expedientes
                  .where(
                    (e) =>
                e.adminProcessStatus ==
                    "por_completar",
              )
                  .length;

          final enProceso =
              expedientes
                  .where(
                    (e) =>
                e.adminProcessStatus ==
                    "en_proceso",
              )
                  .length;

          final terminados =
              expedientes
                  .where(
                    (e) =>
                e.adminProcessStatus ==
                    "terminado",
              )
                  .length;

          return ListView(

            padding:
            const EdgeInsets.all(20),

            children: [

              const SizedBox(
                height: 10,
              ),

              const Text(

                "Organización de expedientes",

                style:
                TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(

                "Selecciona una sección para "
                    "ver y administrar sus expedientes.",

                style:
                TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //==================================================
              // POR COMPLETAR
              //==================================================

              _buildOptionCard(

                context: context,

                title:
                "Por completar",

                subtitle:
                "Expedientes que todavía requieren trabajo.",

                status:
                "por_completar",

                color:
                Colors.orange,

                icon:
                Icons.pending_actions,

                count:
                porCompletar,
              ),

              //==================================================
              // EN PROCESO
              //==================================================

              _buildOptionCard(

                context: context,

                title:
                "En proceso",

                subtitle:
                "Expedientes preparados y en proceso de visa.",

                status:
                "en_proceso",

                color:
                Colors.green,

                icon:
                Icons.work_history,

                count:
                enProceso,
              ),

              //==================================================
              // TERMINADOS
              //==================================================

              _buildOptionCard(

                context: context,

                title:
                "Terminados",

                subtitle:
                "Procesos de visa finalizados.",

                status:
                "terminado",

                color:
                Colors.blue,

                icon:
                Icons.check_circle,

                count:
                terminados,
              ),
            ],
          );
        },
      ),
    );
  }
}