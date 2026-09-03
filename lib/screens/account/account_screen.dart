import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_information_screen.dart';
import '../../services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const Color azulOscuro = Color(0xFF082D6B);
  static const Color azulBoton = Color(0xFF0A3B91);
  static const Color rojo = Color(0xFFE30613);
  static const Color fondo = Color(0xFFF7F7FB);
  static const Color textoGris = Color(0xFF666666);

  bool _loading = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _solicitarEliminacion() async {
    final user = _user;

    if (user == null) {
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Eliminar cuenta",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "¿Estás seguro de que deseas solicitar "
                "la eliminación de tu cuenta?\n\n"
                "Tu solicitud será enviada al equipo de "
                "Visa Assist para su procesamiento.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: rojo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Solicitar eliminación",
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(
        {
          "accountDeletionRequested": true,
          "accountDeletionRequestedAt":
          Timestamp.now(),
          "updatedAt": Timestamp.now(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tu solicitud de eliminación fue enviada.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo enviar la solicitud: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Cerrar sesión",
          ),
          content: const Text(
            "¿Deseas cerrar la sesión?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: azulOscuro,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Salir"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await AuthService().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Mi cuenta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================================================
          // PERFIL
          // ==================================================

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  azulOscuro,
                  azulBoton,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage:
                  user?.photoURL != null
                      ? NetworkImage(
                    user!.photoURL!,
                  )
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(
                    Icons.person,
                    color: azulOscuro,
                    size: 32,
                  )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mi cuenta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "Sin correo",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ==================================================
          // INFORMACIÓN
          // ==================================================

          _buildSectionTitle("Cuenta"),

          const SizedBox(height: 8),

          _buildOption(
            icon: Icons.person_outline,
            color: azulBoton,
            title: "Información de la cuenta",
            subtitle:
            "Consulta la información asociada a tu cuenta.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const AccountInformationScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ==================================================
          // ELIMINACIÓN
          // ==================================================

          _buildSectionTitle("Privacidad y seguridad"),

          const SizedBox(height: 8),

          _buildOption(
            icon: Icons.delete_outline,
            color: rojo,
            title: "Solicitar eliminación de cuenta",
            subtitle:
            "Solicita la eliminación de tu cuenta y "
                "de tus datos.",
            onTap: _loading
                ? null
                : _solicitarEliminacion,
          ),

          const SizedBox(height: 12),

          // ==================================================
          // CERRAR SESIÓN
          // ==================================================

          _buildOption(
            icon: Icons.logout,
            color: Colors.grey.shade700,
            title: "Cerrar sesión",
            subtitle:
            "Salir de tu cuenta en este dispositivo.",
            onTap: _loading
                ? null
                : _cerrarSesion,
          ),

          if (_loading) ...[
            const SizedBox(height: 24),
            const Center(
              child: CircularProgressIndicator(
                color: azulBoton,
              ),
            ),
          ],

          const SizedBox(height: 30),

          // ==================================================
          // AVISO
          // ==================================================

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: azulBoton.withValues(
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
                    "La solicitud de eliminación será "
                        "revisada y procesada por Visa Assist.",
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: azulOscuro,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(
                alpha: 0.20,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
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
                        color: Color(0xFF111111),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: textoGris,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}