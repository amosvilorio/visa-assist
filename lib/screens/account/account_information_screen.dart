import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({
    super.key,
  });

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState
    extends State<AccountInformationScreen> {
  static const Color azulOscuro = Color(0xFF082D6B);
  static const Color azulBoton = Color(0xFF0A3B91);
  static const Color azulClaro = Color(0xFF2196F3);
  static const Color fondo = Color(0xFFF7F7FB);
  static const Color textoGris = Color(0xFF666666);

  AppUser? _appUser;
  User? _firebaseUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarCuenta();
  }

  Future<void> _cargarCuenta() async {
    try {
      final firebaseUser =
          FirebaseAuth.instance.currentUser;

      final appUser =
      await AuthService().getCurrentAppUser();

      if (!mounted) {
        return;
      }

      setState(() {
        _firebaseUser = firebaseUser;
        _appUser = appUser;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo cargar la información: $e",
          ),
        ),
      );
    }
  }

  String _fechaRegistro(Timestamp? timestamp) {
    if (timestamp == null) {
      return "No disponible";
    }

    final fecha = timestamp.toDate();

    final dia = fecha.day
        .toString()
        .padLeft(2, "0");

    final mes = fecha.month
        .toString()
        .padLeft(2, "0");

    final anio = fecha.year.toString();

    return "$dia/$mes/$anio";
  }

  String _metodoAcceso() {
    final user = _firebaseUser;

    if (user == null ||
        user.providerData.isEmpty) {
      return "No disponible";
    }

    final providers = user.providerData
        .map((provider) => provider.providerId)
        .toList();

    if (providers.contains("google.com")) {
      return "Google";
    }

    if (providers.contains("password")) {
      return "Correo y contraseña";
    }

    return "Otro método";
  }

  String _estadoCuenta() {
    final status = _appUser?.status ?? "";

    switch (status) {
      case "active":
        return "Activa";

      case "inactive":
        return "Inactiva";

      case "suspended":
        return "Suspendida";

      default:
        return status.isEmpty
            ? "No disponible"
            : status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Información de la cuenta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(
          color: azulBoton,
        ),
      )
          : RefreshIndicator(
        color: azulBoton,
        onRefresh: _cargarCuenta,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ============================================
            // INFORMACIÓN PERSONAL
            // ============================================

            _sectionTitle(
              "Información personal",
            ),

            const SizedBox(height: 8),

            _infoCard(
              icon: Icons.person_outline,
              title: "Nombre",
              value: _appUser == null
                  ? "No disponible"
                  : "${_appUser!.name} "
                  "${_appUser!.lastName}"
                  .trim(),
              color: azulBoton,
            ),

            _infoCard(
              icon: Icons.email_outlined,
              title: "Correo electrónico",
              value: _appUser?.email.isNotEmpty == true
                  ? _appUser!.email
                  : _firebaseUser?.email ??
                  "No disponible",
              color: azulClaro,
            ),

            _infoCard(
              icon: Icons.phone_outlined,
              title: "Teléfono",
              value: _appUser?.phone.isNotEmpty == true
                  ? _appUser!.phone
                  : "No registrado",
              color: Colors.green,
            ),

            _infoCard(
              icon: Icons.public,
              title: "País",
              value: _appUser?.country.isNotEmpty == true
                  ? _appUser!.country
                  : "No registrado",
              color: Colors.orange,
            ),

            _infoCard(
              icon: Icons.language,
              title: "Idioma",
              value: _appUser?.language == "es"
                  ? "Español"
                  : (_appUser?.language.isNotEmpty == true
                  ? _appUser!.language
                  : "No disponible"),
              color: Colors.purple,
            ),

            const SizedBox(height: 18),

            // ============================================
            // ACCESO Y SEGURIDAD
            // ============================================

            _sectionTitle(
              "Acceso y seguridad",
            ),

            const SizedBox(height: 8),

            _infoCard(
              icon: Icons.login,
              title: "Método de inicio de sesión",
              value: _metodoAcceso(),
              color: azulBoton,
            ),

            _infoCard(
              icon: Icons.verified_user_outlined,
              title: "Correo electrónico",
              value: _firebaseUser?.emailVerified == true
                  ? "Verificado"
                  : "Pendiente de verificación",
              color: _firebaseUser?.emailVerified == true
                  ? Colors.green
                  : Colors.orange,
            ),

            const SizedBox(height: 18),

            // ============================================
            // INFORMACIÓN DE LA CUENTA
            // ============================================

            _sectionTitle(
              "Estado de la cuenta",
            ),

            const SizedBox(height: 8),

            _buildStatusCard(),

            const SizedBox(height: 12),

            _infoCard(
              icon: Icons.calendar_today_outlined,
              title: "Cuenta creada",
              value: _fechaRegistro(
                _appUser?.createdAt,
              ),
              color: azulClaro,
            ),

            const SizedBox(height: 25),

            // ============================================
            // AVISO
            // ============================================

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius:
                BorderRadius.circular(16),
                border: Border.all(
                  color: azulClaro.withValues(
                    alpha: 0.20,
                  ),
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: azulBoton,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Esta información corresponde a "
                          "los datos asociados a tu cuenta "
                          "de Visa Assist.",
                      style: TextStyle(
                        color: textoGris,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: azulOscuro,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(
            alpha: 0.18,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textoGris,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _appUser?.status ?? "";

    final bool activa = status == "active";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: activa
            ? const Color(0xFFEAF8EF)
            : const Color(0xFFFFEEEE),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: activa
              ? Colors.green.withValues(
            alpha: 0.30,
          )
              : Colors.red.withValues(
            alpha: 0.30,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: activa
                  ? Colors.green.withValues(
                alpha: 0.12,
              )
                  : Colors.red.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activa
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_outlined,
              color: activa
                  ? Colors.green
                  : Colors.red,
              size: 26,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Estado de tu cuenta",
                  style: TextStyle(
                    color: textoGris,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _estadoCuenta(),
                  style: TextStyle(
                    color: activa
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}