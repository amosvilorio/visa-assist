import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../models/passport_information.dart';
import 'address_screen.dart';

class PassportInformationScreen extends StatefulWidget {

  final Expediente expediente;

  const PassportInformationScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<PassportInformationScreen> createState() =>
      _PassportInformationScreenState();
}

class _PassportInformationScreenState
    extends State<PassportInformationScreen> {

  @override
  void initState() {
    super.initState();

    cargarPasaporte();
  }

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  //-------------------------------------
  // CONTROLADORES
  //-------------------------------------

  final numeroPasaporteController =
  TextEditingController();

  final paisEmisorController =
  TextEditingController();

  final ciudadEmisionController =
  TextEditingController();

  final estadoEmisionController =
  TextEditingController();

  final numeroPasaportePerdidoController =
  TextEditingController();

  final paisPasaportePerdidoController =
  TextEditingController();

  final explicacionController =
  TextEditingController();

  //-------------------------------------
  // VARIABLES
  //-------------------------------------

  DateTime? fechaEmision;

  DateTime? fechaVencimiento;

  bool perdioPasaporte = false;

  //-------------------------------------
  // FECHAS
  //-------------------------------------

  Future<void> seleccionarFechaEmision() async {

    final fecha = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(1980),

      lastDate: DateTime.now(),

    );

    if (fecha != null) {

      setState(() {

        fechaEmision = fecha;

      });

    }

  }

  Future<void> seleccionarFechaVencimiento() async {

    final fecha = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),

    );

    if (fecha != null) {

      setState(() {

        fechaVencimiento = fecha;

      });

    }

  }

  //-------------------------------------
  // LIBERAR MEMORIA
  //-------------------------------------

  Future<void> cargarPasaporte() async {

    final expediente = widget.expediente;

    if (expediente.passportInformation == null) return;

    final passport =
    expediente.passportInformation!;


    setState(() {

      numeroPasaporteController.text =
          passport.passportNumber;

      paisEmisorController.text =
          passport.issuingCountry;

      ciudadEmisionController.text =
          passport.issuingCity;

      estadoEmisionController.text =
          passport.issuingState;

      fechaEmision =
          passport.issueDate;

      fechaVencimiento =
          passport.expirationDate;

      perdioPasaporte =
          passport.hasLostPassport;

      numeroPasaportePerdidoController.text =
          passport.lostPassportNumber;

      paisPasaportePerdidoController.text =
          passport.lostPassportCountry;

      explicacionController.text =
          passport.explanation;

    });

  }

  @override
  void dispose() {

    numeroPasaporteController.dispose();

    paisEmisorController.dispose();

    ciudadEmisionController.dispose();

    estadoEmisionController.dispose();

    numeroPasaportePerdidoController.dispose();

    paisPasaportePerdidoController.dispose();

    explicacionController.dispose();

    super.dispose();

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

            "Información del Pasaporte",

          ),

        ),

        body: Form(

            key: _formKey,

            child: ListView(

              padding: const EdgeInsets.all(20),

              children: [

              const Text(

                "PASO 7 DE 18",

              style: TextStyle(

                color: AppColors.primary,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 8),

            const Text(

              "Información del Pasaporte",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 10),

            const Text(

              "Completa la información principal de tu pasaporte vigente.",

              style: TextStyle(

                color: AppColors.textSecondary,

                height: 1.4,

              ),

            ),

            const SizedBox(height: 30),

            TextFormField(

              controller: numeroPasaporteController,

              decoration: decoration(

                "Número de pasaporte",

                Icons.book,

              ),

              validator: (value) {

                if (value == null || value.isEmpty) {

                  return "Ingrese el número de pasaporte";

                }

                return null;

              },

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller: paisEmisorController,

              decoration: decoration(

                "País que emitió el pasaporte",

                Icons.flag,

              ),

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller: ciudadEmisionController,

              decoration: decoration(

                "Ciudad donde fue emitido",

                Icons.location_city,

              ),

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller: estadoEmisionController,

              decoration: decoration(

                "Provincia / Estado de emisión",

                Icons.map,

              ),

            ),

            const SizedBox(height: 20),

            ListTile(

              leading: const Icon(Icons.calendar_month),

              title: Text(

                fechaEmision == null

                    ? "Fecha de emisión"

                    : "${fechaEmision!.day}/${fechaEmision!.month}/${fechaEmision!.year}",

              ),

              trailing: const Icon(Icons.arrow_drop_down),

              onTap: seleccionarFechaEmision,

            ),

            const SizedBox(height: 15),

            ListTile(

              leading: const Icon(Icons.event),

              title: Text(

                fechaVencimiento == null

                    ? "Fecha de vencimiento"

                    : "${fechaVencimiento!.day}/${fechaVencimiento!.month}/${fechaVencimiento!.year}",

              ),

              trailing: const Icon(Icons.arrow_drop_down),

              onTap: seleccionarFechaVencimiento,

            ),

            const SizedBox(height: 25),

            SwitchListTile(

              value: perdioPasaporte,

              title: const Text(

                "¿Ha perdido o le han robado un pasaporte?",

              ),

              onChanged: (value) {

                setState(() {

                  perdioPasaporte = value;

                });

              },

            ),

            if (perdioPasaporte) ...[

              const SizedBox(height: 15),

              TextFormField(

                controller: numeroPasaportePerdidoController,

                decoration: decoration(

                  "Número del pasaporte perdido (si lo recuerda)",

                  Icons.book_outlined,

                ),

              ),

              const SizedBox(height: 20),

              TextFormField(

                controller: paisPasaportePerdidoController,

                decoration: decoration(

                  "País que emitió ese pasaporte",

                  Icons.flag,

                ),

              ),

              const SizedBox(height: 20),

              TextFormField(

                controller: explicacionController,

                maxLines: 4,

                decoration: decoration(

                  "Explique brevemente lo ocurrido",

                  Icons.description,

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

                      if (fechaEmision == null ||
                          fechaVencimiento == null) {

                        ScaffoldMessenger.of(context).showSnackBar(

                          const SnackBar(

                            content: Text(
                              "Complete la fecha de emisión y la fecha de vencimiento del pasaporte.",
                            ),

                          ),

                        );

                        return;

                      }

                      final passportInformation =

                      PassportInformation(

                        passportNumber:
                        numeroPasaporteController.text.trim(),

                        passportBookNumber: "",

                        hasPassportBookNumber: false,

                        issuingCountry:
                        paisEmisorController.text.trim(),

                        issuingCity:
                        ciudadEmisionController.text.trim(),

                        issuingState:
                        estadoEmisionController.text.trim(),

                        issueDate:
                        fechaEmision!,

                        expirationDate:
                        fechaVencimiento!,

                        hasLostPassport:
                        perdioPasaporte,

                        lostPassportNumber:
                        numeroPasaportePerdidoController.text.trim(),

                        lostPassportCountry:
                        paisPasaportePerdidoController.text.trim(),

                        explanation:
                        explicacionController.text.trim(),

                      );

                      await _expedienteService.savePassportInformation(

                        expedienteId: widget.expediente.id,

                        passportInformation: passportInformation,

                      );

                      await _progressService.saveStep(

                        expedienteId: widget.expediente.id,

                        step: 8,

                      );

                      if (!mounted) return;

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => AddressScreen(
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

              ],

            ),

        ),

    );

  }

}