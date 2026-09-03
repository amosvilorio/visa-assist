import 'package:flutter/material.dart';

import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_step_header.dart';

class ReviewSubmitScreen extends StatefulWidget {
  const ReviewSubmitScreen({super.key});

  @override
  State<ReviewSubmitScreen> createState() =>
      _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState
    extends State<ReviewSubmitScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  bool _loading = false;
  bool _sending = false;

  bool _acceptInformation = false;

  Future<void> _submitExpediente() async {

    if (!_acceptInformation) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Debe confirmar que la información es correcta.",
          ),
        ),
      );

      return;
    }

    setState(() {
      _sending = true;
    });

    // Aquí se enviará el expediente
    // cuando conectemos Firestore.

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      _sending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Expediente enviado correctamente.",
        ),
      ),
    );

    // Aquí luego navegaremos
    // a la pantalla de éxito.
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.check_circle,
          color: Colors.green,
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
        title: const Text("Revisión Final"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const VisaStepHeader(
                currentStep: 16,
                totalSteps: 16,
                title: "Revisión del Expediente",
                description:
                "Revise la información antes de enviar su expediente.",
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius:
                          BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.green.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 34,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Su expediente está listo para ser enviado.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      _buildSectionCard(
                        icon: Icons.person,
                        title: "Información Personal",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.badge,
                        title: "Pasaporte",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.flight_takeoff,
                        title: "Información del Viaje",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.group,
                        title: "Compañeros de Viaje",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.location_city,
                        title: "Contacto en EE.UU.",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.family_restroom,
                        title: "Información Familiar",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.work,
                        title: "Trabajo y Educación",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.security,
                        title: "Seguridad y Antecedentes",
                        subtitle: "Completada",
                      ),

                      _buildSectionCard(
                        icon: Icons.description,
                        title: "Información Adicional",
                        subtitle: "Completada",
                      ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius:
                          BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.orange.shade300,
                          ),
                        ),
                        child: Text(
                          "Revise cuidadosamente toda la información proporcionada. "
                              "Si durante la revisión necesitamos información o documentos "
                              "adicionales, nos comunicaremos con usted mediante la aplicación "
                              "o por WhatsApp.",
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      CheckboxListTile(
                        value: _acceptInformation,
                        onChanged: (value) {
                          setState(() {
                            _acceptInformation =
                                value ?? false;
                          });
                        },
                        title: const Text(
                          "Confirmo que toda la información proporcionada es correcta y verdadera.",
                        ),
                        controlAffinity:
                        ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              VisaPrimaryButton(
                text: "Enviar expediente",
                icon: Icons.send,
                loading: _sending,
                onPressed: _submitExpediente,
              ),
            ],
          ),
        ),
      ),
    );
  }
}