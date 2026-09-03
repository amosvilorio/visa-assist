import 'package:flutter/material.dart';
import '../expedientes/summary_screen.dart';
import '../../models/additional_information.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';
import '../../widgets/visa/visa_text_field.dart';
import '../../models/expediente.dart';

class AdditionalInformationScreen extends StatefulWidget {
  final bool viewOnly;
  final Expediente? expediente;

  const AdditionalInformationScreen({
    super.key,
    this.viewOnly = false,
    this.expediente,
  });

  @override
  State<AdditionalInformationScreen> createState() =>
      _AdditionalInformationScreenState();
}

class _AdditionalInformationScreenState
    extends State<AdditionalInformationScreen> {

  final _formKey = GlobalKey<FormState>();

  Expediente? _expediente;

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  bool _loading = true;
  bool _saving = false;

  //--------------------------------------------------
  // CONTROLADORES
  //--------------------------------------------------

  final _languagesController =
  TextEditingController();

  final _socialNetworksController =
  TextEditingController();

  final _usernameController =
  TextEditingController();

  final _notesController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInformation();
  }


  Future<void> _loadInformation() async {

    final expediente = widget.expediente;

    if (expediente == null) {

      if (!mounted) return;

      Navigator.pop(context);

      return;
    }

    // Usamos únicamente el expediente recibido.
    _expediente = expediente;

    final information =
        expediente.additionalInformation;

    if (information != null) {

      _languagesController.text =
          information.languages;

      _socialNetworksController.text =
          information.socialNetworks;

      _usernameController.text =
          information.socialMediaUsername;

      _notesController.text =
          information.additionalNotes;
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _languagesController.dispose();
    _socialNetworksController.dispose();
    _usernameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final information = AdditionalInformation(
      languages:
      _languagesController.text.trim(),

      socialNetworks:
      _socialNetworksController.text.trim(),

      socialMediaUsername:
      _usernameController.text.trim(),

      additionalNotes:
      _notesController.text.trim(),
    );

    if (_expediente == null) {
      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No se encontró el expediente.",
          ),
        ),
      );

      return;
    }

    await _expedienteService.saveAdditionalInformation(
      expedienteId: _expediente!.id,
      additionalInformation: information,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    await _progressService.saveStep(
      expedienteId: _expediente!.id,
      step: 17,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryScreen(
          expediente: _expediente!,
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
        title: const Text("Información Adicional"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const VisaStepHeader(
                  currentStep: 17,
                  totalSteps: 18,
                  title: "Información Adicional",
                  description:
                  "Complete los siguientes campos si aplica.",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        VisaSectionCard(
                          title: "Idiomas",
                          icon: Icons.language,
                          child: VisaTextField(
                            controller: _languagesController,
                            label: "Idiomas que habla",
                            hint:
                            "Ejemplo: Español, Inglés",
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Redes Sociales",
                          icon: Icons.public,
                          child: Column(
                            children: [
                              VisaTextField(
                                controller:
                                _socialNetworksController,
                                label:
                                "Redes sociales utilizadas",
                                hint:
                                "Ejemplo: Facebook, Instagram, TikTok",
                              ),

                              const SizedBox(height: 16),

                              VisaTextField(
                                controller:
                                _usernameController,
                                label:
                                "Nombre de usuario (Opcional)",
                                hint:
                                "@usuario",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        VisaSectionCard(
                          title: "Información adicional",
                          icon: Icons.description,
                          child: VisaTextField(
                            controller: _notesController,
                            label:
                            "Información adicional (Opcional)",
                            hint:
                            "Escriba cualquier información que considere importante.",
                            maxLines: 5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade200,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Si durante la revisión de su expediente necesitamos información o documentos adicionales, nos comunicaremos con usted mediante la aplicación o por WhatsApp.",
                                  style: TextStyle(
                                    color:
                                    Colors.blue.shade900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (!widget.viewOnly)
                  VisaPrimaryButton(
                    text: "Guardar y continuar",
                    icon: Icons.check_circle_outline,
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