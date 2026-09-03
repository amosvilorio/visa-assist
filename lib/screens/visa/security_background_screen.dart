import 'package:flutter/material.dart';
import 'additional_information_screen.dart';
import '../../models/security_background.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';
import '../../widgets/visa/visa_text_field.dart';
import '../../widgets/visa/visa_yes_no_question.dart';
import '../../models/expediente.dart';

class SecurityBackgroundScreen extends StatefulWidget {

  final Expediente expediente;

  const SecurityBackgroundScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<SecurityBackgroundScreen> createState() =>
      _SecurityBackgroundScreenState();
}

class _SecurityBackgroundScreenState
    extends State<SecurityBackgroundScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  bool _loading = true;
  bool _saving = false;

  //--------------------------------------------------
  // SALUD
  //--------------------------------------------------

  bool _communicableDisease = false;
  bool _mentalDisorder = false;
  bool _drugAbuser = false;

  //--------------------------------------------------
  // CRIMINAL
  //--------------------------------------------------

  bool _arrested = false;
  bool _controlledSubstances = false;
  bool _prostitution = false;
  bool _moneyLaundering = false;

  //--------------------------------------------------
  // SEGURIDAD
  //--------------------------------------------------

  bool _espionage = false;
  bool _terrorism = false;
  bool _genocide = false;
  bool _torture = false;
  bool _childSoldier = false;

  //--------------------------------------------------
  // INMIGRACIÓN
  //--------------------------------------------------

  bool _visaFraud = false;
  bool _deported = false;
  bool _unlawfullyPresent = false;

  //--------------------------------------------------
  // EXPLICACIÓN
  //--------------------------------------------------

  final _explanationController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSecurityBackground();
  }


  Future<void> _loadSecurityBackground() async {

    final security =
        widget.expediente.securityBackground;

    if (security != null) {

      _communicableDisease =
          security.hasCommunicableDisease;

      _mentalDisorder =
          security.hasMentalDisorder;

      _drugAbuser =
          security.drugAbuser;

      _arrested =
          security.arrestedOrConvicted;

      _controlledSubstances =
          security.violatedControlledSubstancesLaw;

      _prostitution =
          security.prostitutionOrVice;

      _moneyLaundering =
          security.moneyLaundering;

      _espionage =
          security.espionage;

      _terrorism =
          security.terrorism;

      _genocide =
          security.genocide;

      _torture =
          security.torture;

      _childSoldier =
          security.childSoldier;

      _visaFraud =
          security.visaFraud;

      _deported =
          security.deported;

      _unlawfullyPresent =
          security.unlawfullyPresent;

      _explanationController.text =
          security.explanation;
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final security = SecurityBackground(

      hasCommunicableDisease:
      _communicableDisease,

      hasMentalDisorder:
      _mentalDisorder,

      drugAbuser:
      _drugAbuser,

      arrestedOrConvicted:
      _arrested,

      violatedControlledSubstancesLaw:
      _controlledSubstances,

      prostitutionOrVice:
      _prostitution,

      moneyLaundering:
      _moneyLaundering,

      espionage:
      _espionage,

      terrorism:
      _terrorism,

      genocide:
      _genocide,

      torture:
      _torture,

      childSoldier:
      _childSoldier,

      visaFraud:
      _visaFraud,

      deported:
      _deported,

      unlawfullyPresent:
      _unlawfullyPresent,

      explanation:
      _explanationController.text.trim(),
    );

    await _expedienteService.saveSecurityBackground(
      expedienteId: widget.expediente.id,
      securityBackground: security,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    await _progressService.saveStep(
      expedienteId: widget.expediente.id,
      step: 16,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdditionalInformationScreen(
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
        title: const Text("Seguridad y Antecedentes"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const VisaStepHeader(
                  currentStep: 15,
                  totalSteps: 18,
                  title: "Seguridad y Antecedentes",
                  description:
                  "Responda todas las preguntas con honestidad.",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        VisaSectionCard(
                          title: "Salud",
                          icon: Icons.health_and_safety,
                          child: Column(
                            children: [

                              VisaYesNoQuestion(
                                question:
                                "¿Padece alguna enfermedad contagiosa?",
                                value: _communicableDisease,
                                onChanged: (value) {
                                  setState(() {
                                    _communicableDisease = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Tiene algún trastorno mental que represente un riesgo para usted o para otras personas?",
                                value: _mentalDisorder,
                                onChanged: (value) {
                                  setState(() {
                                    _mentalDisorder = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha consumido o consume drogas ilícitas?",
                                value: _drugAbuser,
                                onChanged: (value) {
                                  setState(() {
                                    _drugAbuser = value;
                                  });
                                },
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Antecedentes Penales",
                          icon: Icons.gavel,
                          child: Column(
                            children: [

                              VisaYesNoQuestion(
                                question:
                                "¿Ha sido arrestado o condenado por algún delito?",
                                value: _arrested,
                                onChanged: (value) {
                                  setState(() {
                                    _arrested = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha violado leyes relacionadas con sustancias controladas?",
                                value: _controlledSubstances,
                                onChanged: (value) {
                                  setState(() {
                                    _controlledSubstances = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en prostitución o actividades relacionadas?",
                                value: _prostitution,
                                onChanged: (value) {
                                  setState(() {
                                    _prostitution = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en lavado de dinero?",
                                value: _moneyLaundering,
                                onChanged: (value) {
                                  setState(() {
                                    _moneyLaundering = value;
                                  });
                                },
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Seguridad",
                          icon: Icons.security,
                          child: Column(
                            children: [

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en espionaje?",
                                value: _espionage,
                                onChanged: (value) {
                                  setState(() {
                                    _espionage = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en actividades terroristas?",
                                value: _terrorism,
                                onChanged: (value) {
                                  setState(() {
                                    _terrorism = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en genocidio?",
                                value: _genocide,
                                onChanged: (value) {
                                  setState(() {
                                    _genocide = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha participado en tortura?",
                                value: _torture,
                                onChanged: (value) {
                                  setState(() {
                                    _torture = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha utilizado niños soldados?",
                                value: _childSoldier,
                                onChanged: (value) {
                                  setState(() {
                                    _childSoldier = value;
                                  });
                                },
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Historial Migratorio",
                          icon: Icons.public,
                          child: Column(
                            children: [

                              VisaYesNoQuestion(
                                question:
                                "¿Ha cometido fraude para obtener una visa estadounidense?",
                                value: _visaFraud,
                                onChanged: (value) {
                                  setState(() {
                                    _visaFraud = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha sido deportado de algún país?",
                                value: _deported,
                                onChanged: (value) {
                                  setState(() {
                                    _deported = value;
                                  });
                                },
                              ),

                              VisaYesNoQuestion(
                                question:
                                "¿Ha permanecido ilegalmente en los Estados Unidos?",
                                value: _unlawfullyPresent,
                                onChanged: (value) {
                                  setState(() {
                                    _unlawfullyPresent = value;
                                  });
                                },
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Información adicional",
                          icon: Icons.description,
                          child: VisaTextField(
                            controller: _explanationController,
                            label:
                            "Explique cualquier respuesta afirmativa",
                            hint:
                            "Escriba una explicación si respondió 'Sí' a alguna pregunta.",
                            maxLines: 5,
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