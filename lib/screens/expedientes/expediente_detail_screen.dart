import 'package:flutter/material.dart';
import '../../services/expediente_service.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';

import '../visa/family_information_screen.dart';
import '../visa/security_background_screen.dart';
import '../visa/additional_information_screen.dart';
import '../visa/work_education_information_screen.dart';
import '../visa/select_visa_screen.dart';
import '../visa/select_country_screen.dart';

import '../payment/service_payment_screen.dart';
import 'solicitante_screen.dart';
import 'personal_information_screen.dart';
import 'passport_information_screen.dart';
import 'address_screen.dart';
import 'travel_information_screen.dart';
import 'travel_history_screen.dart';
import 'summary_screen.dart';
import '../visa/travel_companion_screen.dart';
import '../visa/us_contact_screen.dart';
import '../passport/passport_verification_screen.dart';
import 'expediente_tracking_screen.dart';
import 'visa_assist_process_screen.dart';


class ExpedienteDetailScreen extends StatefulWidget {
  final Expediente expediente;

  // Por ahora la asignación de agentes permanece oculta.
  // Cuando Visa Assist crezca, cambiar a true.
  static const bool showAgentAssignment = false;

  const ExpedienteDetailScreen({

    super.key,

    required this.expediente,

  });

  @override
  State<ExpedienteDetailScreen> createState() =>
      _ExpedienteDetailScreenState();
}

