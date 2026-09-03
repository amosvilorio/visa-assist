import 'package:flutter/material.dart';
import '../visa/travel_companion_screen.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';

import '../visa/additional_information_screen.dart';
import 'solicitante_screen.dart';
import 'personal_information_screen.dart';
import 'passport_information_screen.dart';
import 'address_screen.dart';
import 'travel_information_screen.dart';
import 'travel_history_screen.dart';
import 'employment_screen.dart';
import '../visa/us_contact_screen.dart';
import '../visa/family_information_screen.dart';
import '../visa/security_background_screen.dart';


class ExpedienteTrackingScreen extends StatefulWidget {

  final Expediente expediente;

  const ExpedienteTrackingScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<ExpedienteTrackingScreen> createState() =>
      _ExpedienteTrackingScreenState();
}

class _ExpedienteTrackingScreenState
    extends State<ExpedienteTrackingScreen> {

  late Expediente expedienteActual;

  @override
  void initState() {
    super.initState();

    expedienteActual = widget.expediente;
  }

  @override
  Widget build(BuildContext context) {

    final expediente = expedienteActual;

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: const Text(
          "Seguimiento del expediente",
        ),

        centerTitle: true,

      ),


      body: ListView(

        padding: const EdgeInsets.all(20),


        children: [


        const Text(

        "Proceso de solicitud",

        style: TextStyle(

          fontSize: 24,

          fontWeight: FontWeight.bold,

        ),

      ),


      const SizedBox(height: 20),



      _buildStep(

        context,

        "Verificación del pasaporte",

        expediente.currentStep >= 1,

        null,

      ),



      _buildStep(

        context,

        "Selección de país",

        expediente.currentStep >= 2,

        null,

      ),



      _buildStep(
        context,
        "Tipo de visa",
        expediente.currentStep >= 3,
        null,
      ),

      _buildStep(
        context,
        "Creación del expediente",
        expediente.currentStep >= 4,
        null,
      ),

      _buildStep(
        context,
        "Datos del solicitante",
        expediente.applicant != null,
            () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SolicitanteScreen(
                expediente: expediente,
                viewOnly: true,
              ),
            ),
          );
        },
      ),

      _buildStep(
        context,
        "Información personal",
        expediente.personalInformation != null,

            () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PersonalInformationScreen(
                expediente: expediente,
              ),
            ),
          );
        },
      ),

      _buildStep(
        context,
        "Información del pasaporte",
        expediente.passportInformation != null,

            () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PassportInformationScreen(
                expediente: expediente,
              ),
            ),
          );
        },
      ),

      _buildStep(
        context,
        "Dirección y contacto",
        expediente.addressInformation != null,

            () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddressScreen(
                expediente: expediente,
              ),
            ),
          );
        },
      ),

          _buildStep(
            context,
            "Información del viaje",
            expediente.travelInformation != null,

                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TravelInformationScreen(
                    expediente: expediente,
                  ),
                ),
              );
            },
          ),

          _buildStep(
            context,
            "Acompañante de viaje",
            expediente.travelingWithOthers != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TravelCompanionScreen(
                    viewOnly: true,
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Contacto en EE.UU.",
            expediente.usContact != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UsContactScreen(
                    viewOnly: true,
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Historial de viajes",
            expediente.travelHistory != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TravelHistoryScreen(
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Información familiar",
            expediente.familyInformation != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FamilyInformationScreen(
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Trabajo y educación",
            expediente.workEducationInformation != null,

                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmploymentScreen(
                    expediente: expediente,
                  ),
                ),
              );
            },
          ),

          _buildStep(
            context,
            "Seguridad y antecedentes",
            expediente.securityBackground != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SecurityBackgroundScreen(
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Información adicional",
            expediente.additionalInformation != null,
                () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdditionalInformationScreen(
                    viewOnly: true,
                    expediente: expediente,
                  ),
                ),
              );

            },
          ),

          _buildStep(
            context,
            "Revisión del expediente",
            expediente.applicant != null &&
                expediente.personalInformation != null &&
                expediente.passportInformation != null &&
                expediente.addressInformation != null &&
                expediente.travelInformation != null &&
                expediente.travelHistory != null &&
                expediente.usContact != null &&
                expediente.familyInformation != null &&
                expediente.workEducationInformation != null &&
                expediente.securityBackground != null &&
                expediente.additionalInformation != null,
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context,
      String title,
      bool completed,
      VoidCallback? onTap,
      ) {

    return ListTile(
      contentPadding: EdgeInsets.zero,

      onTap: onTap,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor:
        completed
            ? Colors.green
            : Colors.grey.shade300,

        child: Icon(

          completed

              ? Icons.check

              : Icons.circle_outlined,


          size: 20,


          color:

          completed

              ? Colors.white

              : Colors.grey,

        ),

      ),


      title: Text(

        title,


        style: TextStyle(

          fontWeight:

          completed

              ? FontWeight.w600

              : FontWeight.normal,

        ),

      ),


      trailing:

      onTap != null

          ? const Icon(

        Icons.arrow_forward_ios,

        size: 16,

      )

          : null,


    );

  }

}