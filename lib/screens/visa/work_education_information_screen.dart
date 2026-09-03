import 'package:flutter/material.dart';
import 'security_background_screen.dart';
import '../../models/work_education_information.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_dropdown.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';
import '../../widgets/visa/visa_text_field.dart';
import '../../models/expediente.dart';

class WorkEducationInformationScreen extends StatefulWidget {

  final Expediente expediente;

  const WorkEducationInformationScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<WorkEducationInformationScreen> createState() =>
      _WorkEducationInformationScreenState();
}

class _WorkEducationInformationScreenState
    extends State<WorkEducationInformationScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  bool _loading = false;
  bool _saving = false;

  Expediente? _expediente;

  //--------------------------------------------------
  // EMPLEO ACTUAL
  //--------------------------------------------------

  final _employerController =
  TextEditingController();

  final _streetController =
  TextEditingController();

  final _cityController =
  TextEditingController();

  final _stateController =
  TextEditingController();

  final _postalController =
  TextEditingController();

  final _countryController =
  TextEditingController();

  final _phoneController =
  TextEditingController();

  final _salaryController =
  TextEditingController();

  final _dutiesController =
  TextEditingController();

  DateTime? _startDate;

  String? _occupation;

  //--------------------------------------------------
  // EMPLEO ANTERIOR
  //--------------------------------------------------

  bool _hasPreviousEmployment = false;

  final _previousEmployerController =
  TextEditingController();

  final _previousOccupationController =
  TextEditingController();

  //--------------------------------------------------
  // EDUCACIÓN
  //--------------------------------------------------

  String? _educationLevel;

  final _institutionController =
  TextEditingController();

  final _courseController =
  TextEditingController();

  final List<String> _occupations = const [

    "Agricultura",

    "Negocios",

    "Educación",

    "Gobierno",

    "Ingeniería",

    "Médico",

    "Militar",

    "Religión",

    "Estudiante",

    "Desempleado",

    "Otro",

  ];

  final List<String> _educationLevels = const [

    "Primaria",

    "Secundaria",

    "Universidad",

    "Maestría",

    "Doctorado",

    "Otro",

  ];

  @override
  void initState() {
    super.initState();

    _expediente = widget.expediente;

    _loadInformation();
  }

  Future<void> _loadInformation() async {

    final work = widget.expediente.workEducationInformation;

    if (work != null) {

      _occupation = work.occupation;

      _employerController.text =
          work.employerName;

      _streetController.text =
          work.streetAddress;

      _cityController.text =
          work.city;

      _stateController.text =
          work.stateProvince;

      _postalController.text =
          work.postalCode;

      _countryController.text =
          work.country;

      _phoneController.text =
          work.phoneNumber;

      _startDate =
          work.startDate;

      _salaryController.text =
          work.monthlySalary;

      _dutiesController.text =
          work.duties;

      _hasPreviousEmployment =
          work.hasPreviousEmployment;

      _previousEmployerController.text =
          work.previousEmployer;

      _previousOccupationController.text =
          work.previousOccupation;

      _educationLevel =
          work.highestEducationLevel;

      _institutionController.text =
          work.institutionName;

      _courseController.text =
          work.courseOfStudy;
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {

    _employerController.dispose();

    _streetController.dispose();

    _cityController.dispose();

    _stateController.dispose();

    _postalController.dispose();

    _countryController.dispose();

    _phoneController.dispose();

    _salaryController.dispose();

    _dutiesController.dispose();

    _previousEmployerController.dispose();

    _previousOccupationController.dispose();

    _institutionController.dispose();

    _courseController.dispose();

    super.dispose();

  }

  Future<void> _selectStartDate() async {

    final date = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(1950),

      lastDate: DateTime.now(),

    );

    if (date != null) {

      setState(() {

        _startDate = date;

      });

    }

  }

  Future<void> _saveAndContinue() async {

    if (!_formKey.currentState!.validate()) {

      return;

    }

    setState(() {

      _saving = true;

    });

    final work =
    WorkEducationInformation(

      occupation:
      _occupation ?? "",

      employerName:
      _employerController.text.trim(),

      streetAddress:
      _streetController.text.trim(),

      city:
      _cityController.text.trim(),

      stateProvince:
      _stateController.text.trim(),

      postalCode:
      _postalController.text.trim(),

      country:
      _countryController.text.trim(),

      phoneNumber:
      _phoneController.text.trim(),

      startDate:
      _startDate,

      monthlySalary:
      _salaryController.text.trim(),

      duties:
      _dutiesController.text.trim(),

      hasPreviousEmployment:
      _hasPreviousEmployment,

      previousEmployer:
      _previousEmployerController.text.trim(),

      previousOccupation:
      _previousOccupationController.text.trim(),

      highestEducationLevel:
      _educationLevel ?? "",

      institutionName:
      _institutionController.text.trim(),

      courseOfStudy:
      _courseController.text.trim(),

    );

    await _expedienteService.saveWorkEducationInformation(
      expedienteId: widget.expediente.id,
      workEducationInformation: work,
    );

    if (!mounted) return;

    setState(() {

      _saving = false;

    });

    await _progressService.saveStep(
      expedienteId: widget.expediente.id,
      step: 15,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurityBackgroundScreen(
          expediente: widget.expediente,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trabajo y Educación"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const VisaStepHeader(
                  currentStep: 14,
                  totalSteps: 18,
                  title: "Trabajo y Educación",
                  description:
                  "Complete la información sobre su empleo actual, empleos anteriores y estudios.",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        //--------------------------------------------------
                        // EMPLEO ACTUAL
                        //--------------------------------------------------

                        VisaSectionCard(
                          title: "Empleo actual",
                          icon: Icons.work,
                          child: Column(
                            children: [

                              VisaDropdown<String>(
                                label: "Ocupación",
                                value: _occupation,
                                items: _occupations
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _occupation = value;
                                  });
                                },
                              ),

                              VisaTextField(
                                controller: _employerController,
                                label: "Empresa",
                                hint: "Nombre del empleador",
                              ),

                              VisaTextField(
                                controller: _streetController,
                                label: "Dirección",
                                hint: "Dirección del trabajo",
                              ),

                              VisaTextField(
                                controller: _cityController,
                                label: "Ciudad",
                                hint: "Ciudad",
                              ),

                              VisaTextField(
                                controller: _stateController,
                                label: "Estado / Provincia",
                                hint: "Estado",
                              ),

                              VisaTextField(
                                controller: _postalController,
                                label: "Código Postal",
                                hint: "Código Postal",
                              ),

                              VisaTextField(
                                controller: _countryController,
                                label: "País",
                                hint: "País",
                              ),

                              VisaTextField(
                                controller: _phoneController,
                                label: "Teléfono",
                                hint: "Número telefónico",
                                keyboardType:
                                TextInputType.phone,
                              ),

                              ListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.calendar_month,
                                ),
                                title: Text(
                                  _startDate == null
                                      ? "Fecha de inicio"
                                      : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                                ),
                                trailing: const Icon(
                                  Icons.edit_calendar,
                                ),
                                onTap: _selectStartDate,
                              ),

                              VisaTextField(
                                controller: _salaryController,
                                label: "Salario mensual",
                                hint: "Monto",
                                keyboardType:
                                TextInputType.number,
                              ),

                              VisaTextField(
                                controller: _dutiesController,
                                label: "Funciones",
                                hint: "Describa sus funciones",
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //--------------------------------------------------
                        // EMPLEO ANTERIOR
                        //--------------------------------------------------

                        VisaSectionCard(
                          title: "Empleo anterior",
                          icon: Icons.history,
                          child: Column(
                            children: [

                              SwitchListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                title: const Text(
                                  "¿Ha trabajado anteriormente?",
                                ),
                                value:
                                _hasPreviousEmployment,
                                onChanged: (value) {
                                  setState(() {
                                    _hasPreviousEmployment =
                                        value;
                                  });
                                },
                              ),

                              if (_hasPreviousEmployment)
                                Column(
                                  children: [

                                    VisaTextField(
                                      controller:
                                      _previousEmployerController,
                                      label:
                                      "Empresa anterior",
                                      hint:
                                      "Nombre de la empresa",
                                    ),

                                    VisaTextField(
                                      controller:
                                      _previousOccupationController,
                                      label:
                                      "Cargo desempeñado",
                                      hint:
                                      "Cargo",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //--------------------------------------------------
                        // EDUCACIÓN
                        //--------------------------------------------------

                        VisaSectionCard(
                          title: "Educación",
                          icon: Icons.school,
                          child: Column(
                            children: [

                              VisaDropdown<String>(
                                label:
                                "Nivel educativo",
                                value:
                                _educationLevel,
                                items:
                                _educationLevels
                                    .map(
                                      (e) =>
                                      DropdownMenuItem(
                                        value: e,
                                        child:
                                        Text(e),
                                      ),
                                )
                                    .toList(),
                                onChanged:
                                    (value) {
                                  setState(() {
                                    _educationLevel =
                                        value;
                                  });
                                },
                              ),

                              VisaTextField(
                                controller:
                                _institutionController,
                                label:
                                "Institución",
                                hint:
                                "Nombre de la institución",
                              ),

                              VisaTextField(
                                controller:
                                _courseController,
                                label:
                                "Carrera o área de estudio",
                                hint:
                                "Ej: Ingeniería",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                VisaPrimaryButton(
                  text: "Guardar y continuar",
                  icon: Icons.arrow_forward,
                  loading: _saving,
                  onPressed: _saveAndContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}