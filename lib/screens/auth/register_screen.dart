import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _telefono = TextEditingController();
  final _password = TextEditingController();
  final _confirmar = TextEditingController();

  bool acepta = false;
  bool cargando = false;



  Future<void> registrar() async {
    if (_nombre.text.isEmpty ||
        _email.text.isEmpty ||
        _telefono.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmar.text.isEmpty) {
      mensaje("Complete todos los campos.");
      return;
    }

    if (_password.text != _confirmar.text) {
      mensaje("Las contraseñas no coinciden.");
      return;
    }

    if (!acepta) {
      mensaje("Debe aceptar los términos.");
      return;
    }

    setState(() => cargando = true);

    final error = await AuthService().register(
      nombre: _nombre.text,
      apellido: "",
      email: _email.text,
      telefono: _telefono.text,
      password: _password.text,
    );

    setState(() => cargando = false);

    if (error == null) {
      if (!mounted) return;

      Navigator.pop(context);
    } else {
      mensaje(error);
    }
  }

  void mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _telefono.dispose();
    _password.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Icon(
              Icons.person_add,
              size: 90,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              "Crear Cuenta",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            campo(
              "Nombre completo",
              Icons.person,
              _nombre,
            ),

            const SizedBox(height: 15),

            campo(
              "Correo electrónico",
              Icons.email,
              _email,
            ),

            const SizedBox(height: 15),

            campo(
              "Teléfono",
              Icons.phone,
              _telefono,
            ),

            const SizedBox(height: 15),

            campo(
              "Contraseña",
              Icons.lock,
              _password,
              true,
            ),

            const SizedBox(height: 15),

            campo(
              "Confirmar contraseña",
              Icons.lock_outline,
              _confirmar,
              true,
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: acepta,
                  onChanged: (v) {
                    setState(() {
                      acepta = v ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: "Acepto los ",
                          ),
                          TextSpan(
                            text: "Términos y Condiciones",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TermsScreen(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(
                            text: " y la ",
                          ),
                          TextSpan(
                            text: "Política de Privacidad",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(
                            text: ".",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: cargando ? null : registrar,
                child: cargando
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "CREAR CUENTA",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("Ya tengo una cuenta"),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(
      String texto,
      IconData icon,
      TextEditingController controller, [
        bool password = false,
      ]) {
    return TextField(
      controller: controller,
      obscureText: password,
      decoration: InputDecoration(
        labelText: texto,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}