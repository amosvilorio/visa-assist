import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../services/expediente_service.dart';
import '../visa/select_country_screen.dart';

class PassportVerificationScreen extends StatefulWidget {
  const PassportVerificationScreen({super.key});

  @override
  State<PassportVerificationScreen> createState() =>
      _PassportVerificationScreenState();
}

class _PassportVerificationScreenState
    extends State<PassportVerificationScreen> {


  final ExpedienteService _expedienteService = ExpedienteService();

  bool passportConfirmed = false;

  bool _continuando = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> continuar() async {

    try {

      final expedienteId =
      await _expedienteService.createExpediente(
        countryCode: "",
        visaType: "",
      );

      //========================================================
      // GUARDAR PASO 2 DIRECTAMENTE EN EXPEDIENTES
      //========================================================

      await _expedienteService.updateCurrentStep(
        expedienteId: expedienteId,
        step: 2,
      );

      if (!mounted) return;

      //========================================================
      // CONTINUAR A SELECCIÓN DE PAÍS
      //========================================================

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SelectCountryScreen(
                expedienteId: expedienteId,
              ),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No se pudo continuar: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Antes de comenzar"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                30,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------------------------------------------
                    // ENCABEZADO
                    // ------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PASO 1 DE 18",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "Verificación de Pasaporte",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ------------------------------------------------
                    // ICONO
                    // ------------------------------------------------
                    Center(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor:
                        AppColors.primary.withOpacity(0.10),
                        child: const Icon(
                          Icons.book,
                          color: AppColors.primary,
                          size: 55,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // DESCRIPCIÓN
                    // ------------------------------------------------
                    const Text(
                      "Antes de iniciar tu expediente necesitamos confirmar que cuentas con un pasaporte vigente.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // CONFIRMACIÓN
                    // ------------------------------------------------
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: CheckboxListTile(
                        value: passportConfirmed,
                        controlAffinity:
                        ListTileControlAffinity.leading,
                        activeColor: AppColors.success,

                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),

                        title: const Text(
                          "Confirmo que tengo un pasaporte vigente y que estará disponible durante todo el proceso de solicitud de visa.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),

                        onChanged: (value) {
                          setState(() {
                            passportConfirmed =
                                value ?? false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ------------------------------------------------
                    // INFORMACIÓN
                    // ------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              "El pasaporte es un requisito indispensable para iniciar una solicitud de visa. Si aún no cuentas con uno vigente, te recomendamos obtenerlo o renovarlo antes de continuar.",
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // BOTÓN CONTINUAR
                    // ------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          Colors.grey.shade400,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),

                        onPressed: passportConfirmed && !_continuando
                            ? continuar
                            : null,

                        child: _continuando
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "CONTINUAR",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Espacio adicional para garantizar
                    // separación de la navegación Android.
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}