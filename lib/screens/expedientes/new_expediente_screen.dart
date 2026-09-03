import 'package:flutter/material.dart';
import '../../services/progress_service.dart';
import '../../services/expediente_service.dart';
import '../../utils/app_colors.dart';
import 'solicitante_screen.dart';

class NewExpedienteScreen extends StatefulWidget {

  final String expedienteId;

  const NewExpedienteScreen({
    super.key,
    required this.expedienteId,
  });

  @override
  State<NewExpedienteScreen> createState() =>
      _NewExpedienteScreenState();
}

class _NewExpedienteScreenState
    extends State<NewExpedienteScreen> {

  final ProgressService _progressService =
      ProgressService.instance;

  final ExpedienteService _expedienteService =
  ExpedienteService();


  @override
  void initState() {
    super.initState();
    guardarProgreso();
  }


  Future<void> guardarProgreso() async {

    await _progressService.saveStep(
      expedienteId: widget.expedienteId,
      step: 4,
    );

  }


  Widget infoItem(String text) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),

        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        title: const Text(
          "Preparación del Expediente",
        ),

        centerTitle: true,

      ),


      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [


              const Text(
                "PASO 4 DE 18",

                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),

              ),


              const SizedBox(height: 8),


              const Text(

                "Prepararemos tu expediente de visa",

                style: TextStyle(

                  fontSize: 28,

                  fontWeight: FontWeight.bold,

                ),

              ),


              const SizedBox(height: 10),


              const Text(

                "Vamos a recopilar la información necesaria para preparar tu expediente y guiarte durante todo el proceso.",

                style: TextStyle(

                  color:
                  AppColors.textSecondary,

                  fontSize: 16,

                  height: 1.5,

                ),

              ),


              const SizedBox(height: 25),


              Expanded(

                child: SingleChildScrollView(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      const Text(

                        "Información que recopilaremos",

                        style: TextStyle(

                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                      const SizedBox(height: 15),


                      infoItem(
                        "Información personal del solicitante",
                      ),

                      infoItem(
                        "Información del pasaporte",
                      ),

                      infoItem(
                        "Dirección y datos de contacto",
                      ),

                      infoItem(
                        "Información del viaje",
                      ),

                      infoItem(
                        "Historial de viajes",
                      ),

                      infoItem(
                        "Compañeros de viaje",
                      ),

                      infoItem(
                        "Contacto en Estados Unidos",
                      ),

                      infoItem(
                        "Información familiar",
                      ),

                      infoItem(
                        "Trabajo y educación",
                      ),

                      infoItem(
                        "Seguridad y antecedentes",
                      ),

                      infoItem(
                        "Información adicional necesaria para el proceso",
                      ),


                      const SizedBox(height: 20),


                      Container(

                        padding:
                        const EdgeInsets.all(16),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.blue.shade50,

                          borderRadius:
                          BorderRadius.circular(16),

                        ),


                        child: const Text(

                          "Después de haber finalizado tu expediente, nuestro equipo puede solicitar información o documentos adicionales si son necesarios para completar correctamente tu proceso de solicitud de visa.",

                          style: TextStyle(

                            height: 1.5,

                          ),

                        ),

                      ),


                    ],

                  ),

                ),

              ),


              const SizedBox(height: 20),


              SizedBox(

                width:
                double.infinity,

                height:
                55,

                child:
                ElevatedButton(

                  onPressed: () async {

                    final expediente =
                    await _expedienteService.getExpedienteById(
                      widget.expedienteId,
                    );

                    if (expediente == null) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "No se pudo encontrar el expediente.",
                          ),
                        ),
                      );

                      return;
                    }

                    if (!mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SolicitanteScreen(
                          expediente: expediente,
                        ),
                      ),
                    );

                  },

                  child: const Text(

                    "INICIAR EXPEDIENTE",

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

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

}