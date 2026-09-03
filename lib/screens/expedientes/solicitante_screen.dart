import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'personal_information_screen.dart';
import '../../services/progress_service.dart';
import '../../services/expediente_service.dart';
import '../../models/applicant.dart';
import '../../models/expediente.dart';

class SolicitanteScreen extends StatefulWidget {

  final Expediente expediente;
  final bool viewOnly;

  const SolicitanteScreen({
    super.key,
    required this.expediente,
    this.viewOnly = false,
  });

  @override
  State<SolicitanteScreen> createState() => _SolicitanteScreenState();
}

class _SolicitanteScreenState extends State<SolicitanteScreen> {
  final ProgressService _progressService =
      ProgressService.instance;

  final ExpedienteService _expedienteService =
  ExpedienteService();
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final parentescoController = TextEditingController();

  DateTime? fechaNacimiento;

  String sexo = "Masculino";

  String tipoSolicitante = "Yo";

  String parentesco = "";

  bool menorEdad = false;

  @override
  void initState() {
    super.initState();

    if (!widget.viewOnly) {
      guardarProgreso();
    }

    cargarSolicitante();
  }

  Future<void> cargarSolicitante() async {

    final expediente = widget.expediente;

    if (expediente.applicant == null) return;

    final applicant = expediente.applicant!;

    setState(() {

      nombreController.text = applicant.firstName;

      apellidoController.text = applicant.lastName;

      fechaNacimiento = applicant.birthDate;

      sexo = applicant.gender;

      tipoSolicitante = applicant.applicantType;

      parentesco = applicant.relationship;
      parentescoController.text = applicant.relationship;

      menorEdad = applicant.isMinor;

    });

  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    parentescoController.dispose();
    super.dispose();
  }

  Future<void> guardarProgreso() async {

    await _progressService.saveStep(

      expedienteId: widget.expediente.id,

      step: 6,

    );

  }

  Future<void> seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      final edad = DateTime.now().year - fecha.year;

      setState(() {
        fechaNacimiento = fecha;
        menorEdad = edad < 18;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Nuevo Expediente"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            const Text(
              "PASO 5 DE 18",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Datos del solicitante",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Completa la información básica.",
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            TextFormField(
              controller: nombreController,
              readOnly: widget.viewOnly,
              decoration: const InputDecoration(
                labelText: "Nombre(s)",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Ingrese el nombre";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: apellidoController,
              readOnly: widget.viewOnly,
              decoration: const InputDecoration(
                labelText: "Apellido(s)",
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Ingrese el apellido";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              leading: const Icon(Icons.calendar_month),
              title: Text(
                fechaNacimiento == null
                    ? "Fecha de nacimiento"
                    : "${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}",
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: widget.viewOnly ? null : seleccionarFecha,
            ),

            const SizedBox(height: 25),

            const Text(
              "Sexo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile(
              value: "Masculino",
              groupValue: sexo,
              onChanged: widget.viewOnly
                  ? null
                  : (v) {
                setState(() {
                  sexo = v.toString();
                });
              },
              title: const Text("Masculino"),
            ),

            RadioListTile(
              value: "Femenino",
              groupValue: sexo,
              onChanged: widget.viewOnly
                  ? null
                  : (v) {
                setState(() {
                  sexo = v.toString();
                });
              },
              title: const Text("Femenino"),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: tipoSolicitante,
              decoration: const InputDecoration(
                labelText: "¿Quién solicita la visa?",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Yo",
                  child: Text("Yo"),
                ),
                DropdownMenuItem(
                  value: "Familiar",
                  child: Text("Familiar"),
                ),
                DropdownMenuItem(
                  value: "Otra Persona",
                  child: Text("Otra Persona"),
                ),
              ],
              onChanged: widget.viewOnly
                  ? null
                  : (v) {
                setState(() {
                  tipoSolicitante = v!;
                });
              },
            ),

            if (tipoSolicitante == "Familiar") ...[
              const SizedBox(height: 20),


              TextFormField(
                controller: parentescoController,
                readOnly: widget.viewOnly,
                decoration: const InputDecoration(
                  labelText: "Parentesco",
                ),
                onChanged: (v) {
                  parentesco = v;
                },
              ),
            ],

            if (menorEdad) ...[
              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Se detectó que el solicitante es menor de edad. Más adelante el formulario solicitará únicamente la información correspondiente para menores.",
                ),
              ),
            ],

            const SizedBox(height: 35),

            if (!widget.viewOnly)
              SizedBox(
                height: 55,
                child: ElevatedButton(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  if (fechaNacimiento == null) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Seleccione la fecha de nacimiento.",
                        ),
                      ),
                    );

                    return;

                  }

                  final applicant = Applicant(

                    firstName: nombreController.text.trim(),

                    lastName: apellidoController.text.trim(),

                    birthDate: fechaNacimiento!,

                    gender: sexo,

                    applicantType: tipoSolicitante,

                    relationship: parentesco,

                    isMinor: menorEdad,

                  );

                  await _expedienteService.saveApplicant(

                    expedienteId: widget.expediente.id,

                    applicant: applicant,

                  );

                  await _progressService.saveStep(
                    expedienteId: widget.expediente.id,
                    step: 6,
                  );

                  if (!mounted) return;

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => PersonalInformationScreen(
                        expediente: widget.expediente,
                      ),

                    ),

                  );

                },

                child: const Text(
                  "CONTINUAR",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}