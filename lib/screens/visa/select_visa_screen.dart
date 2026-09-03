import 'package:flutter/material.dart';

import '../../services/progress_service.dart';
import '../../services/expediente_service.dart';
import '../../utils/app_colors.dart';
import '../expedientes/new_expediente_screen.dart';


class SelectVisaScreen extends StatefulWidget {

  final String expedienteId;

  const SelectVisaScreen({
    super.key,
    required this.expedienteId,
  });

  @override
  State<SelectVisaScreen> createState() =>
      _SelectVisaScreenState();
}

class _SelectVisaScreenState
    extends State<SelectVisaScreen> {

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
      step: 3,
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,


      appBar: AppBar(
        title: const Text(
          "Tipo de Visa",
        ),
        centerTitle: true,
      ),


      body: ListView(

        padding: const EdgeInsets.all(20),


        children: [


          const Text(
            "PASO 3 DE 18",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),


          const SizedBox(height: 8),



          const Text(
            "Selecciona el tipo de visa",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),



          const SizedBox(height: 10),



          const Text(
            "Selecciona la categoría correspondiente a tu solicitud.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),



          const SizedBox(height: 30),



          visaCategory(
            title: "Visas de Visitante y Turismo",
            icon: Icons.flight,
            children: [

              VisaOption(
                code: "B1/B2",
                title: "Turismo / Negocios",
                subtitle:
                "Turismo, vacaciones, negocios y conferencias.",
                available: true,
              ),

            ],
          ),




          visaCategory(
            title: "Visas de Estudiantes e Intercambio",
            icon: Icons.school,
            children: [

              VisaOption(
                code: "F1",
                title: "Estudiante académico",
                subtitle:
                "Estudios académicos o de idioma.",
                available: false,
              ),


              VisaOption(
                code: "M1",
                title: "Estudiante vocacional",
                subtitle:
                "Estudios técnicos o vocacionales.",
                available: false,
              ),


              VisaOption(
                code: "J1",
                title: "Intercambio",
                subtitle:
                "Programas de intercambio cultural o investigación.",
                available: false,
              ),

            ],
          ),




          visaCategory(
            title: "Visas de Trabajo Temporal",
            icon: Icons.work,
            children: [

              VisaOption(
                code: "H",
                title: "Trabajadores temporales",
                subtitle:
                "Trabajo temporal agrícola y no agrícola.",
                available: false,
              ),


              VisaOption(
                code: "L",
                title: "Transferencia empresarial",
                subtitle:
                "Transferencia dentro de una misma empresa.",
                available: false,
              ),


              VisaOption(
                code: "O",
                title: "Habilidades extraordinarias",
                subtitle:
                "Personas con logros extraordinarios.",
                available: false,
              ),


              VisaOption(
                code: "P",
                title: "Atletas y artistas",
                subtitle:
                "Deportes, artistas y espectáculos.",
                available: false,
              ),


              VisaOption(
                code: "R",
                title: "Trabajadores religiosos",
                subtitle:
                "Trabajadores religiosos.",
                available: false,
              ),

            ],
          ),





          visaCategory(
            title: "Otras Categorías Especiales",
            icon: Icons.category,
            children: [

              VisaOption(
                code: "C1/D",
                title: "Tripulación",
                subtitle:
                "Miembros de tripulación aérea o marítima.",
                available: false,
              ),


              VisaOption(
                code: "I",
                title: "Periodistas",
                subtitle:
                "Medios de comunicación.",
                available: false,
              ),


              VisaOption(
                code: "A/G",
                title: "Diplomáticos",
                subtitle:
                "Gobiernos y organizaciones internacionales.",
                available: false,
              ),


              VisaOption(
                code: "T/U",
                title: "Casos especiales",
                subtitle:
                "Víctimas de trata o ciertos delitos.",
                available: false,
              ),

            ],
          ),


        ],

      ),

    );

  }







  Widget visaCategory({

    required String title,
    required IconData icon,
    required List<VisaOption> children,

  }) {


    return Card(

      margin: const EdgeInsets.only(bottom: 22),


      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),


      child: Padding(

        padding:
        const EdgeInsets.all(15),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Row(

              children: [

                CircleAvatar(

                  backgroundColor:
                  AppColors.primary.withOpacity(.1),


                  child: Icon(
                    icon,
                    color: AppColors.primary,
                  ),

                ),


                const SizedBox(width: 12),


                Expanded(

                  child: Text(

                    title,

                    style: const TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                ),

              ],

            ),



            const SizedBox(height: 15),



            ...children.map(
                  (visa) => visaCard(visa),
            ),

          ],

        ),

      ),

    );

  }







  Widget visaCard(
      VisaOption visa,
      ) {


    return Card(

      elevation: 1,


      margin:
      const EdgeInsets.only(bottom: 12),


      child: ListTile(

        leading: CircleAvatar(

          backgroundColor:
          visa.available
              ? Colors.green.shade50
              : Colors.grey.shade200,


          child: Icon(

            visa.available
                ? Icons.flight
                : Icons.lock,


            color:

            visa.available
                ? Colors.green
                : Colors.grey,

          ),

        ),



        title: Text(

          "${visa.title} (${visa.code})",

          style: const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        subtitle: Text(
          visa.subtitle,
        ),



        trailing: Icon(

          visa.available
              ? Icons.arrow_forward_ios
              : Icons.lock_outline,

          color:

          visa.available
              ? AppColors.primary
              : Colors.grey,

        ),



        onTap: () async {

          if (!visa.available) {

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(

                content: Text(
                  "Esta categoría estará disponible próximamente. Actualmente Visa Assist solo permite visa de Turismo/Negocios B1/B2.",
                ),

              ),

            );

            return;

          }

          await _expedienteService.updateVisaType(
            expedienteId: widget.expedienteId,
            visaType: visa.code,
          );

          await guardarProgreso();

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewExpedienteScreen(
                expedienteId: widget.expedienteId,
              ),
            ),
          );

        },

      ),

    );

  }


}






class VisaOption {


  final String code;

  final String title;

  final String subtitle;

  final bool available;



  VisaOption({

    required this.code,

    required this.title,

    required this.subtitle,

    required this.available,

  });


}