class _ExpedienteDetailScreenState
    extends State<ExpedienteDetailScreen> {

  late Expediente _expedienteActual;

  final ExpedienteService _expedienteService =
  ExpedienteService();

  @override
  void initState() {
    super.initState();

    _expedienteActual = widget.expediente;

    _escucharCambios();
  }

  void _escucharCambios() {
    _expedienteService
        .watchExpediente(widget.expediente.id)
        .listen((expedienteActualizado) {

      if (!mounted ||
          expedienteActualizado == null) {
        return;
      }

      setState(() {
        _expedienteActual =
            expedienteActualizado;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final expediente = _expedienteActual;

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        title: const Text(
          "Mi Expediente",
        ),

        centerTitle: true,

      ),

      body: ListView(

        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          90,
        ),

          children: [

      //------------------------------------
      // CABECERA
      //------------------------------------

      Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        gradient: AppColors.primaryGradient,

        borderRadius:
        BorderRadius.circular(20),

      ),


      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,


        children: [


          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                const Text(

                  "EXPEDIENTE",

                  style: TextStyle(

                    color: Colors.white70,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 10),


                Text(

                  expediente.applicant != null

                      ? "${expediente.applicant!.firstName} ${expediente.applicant!.lastName}"

                      : "Solicitud en proceso",


                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 10),


                Text(

                  "No. ${expediente.id.substring(0,8).toUpperCase()}",


                  style: const TextStyle(

                    color: Colors.white70,

                    fontSize: 15,

                  ),

                ),


              ],

            ),

          ),



          Column(

            children: [


              const Text(

                "VISA",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 32,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),


              const Text(

                "ASSIST",

                style: TextStyle(

                  color: Color(0xFFD90429),

                  fontSize: 28,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),


            ],

          ),


        ],

      ),

    ),

    const SizedBox(height: 25),

    //------------------------------------
    // ESTADO DEL EXPEDIENTE
    //------------------------------------


    const Text(

    "Estado del expediente",

    style: TextStyle(

    fontSize: 20,

    fontWeight:
    FontWeight.bold,

    ),
    ),

    const SizedBox(height: 15),

            Card(

              elevation: 4,

              shape: RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(18),

                side: const BorderSide(

                  color: Color(0xFFD90429),

                  width: 1.5,

                ),
              ),

    child: Padding(

    padding:
    const EdgeInsets.symmetric(

    horizontal: 20,

    vertical: 18,

    ),


    child: Column(

    crossAxisAlignment:
    CrossAxisAlignment.start,


    children: [


    Row(

    children: [


    const CircleAvatar(

    radius: 24,

    backgroundColor:
    AppColors.primary,


    child: Icon(

    Icons.timelapse,

    color: Colors.white,

    ),

    ),


    const SizedBox(width:15),


    Expanded(

    child: Column(

    crossAxisAlignment:
    CrossAxisAlignment.start,


    children: [


    const Text(

    "Etapa actual",

    style: TextStyle(

    color: Colors.grey,

    ),

    ),


    const SizedBox(height:5),


    Text(

    _getCurrentStage(),


    style: const TextStyle(

    fontSize: 20,

    fontWeight:
    FontWeight.bold,

    ),

    ),


    ],

    ),

    ),

    ],

    ),


    const SizedBox(height:20),


    const Divider(),


    const SizedBox(height:15),


    Row(

    children: [


    Icon(

    Icons.payments,

    color:
    _getPaymentColor(),

    ),


    const SizedBox(width:10),


    Expanded(

    child: Text(

    "Pago del servicio: ${_getPaymentText()}",

    ),

    ),

    ],

    ),


    const SizedBox(height:12),


    Row(

    children: [


    const Icon(

    Icons.description,

    color: Colors.blue,

    ),


    const SizedBox(width:10),


    Expanded(

    child: Text(

      "DS-160: ${
          (expediente.visaProcessInformation?.ds160PdfUrl
              ?.isNotEmpty ??
              false)
              ? "Disponible"
              : expediente.ds160Status
      }",

    ),

    ),

    ],

    ),


    const SizedBox(height:12),


    Row(

    children: [


    const Icon(

    Icons.assignment,

    color:
    AppColors.accentRed,

    ),


    const SizedBox(width:10),


    Expanded(

    child: Text(

      "Perfil CAS: ${
          (expediente.casUsername.isNotEmpty &&
              expediente.casPassword.isNotEmpty)
              ? "Configurado"
              : expediente.casStatus
      }",

    ),

    ),

    ],

    ),


    const SizedBox(height:12),

      if (ExpedienteDetailScreen.showAgentAssignment)

    Row(

    children: [


    const Icon(

    Icons.person,

    color: Colors.teal,

    ),


    const SizedBox(width:10),


    Expanded(

    child: Text(

    expediente.assignedAgentName.isEmpty

    ? "Agente aún no asignado"

        : "Agente: ${expediente.assignedAgentName}",

    ),

    ),

    ],

    ),


    ],

    ),

    ),

    ),


    const SizedBox(height:25),

            //------------------------------------
            // TU PRÓXIMO PASO
            //------------------------------------


            const Text(

              "Tu próximo paso",

              style: TextStyle(

                fontSize: 22,

                fontWeight: FontWeight.bold,

              ),

            ),


            const SizedBox(height:15),



            _buildNextStepCard(),



            const SizedBox(height:20),



            //------------------------------------
            // SEGUIMIENTO DEL EXPEDIENTE
            //------------------------------------


            _buildNavigationCard(
              context,
              (expediente.currentStep >= 18 ||
                  (expediente.currentStep >= 17 &&
                      expediente.serviceStatus == "contratado"))
                  ? Icons.check_circle
                  : Icons.edit_document,
              (expediente.currentStep >= 18 ||
                  (expediente.currentStep >= 17 &&
                      expediente.serviceStatus == "contratado"))
                  ? "Expediente completado ✓"
                  : "Expediente en proceso",
              (expediente.currentStep >= 18 ||
                  (expediente.currentStep >= 17 &&
                      expediente.serviceStatus == "contratado"))
                  ? "La recopilación de información ha finalizado. "
                  "Puedes consultar el seguimiento cuando lo necesites."
                  : "Continúa completando la información de tu expediente "
                  "desde el punto donde lo dejaste.",
                  () {
                if (expediente.currentStep >= 18 ||
                    (expediente.currentStep >= 17 &&
                        expediente.serviceStatus == "contratado")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExpedienteTrackingScreen(
                        expediente: expediente,
                      ),
                    ),
                  );
                } else {
                  _continueExpediente(context);
                }
              },
              completed: expediente.currentStep >= 18 ||
                  (expediente.currentStep >= 17 &&
                      expediente.serviceStatus == "contratado"),
            ),

            const SizedBox(height:15),

            //------------------------------------
            // PROCESO VISA ASSIST
            //------------------------------------

            _buildNavigationCard(
              context,
              Icons.flight_takeoff,
              "Proceso Visa Assist",
              "Tu proceso continúa aquí. Consulta el estado de tu "
                  "DS-160, pago MRV, cita CAS y entrevista consular.",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisaAssistProcessScreen(
                      expediente: expediente,
                    ),
                  ),
                );
              },
              highlighted: true,
            ),

            const SizedBox(height:15),

            //------------------------------------
            // BOTÓN SOLO SI NO ESTÁ CONTRATADO
            //------------------------------------

            if (expediente.serviceStatus != "contratado") ...[

              SizedBox(

                height:58,

                width:double.infinity,

                child: ElevatedButton.icon(

                  icon: Icon(

                    expediente.paymentStatus == "Aprobado"

                        ? Icons.assignment

                        : Icons.play_arrow,

                  ),



                  label: Text(


                    expediente.paymentStatus == "En revisión"


                        ? "IR AL PORTAL"


                        : expediente.currentStep >= 17


                        ? "CONTRATAR SERVICIO VISA ASSIST"


                        : "CONTINUAR EXPEDIENTE",



                    style: const TextStyle(


                      fontSize:18,


                      fontWeight:FontWeight.bold,


                    ),


                  ),



                  onPressed: () async {


                    await _continueExpediente(context);


                  },


                ),

              ),


            ],



            const SizedBox(height:15),



          ],

      ),

    );

  }

  //------------------------------------------------
  // PRÓXIMO PASO
  //------------------------------------------------

  Widget _buildNextStepCard() {

    final expediente = _expedienteActual;

    final ds160Disponible =
        expediente.visaProcessInformation
            ?.ds160PdfUrl
            ?.isNotEmpty ??
            false;

    final perfilCasConfigurado =
        expediente.casUsername.isNotEmpty &&
            expediente.casPassword.isNotEmpty;

    final citaCasCompleta =
        expediente.casAppointmentDate.isNotEmpty &&
            expediente.casAppointmentTime.isNotEmpty &&
            expediente.casLocation.isNotEmpty;

    final entrevistaRealizada =
        expediente.interviewStatus == "Realizada";

    String title;
    String description;
    IconData icon;
    Color color;

    //==================================================
    // PAGO DEL SERVICIO
    //==================================================

    if (expediente.paymentStatus == "En revisión") {

      title = "Pago en revisión";

      description =
      "Recibimos tu comprobante. Nuestro equipo verificará "
          "el pago y te notificaremos cuando el servicio sea aprobado.";

      icon = Icons.hourglass_top;
      color = Colors.orange;

    }

    else if (expediente.paymentStatus == "Pendiente") {

      title = "Subir comprobante de pago";

      description =
      "Debes enviar el comprobante para que podamos validar tu pago.";

      icon = Icons.upload_file;
      color = Colors.orange;

    }

    //==================================================
    // SERVICIO CONTRATADO PERO DS-160 NO DISPONIBLE
    //==================================================

    else if (expediente.serviceStatus == "contratado" &&
        !ds160Disponible) {

      title = "Preparación DS-160";

      description =
      "Nuestro equipo está preparando tu formulario DS-160. "
          "Te notificaremos cuando esté disponible.";

      icon = Icons.description;
      color = AppColors.primary;

    }

    //==================================================
    // DS-160
    //==================================================

    else if (!ds160Disponible) {

      title = "Preparación DS-160";

      description =
      "Nuestro equipo comenzará la preparación de tu formulario DS-160.";

      icon = Icons.description;
      color = AppColors.primary;

    }

    //==================================================
    // PAGO MRV
    //==================================================

    else if (expediente.mrvStatus != "Pagado") {

      title = "Pago MRV";

      description =
      "El pago de la tasa consular debe realizarse antes de continuar.";

      icon = Icons.account_balance;
      color = Colors.deepPurple;

    }

    //==================================================
    // PERFIL CAS
    //==================================================

    else if (!perfilCasConfigurado) {

      title = "Perfil CAS";

      description =
      "Nuestro equipo está preparando tu perfil CAS.";

      icon = Icons.assignment;
      color = Colors.green;

    }

    //==================================================
    // CITA CAS
    //==================================================

    else if (!citaCasCompleta) {

      title = "Cita CAS";

      description =
      "La cita CAS todavía está pendiente de completar.";

      icon = Icons.fingerprint;
      color = Colors.green;

    }

    //==================================================
    // ENTREVISTA CONSULAR
    //==================================================

    else if (!entrevistaRealizada) {

      title = "Entrevista consular";

      description =
      "Debes asistir a tu entrevista en la embajada.";

      icon = Icons.groups;
      color = AppColors.accentRed;

    }

    //==================================================
    // TODO EL PROCESO FINALIZADO
    //==================================================

    else {

      title = "Resultado final";

      description =
      "Tu entrevista consular ya fue realizada. "
          "El proceso de visa ha llegado a su etapa final.";

      icon = Icons.flag;
      color = Colors.teal;
    }

    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(18),

        side: const BorderSide(

          color: Color(0xFFD90429),

          width: 1.5,

        ),

      ),

      child: Padding(

        padding:
        const EdgeInsets.all(15),

        child: Row(

          children: [

            CircleAvatar(

              radius: 28,

              backgroundColor: color,

              child: Icon(

                icon,

                color: Colors.white,

              ),

            ),

            const SizedBox(
              width: 15,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: const TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(

                    description,

                    style: const TextStyle(

                      height: 1.4,

                    ),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );
  }

  //------------------------------------------------
// ESTADO ACTUAL
//------------------------------------------------

  String _getCurrentStage() {

    final expediente = _expedienteActual;

    if (expediente.paymentStatus == "En revisión") {

      return "Pago del servicio en revisión";

    }

    if (expediente.serviceStatus == "contratado") {

      final ds160Disponible =
          expediente.visaProcessInformation
              ?.ds160PdfUrl
              ?.isNotEmpty ??
              false;

      final perfilCasConfigurado =
          expediente.casUsername.isNotEmpty &&
              expediente.casPassword.isNotEmpty;

      if (!ds160Disponible) {

        return "Preparación DS-160";

      }

      if (!perfilCasConfigurado) {

        return "Perfil CAS";

      }

      final citaCasCompleta =
          expediente.casAppointmentDate.isNotEmpty &&
              expediente.casAppointmentTime.isNotEmpty &&
              expediente.casLocation.isNotEmpty;

      if (!citaCasCompleta) {

        return "Cita CAS";

      }

      if (expediente.mrvStatus != "Pagado") {

        return "Pago MRV";

      }

      if (expediente.interviewStatus != "Realizada") {

        return "Entrevista consular";

      }

      return "Resultado final";
    }

    switch (expediente.currentStep) {
      case 1:
        return "Verificación de pasaporte";

      case 2:
        return "Selección de país";

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
        return "Acompañante de viaje";

      case 11:
        return "Contacto en EE.UU.";

      case 12:
        return "Historial de viajes";

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

      default:

        return "Expediente completado";
    }
  }

  Color _getPaymentColor() {

    final expediente = _expedienteActual;

    switch (expediente.paymentStatus) {

      case "Aprobado":

        return Colors.green;

      case "En revisión":

        return Colors.orange;

      case "Pendiente":

        return AppColors.accentRed;

      default:

        return Colors.grey;
    }
  }

  String _getPaymentText() {

    final expediente = _expedienteActual;

    switch (expediente.paymentStatus) {

      case "Aprobado":

        return "Aprobado";

      case "En revisión":

        return "En revisión";

      case "Pendiente":

        return "Pendiente";

      default:

        return expediente.paymentStatus;

    }
  }

  //------------------------------------------------
// CARD DE NAVEGACIÓN
//------------------------------------------------

  Widget _buildNavigationCard(
      BuildContext context,
      IconData icon,
      String title,
      String description,
      VoidCallback onTap, {
        bool completed = false,
        bool highlighted = false,
      }) {

    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(18),

        side: BorderSide(
          color: completed
              ? Colors.green
              : highlighted
              ? AppColors.primary
              : const Color(0xFFD90429),
          width: highlighted ? 2 : 1.5,
        ),

      ),

      child: InkWell(

        borderRadius: BorderRadius.circular(18),

        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: completed
                    ? Colors.green.shade100
                    : highlighted
                    ? AppColors.primary
                    : const Color(0xFFE8EDF8),
                child: Icon(
                  completed ? Icons.check : icon,
                  color: completed
                      ? Colors.green
                      : highlighted
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: highlighted
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

//------------------------------------------------
// CONTINUAR EXPEDIENTE
//------------------------------------------------

  Future<void> _continueExpediente(
      BuildContext context,
      ) async {

    final expediente = _expedienteActual;

    // ==================================================
    // EXPEDIENTE COMPLETO - FALTA CONTRATAR SERVICIO
    // ==================================================

    if (expediente.currentStep >= 17 &&
        expediente.serviceStatus != "contratado" &&
        expediente.paymentStatus == "Pendiente") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServicePaymentScreen(
            expedienteId: expediente.id,
          ),
        ),
      );

      return;
    }

    // ==================================================
    // COMPROBANTE EN REVISIÓN
    // ==================================================

    if (expediente.paymentStatus == "En revisión") {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tu comprobante está siendo revisado por nuestro equipo.",
          ),
        ),
      );

      return;
    }

    // ==================================================
    // PAGO APROBADO
    // ==================================================

    if (expediente.paymentStatus == "Aprobado") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VisaAssistProcessScreen(
            expediente: expediente,
          ),
        ),
      );

      return;
    }

    // ==================================================
    // CONTINUAR EXPEDIENTE DESDE EL PASO ACTUAL
    // ==================================================

    switch (expediente.currentStep) {

      case 1:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const PassportVerificationScreen(),
          ),
        );

        return;

      case 2:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectCountryScreen(
              expedienteId: expediente.id,
            ),
          ),
        );

        return;

      case 3:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectVisaScreen(
              expedienteId: expediente.id,
            ),
          ),
        );

        return;

      case 5:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SolicitanteScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 6:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PersonalInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 7:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PassportInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 8:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddressScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 9:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 10:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelCompanionScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 11:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UsContactScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 12:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelHistoryScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 13:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FamilyInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 14:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkEducationInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 15:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SecurityBackgroundScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 16:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdditionalInformationScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      case 17:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SummaryScreen(
              expediente: expediente,
            ),
          ),
        );

        return;

      default:

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No se pudo determinar dónde continuar el expediente.",
            ),
          ),
        );

        return;
    }
  }
}