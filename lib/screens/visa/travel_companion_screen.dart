import 'package:flutter/material.dart';
import 'us_contact_screen.dart';
import '../../models/expediente.dart';
import '../../models/travel_companion.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/companion_card.dart';
import '../../widgets/visa/companion_dialog.dart';
import '../../widgets/visa/visa_add_button.dart';
import '../../widgets/visa/visa_empty_state.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';

class TravelCompanionScreen extends StatefulWidget {

  final bool viewOnly;

  final Expediente? expediente;

  const TravelCompanionScreen({
    super.key,
    this.viewOnly = false,
    this.expediente,
  });

  @override
  State<TravelCompanionScreen> createState() =>
      _TravelCompanionScreenState();
}

class _TravelCompanionScreenState
    extends State<TravelCompanionScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  Expediente? _expediente;

  bool? _travelingWithOthers;

  bool _loading = true;

  bool _saving = false;

  final List<TravelCompanion> _companions = [];

  @override
  void initState() {
    super.initState();
    _loadExpediente();
  }

  Future<void> _loadExpediente() async {

    final expediente = widget.expediente;

    if (expediente == null) {

      if (!mounted) return;

      Navigator.pop(context);

      return;
    }

    _expediente = expediente;

    _companions.addAll(expediente.travelCompanions);

    _travelingWithOthers =
        expediente.travelingWithOthers ?? false;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _addCompanion() async {

    final TravelCompanion? companion =
    await showDialog<TravelCompanion>(
      context: context,
      builder: (_) => const CompanionDialog(),
    );

    if (companion == null) return;

    setState(() {
      _companions.add(companion);
      _travelingWithOthers = true;
    });
  }

  Future<void> _editCompanion(
      int index,
      ) async {

    final TravelCompanion? companion =
    await showDialog<TravelCompanion>(
      context: context,
      builder: (_) => CompanionDialog(
        companion: _companions[index],
      ),
    );

    if (companion == null) return;

    setState(() {
      _companions[index] = companion;
    });
  }

  Future<void> _deleteCompanion(
      int index,
      ) async {

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
              "Eliminar compañero"),
          content: const Text(
            "¿Desea eliminar este compañero de viaje?",
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    setState(() {

      _companions.removeAt(index);

      if (_companions.isEmpty) {
        _travelingWithOthers = false;
      }

    });
  }

  Future<void> _saveAndContinue() async {

    if (_travelingWithOthers == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Seleccione una opción.",
          ),
        ),
      );

      return;

    }

    if (_travelingWithOthers == true &&
        _companions.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Debe agregar al menos un compañero.",
          ),
        ),
      );

      return;

    }

    setState(() {
      _saving = true;
    });

    await _expedienteService.saveTravelCompanions(
      expedienteId: _expediente!.id,
      travelCompanions: _companions,
      travelingWithOthers: _travelingWithOthers!,
    );

    await _progressService.saveStep(
      expedienteId: _expediente!.id,
      step: 11,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UsContactScreen(),
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
          title: const Text(
            "Compañeros de viaje",
          ),
        ),

        body: SafeArea(

            child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  children: [

                    const VisaStepHeader(
                      currentStep: 11,
                      totalSteps: 18,
                      title: "Compañeros de viaje",
                  description:
                  "Indique si viajará acompañado y registre las personas que viajarán con usted.",
                ),

                Expanded(

                    child: SingleChildScrollView(

                        child: Column(

                          children: [

                          VisaSectionCard(

                          title: "Información",

                          icon: Icons.people,

                            child: Column(
                              children: [

                                SwitchListTile(
                                  title: const Text(
                                    "¿Viajará con otras personas?",
                                  ),
                                  value: _travelingWithOthers ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _travelingWithOthers = value;

                                      if (!value) {
                                        _companions.clear();
                                      }
                                    });
                                  },
                                ),

                                if (_travelingWithOthers == true) ...[

                                  const SizedBox(height: 20),

                                  if (!widget.viewOnly)
                                    VisaAddButton(
                                      text: "Agregar compañero",
                                      icon: Icons.person_add,
                                      onPressed: _addCompanion,
                                    ),

                                  const SizedBox(height: 20),

                                  if (_companions.isEmpty)

                                    const VisaEmptyState(
                                      title: "Sin compañeros",
                                      message:
                                      "Todavía no ha agregado ningún compañero de viaje.",
                                      icon: Icons.people_outline,
                                    )

                                  else

                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemCount: _companions.length,
                                      itemBuilder: (context, index) {
                                        return CompanionCard(
                                          companion: _companions[index],

                                          onEdit: widget.viewOnly
                                              ? () {}
                                              : () => _editCompanion(index),

                                          onDelete: widget.viewOnly
                                              ? () {}
                                              : () => _deleteCompanion(index),
                                        );
                                      },
                                    ),
                                ],
                              ],
                            ),
                          ),

                            const SizedBox(height: 30),

                            if (!widget.viewOnly)
                              VisaPrimaryButton(
                                text: "Guardar y continuar",
                                icon: Icons.arrow_forward,
                                loading: _saving,
                                onPressed: _saveAndContinue,
                              ),

                            const SizedBox(height: 30),
                          ],
                        ),
                    ),
                ),
                  ],
                ),
            ),
        ),
    );
  }
}