import 'package:flutter/material.dart';

import '../../../../services/agent_service.dart';

class CreateAgentScreen extends StatefulWidget {
  const CreateAgentScreen({super.key});

  @override
  State<CreateAgentScreen> createState() =>
      _CreateAgentScreenState();
}

class _CreateAgentScreenState
    extends State<CreateAgentScreen> {

  final _nombre = TextEditingController();

  final _apellido = TextEditingController();

  final _correo = TextEditingController();

  final _telefono = TextEditingController();

  final _password = TextEditingController();

  final _confirmar = TextEditingController();

  final _especialidad = TextEditingController();

  final _idiomas = TextEditingController();

  final _observaciones =
  TextEditingController();

  bool activo = true;

  bool loading = false;

  final AgentService _service =
  AgentService();

  @override
  void dispose() {
    _nombre.dispose();

    _apellido.dispose();

    _correo.dispose();

    _telefono.dispose();

    _password.dispose();

    _confirmar.dispose();

    _especialidad.dispose();

    _idiomas.dispose();

    _observaciones.dispose();

    super.dispose();
  }

  Future<void> crearAgente() async {

    if (_nombre.text.trim().isEmpty ||
        _apellido.text.trim().isEmpty ||
        _correo.text.trim().isEmpty ||
        _telefono.text.trim().isEmpty ||
        _password.text.isEmpty ||
        _confirmar.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Complete todos los campos obligatorios.",
          ),
        ),
      );

      return;
    }

    if (_password.text != _confirmar.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Las contraseñas no coinciden.",
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      // Próximamente aquí crearemos el usuario
      // en Firebase Authentication y luego
      // su documento en Firestore.

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Agente creado correctamente.",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {

          loading = false;

        });

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: const Text(
            "Nuevo Agente",
          ),
          centerTitle: true,
        ),

        body: SafeArea(

            child: SingleChildScrollView(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [

                _campo(
                controller: _nombre,
                label: "Nombre",
                icon: Icons.person,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _apellido,
                label: "Apellido",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _correo,
                label: "Correo",
                icon: Icons.email,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _telefono,
                label: "Teléfono",
                icon: Icons.phone,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _password,
                label: "Contraseña temporal",
                icon: Icons.lock,
                obscure: true,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _confirmar,
                label: "Confirmar contraseña",
                icon: Icons.lock_outline,
                obscure: true,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _especialidad,
                label: "Especialidad",
                icon: Icons.workspace_premium,
              ),

              const SizedBox(height: 15),

              _campo(
                controller: _idiomas,
                label: "Idiomas",
                icon: Icons.language,
              ),

                  const SizedBox(height: 15),

                  _campo(
                    controller: _observaciones,
                    label: "Observaciones",
                    icon: Icons.notes,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    value: activo,
                    title: const Text(
                      "Agente activo",
                    ),
                    subtitle: const Text(
                      "Podrá iniciar sesión inmediatamente.",
                    ),
                    onChanged: (value) {
                      setState(() {
                        activo = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                      loading ? null : crearAgente,
                      icon: loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.person_add,
                      ),
                      label: Text(
                        loading
                            ? "Creando..."
                            : "Crear Agente",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
        ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(15),
        ),
      ),
    );
  }
}