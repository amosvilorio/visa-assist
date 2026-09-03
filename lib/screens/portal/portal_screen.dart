import 'package:flutter/material.dart';
import '../account/account_screen.dart';
import '../support/support_chat_screen.dart';
import 'official_information_screen.dart';
import '../evaluation/evaluation_screen.dart';
import '../expedientes/my_expedientes_screen.dart';
import '../../services/notification_service.dart';
import '../notifications/notifications_screen.dart';

class PortalScreen extends StatefulWidget {
  const PortalScreen({super.key});

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  // ============================================================
  // COLORES VISA ASSIST
  // ============================================================

  static const Color azulOscuro = Color(0xFF082D6B);
  static const Color azulBoton = Color(0xFF0A3B91);
  static const Color azulClaro = Color(0xFF2196F3);
  static const Color rojo = Color(0xFFE30613);

  static const Color fondo = Color(0xFFF7F7FB);
  static const Color textoOscuro = Color(0xFF111111);
  static const Color textoGris = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: azulOscuro,
        elevation: 0,
        centerTitle: true,

        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "VISA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            Text(
              "ASSIST",
              style: TextStyle(
                color: rojo,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ],
        ),

        actions: [

          // ==================================================
          // NOTIFICACIONES
          // ==================================================

          StreamBuilder<int>(
            stream: NotificationService()
                .watchUnreadCount(),

            builder: (context, snapshot) {

              final count =
                  snapshot.data ?? 0;

              return Stack(
                alignment: Alignment.center,
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: "Notificaciones",

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const NotificationsScreen(),
                        ),
                      );

                    },
                  ),

                  if (count > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding:
                        const EdgeInsets.all(4),

                        constraints:
                        const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),

                        decoration:
                        const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          count > 99
                              ? "99+"
                              : count.toString(),

                          textAlign:
                          TextAlign.center,

                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ==================================================
          // MI CUENTA
          // ==================================================

          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
            tooltip: "Mi cuenta",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const AccountScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ========================================================
      // CONTENIDO
      // ========================================================

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            24,
          ),
          children: [
            // ==================================================
            // ENCABEZADO
            // ==================================================

            _buildWelcomeHeader(),

            const SizedBox(height: 12),

            // ==================================================
            // TARJETAS 2 X 2
            // ==================================================

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.92,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              children: [
                // ==============================================
                // EVALUACIÓN DE PERFIL
                // ==============================================

                _card(
                  color: rojo,
                  icon: Icons.fact_check_outlined,
                  titulo: "Evaluación de Perfil",
                  descripcion:
                  "Conoce las fortalezas y riesgos "
                      "de tu perfil migratorio.",
                  textoBoton: "Evaluar",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const EvaluationScreen(),
                      ),
                    );
                  },
                ),

                // ==============================================
                // MIS SOLICITUDES
                // ==============================================

                _card(
                  color: azulBoton,
                  icon: Icons.description_outlined,
                  titulo: "Iniciar solicitud de visa",
                  descripcion:
                  "Comienza tu solicitud de visa "
                      "y completa tu expediente paso a paso.",
                  textoBoton: "Iniciar",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const MyExpedientesScreen(),
                      ),
                    );
                  },
                ),

                // ==============================================
                // FUENTES OFICIALES
                // ==============================================

                _card(
                  color: azulClaro,
                  icon: Icons.public,
                  titulo: "Fuentes Oficiales",
                  descripcion:
                  "Consulta información oficial "
                      "sobre visas y DS-160.",
                  textoBoton: "Ver Información",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const OfficialInformationScreen(),
                      ),
                    );
                  },
                ),

                // ==============================================
                // SOPORTE Y CONTACTO
                // ==============================================

                _card(
                  color: const Color(0xFF6A1B9A),
                  icon: Icons.support_agent_outlined,
                  titulo: "Soporte y Contacto",
                  descripcion:
                  "Habla con nuestro equipo "
                      "cuando necesites ayuda.",
                  textoBoton: "Contactar",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SupportChatScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ==================================================
            // SEGURIDAD
            // ==================================================

            _buildSecurityCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ENCABEZADO DE BIENVENIDA
  // ============================================================

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            azulOscuro,
            azulBoton,
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          // ==================================================
          // ICONO
          // ==================================================

          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.25,
                ),
              ),
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          // ==================================================
          // TEXTO
          // ==================================================

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Estamos aquí para ayudarte "
                      "en cada paso de tu proceso.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA COMPACTA
  // ============================================================

  Widget _card({
    required Color color,
    required IconData icon,
    required String titulo,
    required String descripcion,
    required String textoBoton,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(
            alpha: 0.55,
          ),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          11,
          10,
          10,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            // ==================================================
            // ICONO
            // ==================================================

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
                size: 25,
              ),
            ),

            const SizedBox(height: 7),

            // ==================================================
            // TITULO
            // ==================================================

            Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textoOscuro,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 5),

            // ==================================================
            // LINEA
            // ==================================================

            Container(
              width: 28,
              height: 2.5,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 6),

            // ==================================================
            // DESCRIPCIÓN
            // ==================================================

            Expanded(
              child: Center(
                child: Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textoGris,
                    fontSize: 11.5,
                    height: 1.25,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 7),

            // ==================================================
            // BOTÓN
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor:
                  Colors.white,
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(11),
                  ),
                ),
                onPressed: onTap,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        textoBoton,
                        textAlign:
                        TextAlign.center,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TARJETA DE SEGURIDAD
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: azulClaro.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Row(
        children: [
          // ==================================================
          // ICONO
          // ==================================================

          Container(
            width: 42,
            height: 42,
            decoration:
            const BoxDecoration(
              color: azulBoton,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          // ==================================================
          // TEXTO
          // ==================================================

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Tu información está segura",
                  style: TextStyle(
                    color: azulOscuro,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Protegemos tus datos personales "
                      "durante todo tu proceso.",
                  style: TextStyle(
                    color: textoGris,
                    fontSize: 11.5,
                    height: 1.25,
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