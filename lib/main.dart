import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/admin/super admin/home_admin_screen.dart';
import 'screens/agent/home_agent_screen.dart';
import 'screens/portal/portal_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'utils/app_theme.dart';

/// ======================================================
/// HANDLER DE NOTIFICACIONES EN SEGUNDO PLANO
/// ======================================================
///
/// Firebase ejecuta esta función en un isolate separado
/// cuando llega un mensaje mientras la aplicación está
/// en segundo plano o cerrada.
///
/// IMPORTANTE:
/// La notificación visual en segundo plano la maneja
/// Android/FCM cuando el mensaje contiene "notification".
///
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint(
      '============================================',
    );

    debugPrint(
      'NOTIFICACIÓN RECIBIDA EN SEGUNDO PLANO',
    );

    debugPrint(
      'Título: ${message.notification?.title}',
    );

    debugPrint(
      'Mensaje: ${message.notification?.body}',
    );

    debugPrint(
      'Data: ${message.data}',
    );

    debugPrint(
      '============================================',
    );
  } catch (e) {
    debugPrint(
      'ERROR EN HANDLER DE SEGUNDO PLANO: $e',
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // =====================================================
  // REGISTRAR HANDLER FCM DE SEGUNDO PLANO
  // =====================================================

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(const VisaAssistApp());
}

class VisaAssistApp extends StatelessWidget {
  const VisaAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visa Assist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const FirebaseBootstrap(),
    );
  }
}

/// ======================================================
/// INICIALIZACIÓN DE FIREBASE
/// ======================================================

class FirebaseBootstrap extends StatefulWidget {
  const FirebaseBootstrap({super.key});

  @override
  State<FirebaseBootstrap> createState() =>
      _FirebaseBootstrapState();
}

class _FirebaseBootstrapState
    extends State<FirebaseBootstrap> {
  late final Future<FirebaseApp> _firebaseFuture;

  @override
  void initState() {
    super.initState();

    _firebaseFuture = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _firebaseFuture,
      builder: (context, snapshot) {
        // =================================================
        // FIREBASE INICIALIZÁNDOSE
        // =================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const WelcomeScreen();
        }

        // =================================================
        // ERROR DE FIREBASE
        // =================================================

        if (snapshot.hasError) {
          debugPrint(
            'Firebase no pudo inicializarse: '
                '${snapshot.error}',
          );

          return const WelcomeScreen();
        }

        // =================================================
        // FIREBASE LISTO
        // =================================================

        return const AuthWrapper();
      },
    );
  }
}

/// ======================================================
/// CONTROL DE SESIÓN, ROL Y NOTIFICACIONES
/// ======================================================

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() =>
      _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // =====================================================
  // UID DEL USUARIO PARA EL QUE YA INICIALIZAMOS FCM
  // =====================================================
  //
  // ANTES teníamos solamente:
  //
  // bool _notificationsInitialized = false;
  //
  // Eso provocaba el problema:
  //
  // ADMIN
  //   ↓
  // FCM inicializado
  //   ↓
  // logout
  //   ↓
  // CLIENTE
  //   ↓
  // FCM NO se volvía a inicializar
  //
  // Ahora guardamos el UID.
  //
  String? _notificationsUserId;

  // =====================================================
  // INICIALIZAR NOTIFICACIONES PARA EL USUARIO ACTUAL
  // =====================================================

  void _initializeNotificationsForUser(
      User user,
      ) {
    // ---------------------------------------------------
    // Si ya inicializamos FCM para ESTE usuario,
    // no lo volvemos a hacer.
    // ---------------------------------------------------

    if (_notificationsUserId == user.uid) {
      return;
    }

    // ---------------------------------------------------
    // Guardamos el UID actual.
    // ---------------------------------------------------

    _notificationsUserId = user.uid;

    debugPrint(
      '============================================',
    );

    debugPrint(
      'INICIALIZANDO NOTIFICACIONES',
    );

    debugPrint(
      'UID: ${user.uid}',
    );

    debugPrint(
      'EMAIL: ${user.email}',
    );

    debugPrint(
      '============================================',
    );

    // ---------------------------------------------------
    // IMPORTANTE:
    // NotificationService.initialize()
    // obtiene el token FCM del usuario actual y lo guarda
    // en:
    //
    // users/{uid}/fcmToken
    //
    // Esto funciona tanto para:
    //
    // - Email / contraseña
    // - Google Sign-In
    // ---------------------------------------------------

    NotificationService()
        .initialize()
        .then((_) {
      debugPrint(
        'NOTIFICACIONES INICIALIZADAS PARA: '
            '${user.uid}',
      );
    }).catchError((error) {
      debugPrint(
        'ERROR INICIALIZANDO NOTIFICACIONES PARA '
            '${user.uid}: $error',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges(),
      builder: (context, authSnapshot) {
        // =================================================
        // AUTH COMPROBANDO SESIÓN
        // =================================================

        if (authSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const WelcomeScreen();
        }

        // =================================================
        // NO HAY USUARIO
        // =================================================

        if (!authSnapshot.hasData) {
          debugPrint(
            'NO HAY USUARIO AUTENTICADO',
          );

          // ------------------------------------------------
          // MUY IMPORTANTE:
          //
          // Al cerrar sesión dejamos preparado el wrapper
          // para que el siguiente usuario vuelva a registrar
          // su propio token.
          // ------------------------------------------------

          _notificationsUserId = null;

          return const WelcomeScreen();
        }

        // =================================================
        // USUARIO AUTENTICADO
        // =================================================

        final user = authSnapshot.data!;

        debugPrint(
          'USUARIO AUTENTICADO: ${user.email}',
        );

        debugPrint(
          'UID ACTUAL: ${user.uid}',
        );

        // =================================================
        // INICIALIZAR FCM PARA ESTE USUARIO
        // =================================================

        _initializeNotificationsForUser(user);

        // =================================================
        // OBTENER ROL
        // =================================================

        return FutureBuilder<String?>(
          future: AuthService().getCurrentRole(),
          builder: (context, roleSnapshot) {
            // =============================================
            // OBTENIENDO ROL
            // =============================================

            if (roleSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const WelcomeScreen();
            }

            // =============================================
            // ERROR OBTENIENDO ROL
            // =============================================

            if (roleSnapshot.hasError) {
              debugPrint(
                'ERROR OBTENIENDO ROL: '
                    '${roleSnapshot.error}',
              );

              return const PortalScreen();
            }

            final role = roleSnapshot.data;

            debugPrint(
              'ROL ACTUAL: $role',
            );

            // =============================================
            // REDIRECCIÓN SEGÚN ROL
            // =============================================

            switch (role) {
              case 'admin':
                return const HomeAdminScreen();

              case 'agent':
                return const HomeAgentScreen();

              case 'client':
              default:
                return const PortalScreen();
            }
          },
        );
      },
    );
  }
}