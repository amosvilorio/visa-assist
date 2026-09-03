import 'package:flutter/material.dart';
import 'select_visa_screen.dart';
import '../../utils/app_colors.dart';
import '../../services/progress_service.dart';
import '../../services/expediente_service.dart';

class SelectCountryScreen extends StatefulWidget {

  final String expedienteId;

  const SelectCountryScreen({
    super.key,
    required this.expedienteId,
  });

  @override
  State<SelectCountryScreen> createState() =>
      _SelectCountryScreenState();
}

class _SelectCountryScreenState
    extends State<SelectCountryScreen> {

  final ProgressService _progressService =
      ProgressService.instance;

  final ExpedienteService _expedienteService =
  ExpedienteService();

  @override
  void initState() {
    super.initState();
    guardarProgreso();
  }

  Future guardarProgreso() async {

    await _progressService.saveStep(
      expedienteId: widget.expedienteId,
      step: 2,
    );

  }

  Future<void> guardarPaisSeleccionado(String countryCode) async {

    await _expedienteService.updateCountryCode(
      expedienteId: widget.expedienteId,
      countryCode: countryCode,
    );

    await _progressService.saveStep(
      expedienteId: widget.expedienteId,
      step: 2,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Seleccionar País"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "PASO 2 DE 18",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "¿Para qué país deseas solicitar la visa?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Selecciona el país de destino.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),

          _countryCard(
            context,
            flag: "🇺🇸",
            country: "Estados Unidos",
            description: "Disponible",
            enabled: true,
          ),

          _countryCard(
            context,
            flag: "🇨🇦",
            country: "Canadá",
            description: "Próximamente",
            enabled: false,
          ),

          _countryCard(
            context,
            flag: "🇪🇸",
            country: "España",
            description: "Próximamente",
            enabled: false,
          ),

          _countryCard(
            context,
            flag: "🇫🇷",
            country: "Francia",
            description: "Próximamente",
            enabled: false,
          ),

          _countryCard(
            context,
            flag: "🇩🇪",
            country: "Alemania",
            description: "Próximamente",
            enabled: false,
          ),

          _countryCard(
            context,
            flag: "🇮🇹",
            country: "Italia",
            description: "Próximamente",
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _countryCard(
      BuildContext context, {
        required String flag,
        required String country,
        required String description,
        required bool enabled,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 34),
        ),
        title: Text(
          country,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(description),
        trailing: enabled
            ? const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.primary,
        )
            : const Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        onTap: () async {
          if (!enabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Este país estará disponible próximamente."),
              ),
            );
            return;
          }

          await guardarPaisSeleccionado("US");

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectVisaScreen(
                expedienteId: widget.expedienteId,
              ),
            ),
          );
        },
      ),
    );
  }
}