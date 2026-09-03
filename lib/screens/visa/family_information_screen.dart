import 'package:flutter/material.dart';
import 'work_education_information_screen.dart';
import '../../models/family_information.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_dropdown.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';
import '../../widgets/visa/visa_text_field.dart';
import '../../models/expediente.dart';

class FamilyInformationScreen extends StatefulWidget {

  final Expediente expediente;

  const FamilyInformationScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<FamilyInformationScreen> createState() =>
      _FamilyInformationScreenState();
}

class _FamilyInformationScreenState
    extends State<FamilyInformationScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  bool _loading = false;
  bool _saving = false;

  //----------------------------------------------------
  // PADRE
  //----------------------------------------------------

  final _fatherSurnameController =
  TextEditingController();

  final _fatherGivenNamesController =
  TextEditingController();

  DateTime? _fatherBirthDate;

  bool _fatherInUs = false;

  String? _fatherStatus;

  //----------------------------------------------------
  // MADRE
  //----------------------------------------------------

  final _motherSurnameController =
  TextEditingController();

  final _motherGivenNamesController =
  TextEditingController();

  DateTime? _motherBirthDate;

  bool _motherInUs = false;

  String? _motherStatus;

  //----------------------------------------------------
  // FAMILIARES
  //----------------------------------------------------

  bool _hasImmediateRelatives = false;

  final _immediateNameController =
  TextEditingController();

  final _relationshipController =
  TextEditingController();

  String? _relativeStatus;

  bool _hasOtherRelatives = false;

  final _otherRelativeController =
  TextEditingController();

  final List<String> _statusList = const [



    "Ciudadano estadounidense",

    "Residente permanente",

    "No inmigrante",

    "Otro",

  ];

  void cargarInformacion() {

    final family = widget.expediente.familyInformation;

    if (family == null) return;


    setState(() {

      _fatherSurnameController.text =
          family.fatherSurname;

      _fatherGivenNamesController.text =
          family.fatherGivenNames;


      _fatherBirthDate =
          family.fatherDateOfBirth;


      _fatherInUs =
          family.fatherInUs;


      _fatherStatus =
      family.fatherStatus.isEmpty
          ? null
          : family.fatherStatus;



      _motherSurnameController.text =
          family.motherSurname;


      _motherGivenNamesController.text =
          family.motherGivenNames;


      _motherBirthDate =
          family.motherDateOfBirth;


      _motherInUs =
          family.motherInUs;


      _motherStatus =
      family.motherStatus.isEmpty
          ? null
          : family.motherStatus;



      _hasImmediateRelatives =
          family.hasImmediateRelatives;

      _immediateNameController.text =
          family.immediateRelativeName;

      _relationshipController.text =
          family.immediateRelativeRelationship;

      _relativeStatus =
      family.immediateRelativeStatus.isEmpty
          ? null
          : family.immediateRelativeStatus;

      _hasOtherRelatives =
          family.hasOtherRelatives;

      _otherRelativeController.text =
          family.otherRelativeDescription;

    });

  }



  @override
  void initState() {
    super.initState();

    cargarInformacion();
  }

  @override
  void dispose() {

    _fatherSurnameController.dispose();

    _fatherGivenNamesController.dispose();

    _motherSurnameController.dispose();

    _motherGivenNamesController.dispose();

    _immediateNameController.dispose();

    _relationshipController.dispose();

    _otherRelativeController.dispose();

    super.dispose();

  }

  Future<void> _selectFatherBirthDate() async {

    final date = await showDatePicker(

      context: context,

      initialDate:
      DateTime(1970),

      firstDate:
      DateTime(1900),

      lastDate:
      DateTime.now(),

    );

    if (date != null) {

      setState(() {

        _fatherBirthDate = date;

      });

    }

  }

  Future<void> _selectMotherBirthDate() async {

    final date = await showDatePicker(

      context: context,

      initialDate:
      DateTime(1970),

      firstDate:
      DateTime(1900),

      lastDate:
      DateTime.now(),

    );

    if (date != null) {

      setState(() {

        _motherBirthDate = date;

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

    final family = FamilyInformation(

      fatherSurname:
      _fatherSurnameController.text.trim(),

      fatherGivenNames:
      _fatherGivenNamesController.text.trim(),

      fatherDateOfBirth:
      _fatherBirthDate,

      fatherInUs:
      _fatherInUs,

      fatherStatus:
      _fatherStatus ?? "",

      motherSurname:
      _motherSurnameController.text.trim(),

      motherGivenNames:
      _motherGivenNamesController.text.trim(),

      motherDateOfBirth:
      _motherBirthDate,

      motherInUs:
      _motherInUs,

      motherStatus:
      _motherStatus ?? "",

      hasImmediateRelatives:
      _hasImmediateRelatives,

      immediateRelativeName:
      _immediateNameController.text.trim(),

      immediateRelativeRelationship:
      _relationshipController.text.trim(),

      immediateRelativeStatus:
      _relativeStatus ?? "",

      hasOtherRelatives:
      _hasOtherRelatives,

      otherRelativeDescription:
      _otherRelativeController.text.trim(),

    );

    await _expedienteService.saveFamilyInformation(
      expedienteId: widget.expediente.id,
      familyInformation: family,
    );

    if (!mounted) return;

    setState(() {

      _saving = false;

    });

    await _progressService.saveStep(
      expedienteId: widget.expediente.id,
      step: 14,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkEducationInformationScreen(
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
        title: const Text("Información Familiar"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const VisaStepHeader(
                  currentStep: 13,
                  totalSteps: 18,
                  title: "Información Familiar",
                  description:
                  "Complete la información de sus padres y familiares en los Estados Unidos.",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        //--------------------------------------------------
                        // PADRE
                        //--------------------------------------------------

                        VisaSectionCard(
                          title: "Padre",
                          icon: Icons.man,
                          child: Column(
                            children: [

                              VisaTextField(
                                controller:
                                _fatherSurnameController,
                                label: "Apellido",
                                hint: "Apellido del padre",
                              ),

                              VisaTextField(
                                controller:
                                _fatherGivenNamesController,
                                label: "Nombre",
                                hint: "Nombre del padre",
                              ),

                              ListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.calendar_month,
                                ),
                                title: Text(
                                  _fatherBirthDate == null
                                      ? "Fecha de nacimiento"
                                      : "${_fatherBirthDate!.day}/${_fatherBirthDate!.month}/${_fatherBirthDate!.year}",
                                ),
                                trailing: const Icon(
                                  Icons.edit_calendar,
                                ),
                                onTap:
                                _selectFatherBirthDate,
                              ),

                              SwitchListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                title: const Text(
                                  "¿Está en EE.UU.?",
                                ),
                                value: _fatherInUs,
                                onChanged: (value) {
                                  setState(() {
                                    _fatherInUs = value;
                                  });
                                },
                              ),

                              if (_fatherInUs)

                                VisaDropdown<String>(
                                  label:
                                  "Estatus migratorio",
                                  value: _fatherStatus,
                                  items: _statusList
                                      .map(
                                        (e) =>
                                        DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                  )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _fatherStatus =
                                          value;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //--------------------------------------------------
                        // MADRE
                        //--------------------------------------------------

                        VisaSectionCard(
                          title: "Madre",
                          icon: Icons.woman,
                          child: Column(
                            children: [

                              VisaTextField(
                                controller:
                                _motherSurnameController,
                                label: "Apellido",
                                hint: "Apellido de la madre",
                              ),

                              VisaTextField(
                                controller:
                                _motherGivenNamesController,
                                label: "Nombre",
                                hint: "Nombre de la madre",
                              ),

                              ListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.calendar_month,
                                ),
                                title: Text(
                                  _motherBirthDate == null
                                      ? "Fecha de nacimiento"
                                      : "${_motherBirthDate!.day}/${_motherBirthDate!.month}/${_motherBirthDate!.year}",
                                ),
                                trailing: const Icon(
                                  Icons.edit_calendar,
                                ),
                                onTap:
                                _selectMotherBirthDate,
                              ),

                              SwitchListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                title: const Text(
                                  "¿Está en EE.UU.?",
                                ),
                                value: _motherInUs,
                                onChanged: (value) {
                                  setState(() {
                                    _motherInUs = value;
                                  });
                                },
                              ),

                              if (_motherInUs)

                                VisaDropdown<String>(
                                  label:
                                  "Estatus migratorio",
                                  value: _motherStatus,
                                  items: _statusList
                                      .map(
                                        (e) =>
                                        DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                  )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _motherStatus =
                                          value;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //--------------------------------------------------
                        // FAMILIARES
                        //--------------------------------------------------

                        VisaSectionCard(
                          title:
                          "Familiares en Estados Unidos",
                          icon: Icons.family_restroom,
                          child: Column(
                            children: [

                              SwitchListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                title: const Text(
                                  "¿Tiene familiares inmediatos en EE.UU.?",
                                ),
                                value:
                                _hasImmediateRelatives,
                                onChanged: (value) {
                                  setState(() {
                                    _hasImmediateRelatives =
                                        value;
                                  });
                                },
                              ),

                              if (_hasImmediateRelatives)
                                Column(
                                  children: [

                                    VisaTextField(
                                      controller:
                                      _immediateNameController,
                                      label:
                                      "Nombre del familiar",
                                      hint:
                                      "Nombre completo",
                                    ),

                                    VisaTextField(
                                      controller:
                                      _relationshipController,
                                      label: "Relación",
                                      hint:
                                      "Ej: Hermano",
                                    ),

                                    VisaDropdown<String>(
                                      label:
                                      "Estatus migratorio",
                                      value:
                                      _relativeStatus,
                                      items: _statusList
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
                                          _relativeStatus =
                                              value;
                                        });
                                      },
                                    ),
                                  ],
                                ),

                              SwitchListTile(
                                contentPadding:
                                EdgeInsets.zero,
                                title: const Text(
                                  "¿Tiene otros familiares en EE.UU.?",
                                ),
                                value:
                                _hasOtherRelatives,
                                onChanged: (value) {
                                  setState(() {
                                    _hasOtherRelatives =
                                        value;
                                  });
                                },
                              ),

                              if (_hasOtherRelatives)

                                VisaTextField(
                                  controller:
                                  _otherRelativeController,
                                  label:
                                  "Describa los familiares",
                                  hint:
                                  "Información adicional",
                                  maxLines: 3,
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

