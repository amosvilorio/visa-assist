import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../models/travel_information.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../utils/app_colors.dart';
import 'travel_history_screen.dart';

class TravelInformationScreen extends StatefulWidget {

  final Expediente expediente;

  const TravelInformationScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<TravelInformationScreen> createState() =>
      _TravelInformationScreenState();
}

class _TravelInformationScreenState
    extends State<TravelInformationScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  //------------------------------------------
  // CONTROLADORES
  //------------------------------------------

  final propositoViajeController =
  TextEditingController();

  final tiempoEstadiaController =
  TextEditingController();

  final direccionHospedajeController =
  TextEditingController();

  final relacionPagadorController =
  TextEditingController();

  DateTime? fechaViaje;

  bool conoceHospedaje = false;

  String quienPaga = "Yo mismo";

  //------------------------------------------
  @override
  void initState() {
    super.initState();

    cargarInformacionViaje();
  }

  Future<void> cargarInformacionViaje() async {
    final expediente = widget.expediente;

    final travelInformation =
        expediente.travelInformation;

    if (travelInformation == null) return;

    setState(() {
      propositoViajeController.text =
          travelInformation.purposeOfTrip;

      fechaViaje =
          travelInformation.estimatedArrivalDate;

      tiempoEstadiaController.text =
          travelInformation.lengthOfStay;

      conoceHospedaje =
          travelInformation.knowsWhereWillStay;

      direccionHospedajeController.text =
          travelInformation.stayAddress;

      quienPaga =
          travelInformation.personPayingTrip;

      relacionPagadorController.text =
          travelInformation.payerRelationship;
    });
  }

  @override
  void dispose() {

    propositoViajeController.dispose();

    tiempoEstadiaController.dispose();

    direccionHospedajeController.dispose();

    relacionPagadorController.dispose();

    super.dispose();

  }

  Future<void> seleccionarFecha() async {

    final fecha = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2035),

    );

    if (fecha != null) {

      setState(() {

        fechaViaje = fecha;

      });

    }

  }

  InputDecoration decoration(

      String label,

      IconData icon,

      ) {

    return InputDecoration(

      labelText: label,

      prefixIcon: Icon(icon),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: AppColors.background,

        appBar: AppBar(

          title: const Text(

            "Información del Viaje",

          ),

        ),

        body: Form(

            key: _formKey,

            child: ListView(

              padding: const EdgeInsets.all(20),

              children: [

              const Text(

                "PASO 9 DE 18",

              style: TextStyle(

                color: AppColors.primary,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 8),

            const Text(

              "Información del Viaje",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 10),

            const Text(

              "Indica la información principal de tu viaje a los Estados Unidos.",

              style: TextStyle(

                color: AppColors.textSecondary,

                height: 1.5,

              ),

            ),

            const SizedBox(height: 30),

            TextFormField(

              controller: propositoViajeController,

              decoration: decoration(

                "Motivo principal del viaje",

                Icons.flight_takeoff,

              ),

              validator: (value) {

                if (value == null || value.isEmpty) {

                  return "Ingrese el motivo del viaje.";

                }

                return null;

              },

            ),

            const SizedBox(height: 20),

            ListTile(

              shape: RoundedRectangleBorder(

                borderRadius:

                BorderRadius.circular(15),

                side: BorderSide(

                  color: Colors.grey.shade300,

                ),

              ),

              leading:

              const Icon(Icons.calendar_month),

              title: Text(

                fechaViaje == null

                    ? "Fecha estimada del viaje (Opcional)"

                    : "${fechaViaje!.day}/${fechaViaje!.month}/${fechaViaje!.year}",

              ),

              trailing:

              const Icon(Icons.arrow_drop_down),

              onTap: seleccionarFecha,

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller: tiempoEstadiaController,

              decoration: decoration(

                "Tiempo aproximado de permanencia",

                Icons.schedule,

              ),

              validator: (value) {

                if (value == null || value.isEmpty) {

                  return "Ingrese la duración aproximada.";

                }

                return null;

              },

            ),

            const SizedBox(height: 25),

            SwitchListTile(

              value: conoceHospedaje,

              activeColor: AppColors.primary,

              title: const Text(

                "¿Ya conoce dónde se hospedará?",

              ),

              onChanged: (value) {

                setState(() {

                  conoceHospedaje = value;

                });

              },

            ),

            if (conoceHospedaje) ...[

        const SizedBox(height: 20),

    TextFormField(

    controller:
    direccionHospedajeController,

    maxLines: 3,

    decoration: decoration(

    "Dirección del hospedaje",

    Icons.hotel,

    ),

    ),

    ],

    const SizedBox(height: 25),

    DropdownButtonFormField<String>(

    value: quienPaga,

    decoration: const InputDecoration(

    labelText: "¿Quién pagará el viaje?",

    ),

    items: const [

    DropdownMenuItem(

    value: "Yo mismo",

    child: Text("Yo mismo"),

    ),

    DropdownMenuItem(

    value: "Familiar",

    child: Text("Familiar"),

    ),

    DropdownMenuItem(

    value: "Empresa",

    child: Text("Empresa"),

    ),

    DropdownMenuItem(

    value: "Otra Persona",

    child: Text("Otra Persona"),

    ),

    ],

    onChanged: (value) {

    if (value == null) return;

    setState(() {

    quienPaga = value;

    });

    },

    ),

    if (quienPaga != "Yo mismo") ...[

    const SizedBox(height: 20),

    TextFormField(

    controller:

    relacionPagadorController,

    decoration: decoration(

    "Relación con quien paga",

    Icons.people,

    ),

    ),

    ],

    const SizedBox(height: 35),

                SizedBox(

                  height: 55,

                  child: ElevatedButton(

                    onPressed: () async {

                      if (!_formKey.currentState!.validate()) {

                        return;

                      }

                      final travelInformation =

                      TravelInformation(

                        purposeOfTrip:
                        propositoViajeController.text.trim(),

                        estimatedArrivalDate:
                        fechaViaje,

                        lengthOfStay:
                        tiempoEstadiaController.text.trim(),

                        knowsWhereWillStay:
                        conoceHospedaje,

                        stayAddress:
                        direccionHospedajeController.text.trim(),

                        personPayingTrip:
                        quienPaga,

                        payerRelationship:
                        relacionPagadorController.text.trim(),

                      );

                      await _expedienteService.saveTravelInformation(

                        expedienteId: widget.expediente.id,

                        travelInformation: travelInformation,

                      );

                      await _progressService.saveStep(

                        expedienteId: widget.expediente.id,

                        step: 10,

                      );

                      if (!mounted) return;

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => TravelHistoryScreen(
                            expediente: widget.expediente,
                          ),
                        ),

                      );
                    },

                    child: const Text(

                      "CONTINUAR",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ),

                ),

                const SizedBox(height: 25),

                Container(

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    color: Colors.blue.shade50,

                    borderRadius: BorderRadius.circular(15),

                  ),

                  child: const Row(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Icon(

                        Icons.info_outline,

                        color: Colors.blue,

                      ),

                      SizedBox(width: 12),

                      Expanded(

                        child: Text(

                          "Si durante la revisión del expediente nuestro agente necesita información adicional para completar correctamente el formulario DS-160, se comunicará contigo antes de enviarlo a la Embajada.",

                          style: TextStyle(

                            height: 1.5,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

                const SizedBox(height: 30),

              ],

            ),

        ),

    );

  }

}