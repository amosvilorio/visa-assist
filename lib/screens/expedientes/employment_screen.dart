import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';
import 'travel_history_screen.dart';

class EmploymentScreen extends StatefulWidget {

  final Expediente expediente;

  const EmploymentScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<EmploymentScreen> createState() => _EmploymentScreenState();
}

class _EmploymentScreenState extends State<EmploymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final empresaController = TextEditingController();
  final ocupacionController = TextEditingController();
  final direccionEmpresaController = TextEditingController();
  final telefonoEmpresaController = TextEditingController();
  final ingresoMensualController = TextEditingController();

  String situacionLaboral = "Empleado";

  @override
  void dispose() {
    empresaController.dispose();
    ocupacionController.dispose();
    direccionEmpresaController.dispose();
    telefonoEmpresaController.dispose();
    ingresoMensualController.dispose();
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
        title: const Text("Información Laboral"),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Paso 6 de 8",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Información Laboral",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Completa tu información laboral actual.",
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: situacionLaboral,
              decoration: const InputDecoration(
                labelText: "Situación laboral",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Empleado",
                  child: Text("Empleado"),
                ),
                DropdownMenuItem(
                  value: "Independiente",
                  child: Text("Independiente"),
                ),
                DropdownMenuItem(
                  value: "Empresario",
                  child: Text("Empresario"),
                ),
                DropdownMenuItem(
                  value: "Desempleado",
                  child: Text("Desempleado"),
                ),
                DropdownMenuItem(
                  value: "Estudiante",
                  child: Text("Estudiante"),
                ),
                DropdownMenuItem(
                  value: "Pensionado",
                  child: Text("Pensionado"),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  situacionLaboral = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: empresaController,
              decoration: decoration(
                "Empresa",
                Icons.business,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: ocupacionController,
              decoration: decoration(
                "Ocupación",
                Icons.work,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: direccionEmpresaController,
              decoration: decoration(
                "Dirección de la empresa",
                Icons.location_on,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: telefonoEmpresaController,
              keyboardType: TextInputType.phone,
              decoration: decoration(
                "Teléfono de la empresa",
                Icons.phone,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: ingresoMensualController,
              keyboardType: TextInputType.number,
              decoration: decoration(
                "Ingreso mensual",
                Icons.attach_money,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TravelHistoryScreen(
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