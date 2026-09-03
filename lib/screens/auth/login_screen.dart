import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool cargando = false;
  bool recordarCuenta = true;
  bool ocultarPassword = true;

  static const String _emailGuardadoKey = 'visa_assist_email_guardado';

  Future<void> login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      mensaje("Complete todos los campos.");
      return;
    }

    setState(() => cargando = true);

    final error = await AuthService().login(
      email: _email.text.trim(),
      password: _password.text,
    );

    setState(() => cargando = false);

    if (error == null) {
      final prefs = await SharedPreferences.getInstance();

      if (recordarCuenta) {
        await prefs.setString(
          _emailGuardadoKey,
          _email.text.trim(),
        );
      } else {
        await prefs.remove(
          _emailGuardadoKey,
        );
      }

      // ==================================================
      // NO NAVEGAMOS MANUALMENTE
      //
      // AuthWrapper detectará automáticamente
      // el nuevo usuario autenticado.
      // ==================================================

      if (!mounted) return;

      setState(() {
        cargando = false;
      });
    } else {
      mensaje(error);
    }
  }

  void mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  //==================================================
  // RECUPERAR CONTRASEÑA
  //==================================================

  Future<void> recuperarContrasena() async {

    final emailController = TextEditingController(
      text: _email.text.trim(),
    );

    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(

          title: const Text(
            "Recuperar contraseña",
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Escribe el correo electrónico de tu cuenta "
                    "y te enviaremos un enlace para crear una "
                    "nueva contraseña.",
              ),

              const SizedBox(height: 18),

              TextField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  hintText: "ejemplo@correo.com",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "CANCELAR",
              ),
            ),

            ElevatedButton(
              onPressed: () {

                final correo =
                emailController.text.trim();

                if (correo.isEmpty) {

                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Escribe tu correo electrónico.",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(
                  dialogContext,
                  correo,
                );
              },
              child: const Text(
                "ENVIAR",
              ),
            ),
          ],
        );
      },
    );

    if (email == null ||
        email.trim().isEmpty) {

      emailController.dispose();
      return;
    }

    // Esperamos a que el diálogo termine completamente
    // de cerrarse antes de destruir su controlador.
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    emailController.dispose();
    setState(() {
      cargando = true;
    });

    final error =
    await AuthService()
        .sendPasswordResetEmail(
      email.trim(),
    );

    if (!mounted) return;

    setState(() {
      cargando = false;
    });

    if (error == null) {

      mensaje(
        "Te enviamos un correo para restablecer "
            "tu contraseña. Revisa también la carpeta "
            "de spam.",
      );

    } else {

      mensaje(
        "No se pudo enviar el correo: $error",
      );

    }
  }

  Future<void> loginGoogle() async {
    setState(() => cargando = true);

    final error = await AuthService().loginWithGoogle();

    setState(() => cargando = false);

    if (error == null) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });
    } else {
      mensaje(error);
    }
  }

  Future<void> _cargarCuentaGuardada() async {
    final prefs = await SharedPreferences.getInstance();

    final emailGuardado =
    prefs.getString(_emailGuardadoKey);

    if (!mounted) return;

    if (emailGuardado != null &&
        emailGuardado.isNotEmpty) {
      setState(() {
        _email.text = emailGuardado;
        recordarCuenta = true;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputDecoration campo({
    required String texto,
    required IconData icono,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: texto,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: Icon(
        icono,
        color: Colors.grey.shade700,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cargarCuentaGuardada();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final alto = constraints.maxHeight;

            // Ajuste automático para pantallas pequeñas.
            final bool pantallaPequena = alto < 680;

            final double logoHeight =
            pantallaPequena ? 105 : 125;

            final double espacioPrincipal =
            pantallaPequena ? 6 : 10;

            final double espacioCampos =
            pantallaPequena ? 10 : 14;

            final double altoCampo =
            pantallaPequena ? 52 : 56;

            final double altoBoton =
            pantallaPequena ? 52 : 56;

            return Stack(
              children: [

                // =====================================================
                // FONDO
                // =====================================================

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/images/login_background.png",
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // =====================================================
                // CONTENIDO
                // =====================================================

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: pantallaPequena ? 20 : 24,
                  ),

                  child: Column(
                    children: [

                      // =================================================
                      // LOGO
                      // =================================================

                      Image.asset(
                        "assets/images/visa_assist_logo.png",
                        height: logoHeight,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(
                        height: espacioPrincipal,
                      ),

                      // =================================================
                      // BIENVENIDO
                      // =================================================

                      Text(
                        "Bienvenido",
                        style: TextStyle(
                          fontSize:
                          pantallaPequena ? 26 : 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // =================================================
                      // DESCRIPCIÓN
                      // =================================================

                      Text(
                        "Inicia sesión para administrar tus expedientes.",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize:
                          pantallaPequena ? 14 : 16,
                          color: Colors.black54,
                        ),
                      ),

                      SizedBox(
                        height:
                        pantallaPequena ? 12 : 18,
                      ),

                      // =================================================
                      // CORREO
                      // =================================================

                      SizedBox(
                        height: altoCampo,
                        child: TextField(
                          controller: _email,
                          keyboardType:
                          TextInputType.emailAddress,
                          decoration: campo(
                            texto: "Correo electrónico",
                            icono: Icons.mail_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: espacioCampos,
                      ),

                      // =================================================
                      // CONTRASEÑA
                      // =================================================

                      SizedBox(
                        height: altoCampo,
                        child: TextField(
                          controller: _password,
                          obscureText: ocultarPassword,
                          decoration: campo(
                            texto: "Contraseña",
                            icono: Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(
                                ocultarPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  ocultarPassword =
                                  !ocultarPassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      // =================================================
                      // RECORDAR / OLVIDASTE
                      // =================================================

                      SizedBox(
                        height:
                        pantallaPequena ? 40 : 44,
                        child: Row(
                          children: [

                            Expanded(
                              child: Row(
                                children: [

                                  Checkbox(
                                    value: recordarCuenta,
                                    activeColor:
                                    AppColors.primary,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
                                    visualDensity:
                                    VisualDensity.compact,
                                    onChanged: (value) async {
                                      final nuevoValor =
                                          value ?? false;

                                      setState(() {
                                        recordarCuenta =
                                            nuevoValor;
                                      });

                                      if (!nuevoValor) {
                                        final prefs =
                                        await SharedPreferences
                                            .getInstance();

                                        await prefs.remove(
                                          _emailGuardadoKey,
                                        );

                                        _email.clear();
                                      }
                                    },
                                  ),

                                  const Flexible(
                                    child: Text(
                                      "Recordar mi cuenta",
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap,
                              ),
                              onPressed: cargando
                                  ? null
                                  : recuperarContrasena,
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                  fontSize:
                                  pantallaPequena
                                      ? 12
                                      : 13,
                                  color:
                                  AppColors.primary,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =================================================
                      // INICIAR SESIÓN
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: altoBoton,
                        child: ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.primary,
                            foregroundColor:
                            Colors.white,
                            elevation: 5,
                            shadowColor:
                            Colors.black26,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),
                          onPressed:
                          cargando ? null : login,
                          child: cargando
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            "INICIAR SESIÓN",
                            style: TextStyle(
                              fontSize:
                              pantallaPequena
                                  ? 16
                                  : 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // =================================================
                      // O
                      // =================================================

                      SizedBox(
                        height:
                        pantallaPequena ? 14 : 18,
                      ),

                      Row(
                        children: [

                          Expanded(
                            child: Divider(
                              color:
                              Colors.grey.shade400,
                            ),
                          ),

                          const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "O",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Divider(
                              color:
                              Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height:
                        pantallaPequena ? 14 : 18,
                      ),

                      // =================================================
                      // GOOGLE
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: altoBoton,
                        child: OutlinedButton(
                          style:
                          OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primary,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                            ),
                            backgroundColor:
                            Colors.white,
                            padding:
                            EdgeInsets.zero,
                          ),
                          onPressed:
                          cargando ? null : loginGoogle,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [

                              Image.asset(
                                "assets/images/google_logo.png",
                                width:
                                pantallaPequena
                                    ? 20
                                    : 22,
                                height:
                                pantallaPequena
                                    ? 20
                                    : 22,
                              ),

                              const SizedBox(width: 10),

                              Text(
                                "Continuar con Google",
                                style: TextStyle(
                                  color:
                                  Colors.black87,
                                  fontSize:
                                  pantallaPequena
                                      ? 15
                                      : 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // CREAR CUENTA
                      // =================================================

                      SizedBox(
                        height:
                        pantallaPequena ? 12 : 16,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Flexible(
                            child: Text(
                              "¿No tienes una cuenta? ",
                              textAlign:
                              TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                pantallaPequena
                                    ? 13
                                    : 14,
                                color:
                                Colors.black87,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Crear cuenta",
                              style: TextStyle(
                                fontSize:
                                pantallaPequena
                                    ? 13
                                    : 14,
                                color: Colors.red,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
