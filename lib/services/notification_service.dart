import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/expediente.dart';
import '../services/expediente_service.dart';
import '../screens/expedientes/visa_assist_process_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import '../screens/support/support_chat_screen.dart';
import '../screens/support/admin_support_chat_detail_screen.dart';
import '../screens/evaluation/evaluation_question_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/admin/evaluations/evaluations_screen.dart';
import '../screens/admin/payments/payments_screen.dart';
import '../screens/evaluation/evaluation_detail_screen.dart';

class NotificationService {

  // =====================================================
  // NAVEGACIÓN DESDE NOTIFICACIONES
  // =====================================================

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin
  _localNotifications =
  FlutterLocalNotificationsPlugin();

  // =====================================================
  // CANAL NUEVO
  //
  // Usamos un ID nuevo para evitar que Android conserve
  // una configuración anterior del canal.
  // =====================================================

  static const String _channelId =
      'visa_assist_notifications_v2';

  static const String _channelName =
      'Visa Assist';

  static const String _channelDescription =
      'Notificaciones de Visa Assist';

  // =====================================================
  // EVITAR LISTENERS DUPLICADOS
  // =====================================================

  bool _initialized = false;

  bool _tokenListenerInitialized = false;

  // =====================================================
  // INICIALIZAR NOTIFICACIONES
  // =====================================================

  Future<void> initialize() async {
    try {
      // =================================================
      // VERIFICAR USUARIO
      // =================================================

      final user = _auth.currentUser;

      if (user == null) {
        debugPrint(
          "NOTIFICACIONES: NO HAY USUARIO AUTENTICADO.",
        );
        return;
      }

      debugPrint(
        "NOTIFICACIONES: INICIALIZANDO PARA UID "
            "${user.uid}",
      );

      // =================================================
      // SOLICITAR PERMISOS FCM
      // =================================================

      final settings =
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        "PERMISO NOTIFICACIONES: "
            "${settings.authorizationStatus}",
      );

      // =================================================
// CONFIGURAR PRESENTACIÓN DE NOTIFICACIONES EN iOS
// =================================================

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint(
        "PRESENTACIÓN DE NOTIFICACIONES iOS CONFIGURADA.",
      );

      // =================================================
      // CONFIGURAR NOTIFICACIONES LOCALES
      // =================================================

      const androidSettings =
      AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const darwinSettings =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initializationSettings =
      InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      if (!_initialized) {
        await _localNotifications.initialize(
          settings: initializationSettings,
          onDidReceiveNotificationResponse:
          _onNotificationTapped,
        );
      }

      // =================================================
      // CREAR CANAL ANDROID
      // =================================================

      const androidChannel =
      AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      final androidPlugin =
      _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(
        androidChannel,
      );

      // =================================================
      // PERMISO ANDROID 13+
      // =================================================

      await androidPlugin?.requestNotificationsPermission();

      // =================================================
      // OBTENER TOKEN FCM
      // =================================================

      // =================================================
// OBTENER TOKEN APNs EN iOS
// =================================================

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();

        debugPrint(
          "========================================",
        );

        debugPrint(
          "APNs TOKEN: $apnsToken",
        );

        debugPrint(
          "========================================",
        );
      }

// =================================================
// OBTENER TOKEN FCM
// =================================================

      final token =
      await _messaging.getToken();

      if (token != null) {
        debugPrint(
          "========================================",
        );

        debugPrint(
          "FCM TOKEN OBTENIDO",
        );

        debugPrint(
          "UID: ${user.uid}",
        );

        debugPrint(
          "TOKEN: $token",
        );

        debugPrint(
          "========================================",
        );

        await _saveTokenForUser(
          userId: user.uid,
          token: token,
        );
      } else {
        debugPrint(
          "NO SE PUDO OBTENER EL TOKEN FCM.",
        );
      }

      // =================================================
      // LISTENER DE CAMBIO DE TOKEN
      //
      // SOLO SE REGISTRA UNA VEZ.
      // =================================================

      if (!_tokenListenerInitialized) {
        _tokenListenerInitialized = true;

        _messaging.onTokenRefresh.listen(
              (newToken) async {
            final currentUser =
                _auth.currentUser;

            if (currentUser == null) {
              debugPrint(
                "TOKEN ACTUALIZADO PERO NO HAY "
                    "USUARIO AUTENTICADO.",
              );
              return;
            }

            debugPrint(
              "FCM TOKEN ACTUALIZADO PARA "
                  "${currentUser.uid}",
            );

            await _saveTokenForUser(
              userId: currentUser.uid,
              token: newToken,
            );
          },
        );
      }

      // =================================================
      // LISTENERS DE MENSAJES
      //
      // SOLO SE REGISTRAN UNA VEZ.
      // =================================================

      if (!_initialized) {
        // =================================================
        // APP ABIERTA / PRIMER PLANO
        // =================================================

        FirebaseMessaging.onMessage.listen(
              (RemoteMessage message) async {
            debugPrint(
              "========================================",
            );

            debugPrint(
              "NOTIFICACIÓN FCM RECIBIDA EN PRIMER PLANO",
            );

            debugPrint(
              "Título: "
                  "${message.notification?.title}",
            );

            debugPrint(
              "Mensaje: "
                  "${message.notification?.body}",
            );

            debugPrint(
              "Data: ${message.data}",
            );

            debugPrint(
              "========================================",
            );

            final title =
                message.notification?.title ??
                    message.data["title"] ??
                    "Visa Assist";

            final body =
                message.notification?.body ??
                    message.data["body"] ??
                    "Tienes una nueva notificación.";

            await _showLocalNotification(
              title: title,
              body: body,
              payload: jsonEncode(message.data),
            );
          },
        );

        // =================================================
        // USUARIO TOCA NOTIFICACIÓN DESDE SEGUNDO PLANO
        // =================================================

        FirebaseMessaging.onMessageOpenedApp.listen(
              (RemoteMessage message) {
            debugPrint(
              "========================================",
            );

            debugPrint(
              "NOTIFICACIÓN ABIERTA DESDE SEGUNDO PLANO",
            );

            debugPrint(
              "Data: ${message.data}",
            );

            debugPrint(
              "========================================",
            );

            _handleNotificationData(
              Map<String, dynamic>.from(message.data),
            );
          },
        );

        // =================================================
        // APP ABIERTA DESDE NOTIFICACIÓN
        // =================================================

        final initialMessage =
        await _messaging.getInitialMessage();

        if (initialMessage != null) {
          debugPrint(
            "========================================",
          );

          debugPrint(
            "APP ABIERTA DESDE NOTIFICACIÓN",
          );

          debugPrint(
            "Data: ${initialMessage.data}",
          );

          debugPrint(
            "========================================",
          );

          _handleNotificationData(
            Map<String, dynamic>.from(
              initialMessage.data,
            ),
          );
        }

        _initialized = true;
      }

      debugPrint(
        "NOTIFICACIONES INICIALIZADAS PARA "
            "${user.uid}",
      );
    } catch (e, stackTrace) {
      debugPrint(
        "ERROR INICIALIZANDO NOTIFICACIONES: $e",
      );

      debugPrint(
        "STACK TRACE: $stackTrace",
      );
    }
  }

  // =====================================================
  // MOSTRAR NOTIFICACIÓN LOCAL
  //
  // Se utiliza solamente cuando la aplicación está
  // abierta y recibimos onMessage.
  // =====================================================

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails =
      AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails =
      NotificationDetails(
        android: androidDetails,
      );

      await _localNotifications.show(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(2147483647),
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );

      debugPrint(
        "NOTIFICACIÓN LOCAL MOSTRADA.",
      );
    } catch (e) {
      debugPrint(
        "ERROR MOSTRANDO NOTIFICACIÓN LOCAL: $e",
      );
    }
  }

  // =====================================================
  // PROCESAR NAVEGACIÓN DE UNA NOTIFICACIÓN
  // =====================================================

  Future<void> _handleNotificationData(
      Map<String, dynamic> data,
      ) async {
    try {
      debugPrint(
        "========================================",
      );

      debugPrint(
        "PROCESANDO NAVEGACIÓN DE NOTIFICACIÓN",
      );

      debugPrint(
        "DATA: $data",
      );

      final type =
          data["type"]?.toString() ?? "";

      final expedienteId =
          data["expedienteId"]?.toString() ?? "";

      final notificationId =
      data["notificationId"]?.toString();

      debugPrint(
        "TYPE: $type",
      );

      debugPrint(
        "EXPEDIENTE ID: $expedienteId",
      );

      debugPrint(
        "NOTIFICATION ID: $notificationId",
      );

      // =================================================
      // MARCAR COMO LEÍDA
      // =================================================

      if (notificationId != null &&
          notificationId.isNotEmpty) {
        await markAsRead(
          notificationId: notificationId,
        );
      }

      // =================================================
// PAGO RECIBIDO PARA ADMIN
// =================================================

      if (type == "evaluation_payment_received" ||
          type == "service_payment_received") {
        final paymentId =
            data["paymentId"]?.toString() ?? "";

        if (paymentId.isEmpty) {
          debugPrint(
            "NOTIFICACIÓN DE PAGO SIN paymentId.",
          );
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
            const PaymentsScreen(),
          ),
        );

        debugPrint(
          "ABRIENDO PAGOS PENDIENTES DEL ADMIN.",
        );

        debugPrint(
          "PAYMENT ID: $paymentId",
        );

        return;
      }

      // =================================================
// NUEVA EVALUACIÓN PREMIUM PARA ADMIN
// =================================================

      if (type == "premium_evaluation_submitted") {
        final evaluationId =
            data["evaluationId"]?.toString() ??
                expedienteId;

        if (evaluationId.isEmpty) {
          debugPrint(
            "NOTIFICACIÓN PREMIUM SIN evaluationId.",
          );
          return;
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
            const EvaluationsScreen(),
          ),
        );

        debugPrint(
          "ABRIENDO EVALUACIONES DEL ADMIN "
              "DESDE NOTIFICACIÓN PREMIUM.",
        );

        debugPrint(
          "EVALUATION ID: $evaluationId",
        );

        return;
      }

      // =================================================
// EVALUACIÓN PREMIUM COMPLETADA
// =================================================

      if (type == "premium_evaluation_completed") {
        final evaluationId =
            data["evaluationId"]?.toString() ??
                expedienteId;

        if (evaluationId.isEmpty) {
          debugPrint(
            "NOTIFICACIÓN DE EVALUACIÓN COMPLETADA "
                "SIN evaluationId.",
          );
          return;
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                EvaluationDetailScreen(
                  evaluationId: evaluationId,
                ),
          ),
        );

        debugPrint(
          "ABRIENDO RESULTADO DE EVALUACIÓN PREMIUM.",
        );

        debugPrint(
          "EVALUATION ID: $evaluationId",
        );

        return;
      }

      // =================================================
      // NOTIFICACIÓN DEL CHAT DE SOPORTE
      // =================================================

      if (type == "support_message_received") {
        final clientId =
            data["clientId"]?.toString() ?? "";

        final senderRole =
            data["senderRole"]?.toString() ?? "";

        if (clientId.isEmpty) {
          debugPrint(
            "NOTIFICACIÓN DE SOPORTE SIN clientId.",
          );
          return;
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        // =================================================
        // CLIENTE RECIBE RESPUESTA DEL ADMIN
        // =================================================

        if (senderRole == "admin") {
          navigator.push(
            MaterialPageRoute(
              builder: (_) =>
              const SupportChatScreen(),
            ),
          );

          debugPrint(
            "ABRIENDO CHAT DE SOPORTE DEL CLIENTE.",
          );

          return;
        }

        // =================================================
        // ADMIN RECIBE MENSAJE DEL CLIENTE
        // =================================================

        if (senderRole == "client") {
          final clientSnapshot =
          await _firestore
              .collection("users")
              .doc(clientId)
              .get();

          if (!clientSnapshot.exists) {
            debugPrint(
              "NO SE ENCONTRÓ EL CLIENTE: $clientId",
            );
            return;
          }

          final clientData =
              clientSnapshot.data() ?? {};

          final clientEmail =
              clientData["email"]?.toString() ??
                  "";

          navigator.push(
            MaterialPageRoute(
              builder: (_) =>
                  AdminSupportChatDetailScreen(
                    clientId:
                    clientId,
                    clientEmail:
                    clientEmail,
                  ),
            ),
          );

          debugPrint(
            "ABRIENDO CHAT DE SOPORTE DEL ADMIN.",
          );

          return;
        }

        debugPrint(
          "senderRole desconocido en soporte: "
              "$senderRole",
        );

        return;
      }

      // =================================================
// PAGO PREMIUM APROBADO
// =================================================

      if (type == "evaluation_payment_approved") {
        final evaluationId =
            data["evaluationId"]?.toString() ??
                expedienteId;

        if (evaluationId.isEmpty) {
          debugPrint(
            "NO SE PUEDE NAVEGAR: FALTA evaluationId.",
          );
          return;
        }

        final evaluationSnapshot =
        await _firestore
            .collection("evaluations")
            .doc(evaluationId)
            .get();

        if (!evaluationSnapshot.exists) {
          debugPrint(
            "NO SE ENCONTRÓ LA EVALUACIÓN: "
                "$evaluationId",
          );
          return;
        }

        final evaluationData =
            evaluationSnapshot.data() ??
                {};

        final countryCode =
            evaluationData["countryCode"]?.toString() ??
                "";

        final visaType =
            evaluationData["visaType"]?.toString() ??
                "";

        if (countryCode.isEmpty ||
            visaType.isEmpty) {
          debugPrint(
            "FALTAN DATOS DE LA EVALUACIÓN: "
                "countryCode=$countryCode, "
                "visaType=$visaType",
          );
          return;
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                EvaluationQuestionScreen(
                  evaluationId: evaluationId,
                  countryCode: countryCode,
                  visaType: visaType,
                ),
          ),
        );

        debugPrint(
          "ABRIENDO EVALUACIÓN PREMIUM "
              "DESDE LA PREGUNTA 11.",
        );

        return;
      }

// =================================================
// PAGO PREMIUM RECHAZADO
// =================================================

      if (type == "evaluation_payment_rejected") {
        final evaluationId =
            data["evaluationId"]?.toString() ??
                expedienteId;

        if (evaluationId.isEmpty) {
          debugPrint(
            "NO SE PUEDE NAVEGAR: FALTA evaluationId.",
          );
          return;
        }

        final navigator =
            navigatorKey.currentState;

        if (navigator == null) {
          debugPrint(
            "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
          );
          return;
        }

        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                PaymentScreen(
                  evaluationId: evaluationId,
                ),
          ),
        );

        debugPrint(
          "ABRIENDO PANTALLA DE PAGO PREMIUM "
              "POR PAGO RECHAZADO.",
        );

        return;
      }

      // =================================================
      // NOTIFICACIONES QUE PERTENECEN A UN EXPEDIENTE
      // =================================================

      const expedienteNotificationTypes = {
        "ds160_uploaded",
        "cas_credentials_updated",
        "cas_appointment_updated",
        "interview_appointment_updated",
        "service_payment_approved",
        "service_payment_rejected",
      };

      if (!expedienteNotificationTypes.contains(type)) {
        debugPrint(
          "NOTIFICACIÓN SIN NAVEGACIÓN DE EXPEDIENTE: "
              "$type",
        );
        return;
      }

      if (expedienteId.isEmpty) {
        debugPrint(
          "NO SE PUEDE NAVEGAR: "
              "LA NOTIFICACIÓN NO TIENE expedienteId.",
        );
        return;
      }

      // =================================================
      // OBTENER EL EXPEDIENTE EXACTO
      // =================================================

      final expediente =
      await ExpedienteService()
          .getExpedienteById(expedienteId);

      if (expediente == null) {
        debugPrint(
          "NO SE ENCONTRÓ EL EXPEDIENTE: "
              "$expedienteId",
        );
        return;
      }

      // =================================================
      // ESPERAR A QUE EL NAVIGATOR ESTÉ DISPONIBLE
      // =================================================

      final navigator =
          navigatorKey.currentState;

      if (navigator == null) {
        debugPrint(
          "NAVIGATOR AÚN NO ESTÁ DISPONIBLE.",
        );
        return;
      }

      // =================================================
      // ABRIR PROCESO VISA ASSIST
      // =================================================

      navigator.push(
        MaterialPageRoute(
          builder: (_) =>
              VisaAssistProcessScreen(
                expediente: expediente,
              ),
        ),
      );

      debugPrint(
        "NAVEGACIÓN REALIZADA CORRECTAMENTE.",
      );

      debugPrint(
        "TIPO: $type",
      );

      debugPrint(
        "EXPEDIENTE: ${expediente.id}",
      );

      debugPrint(
        "========================================",
      );
    } catch (e, stackTrace) {
      debugPrint(
        "ERROR PROCESANDO NAVEGACIÓN: $e",
      );

      debugPrint(
        "STACK TRACE: $stackTrace",
      );
    }
  }

  // =====================================================
// NAVEGAR DESDE EL CENTRO DE NOTIFICACIONES
// =====================================================

  Future<void> handleNotificationData(
      Map<String, dynamic> data,
      ) async {
    await _handleNotificationData(data);
  }

  // =====================================================
  // AL TOCAR NOTIFICACIÓN LOCAL
  // =====================================================

  void _onNotificationTapped(
      NotificationResponse response,
      ) {
    debugPrint(
      "NOTIFICACIÓN LOCAL TOCADA.",
    );

    debugPrint(
      "PAYLOAD: ${response.payload}",
    );

    if (response.payload == null ||
        response.payload!.isEmpty) {
      return;
    }

    try {
      final payload =
      response.payload!;

      final decoded =
      jsonDecode(payload);

      if (decoded is! Map) {
        debugPrint(
          "PAYLOAD DE NOTIFICACIÓN NO ES UN MAPA.",
        );
        return;
      }

      final data =
      Map<String, dynamic>.from(decoded);

      _handleNotificationData(data);
    } catch (e) {
      debugPrint(
        "ERROR LEYENDO PAYLOAD LOCAL: $e",
      );
    }
  }

  // =====================================================
  // GUARDAR TOKEN PARA USUARIO ESPECÍFICO
  // =====================================================

  Future<void> _saveTokenForUser({
    required String userId,
    required String token,
  }) async {
    try {
      final currentUser =
          _auth.currentUser;

      // =================================================
      // SEGURIDAD:
      // SOLO guardamos el token si el usuario que está
      // autenticado sigue siendo el mismo.
      // =================================================

      if (currentUser == null) {
        debugPrint(
          "NO HAY USUARIO PARA GUARDAR TOKEN.",
        );
        return;
      }

      if (currentUser.uid != userId) {
        debugPrint(
          "TOKEN IGNORADO: EL UID YA CAMBIÓ.",
        );
        return;
      }

      await _firestore
          .collection("users")
          .doc(userId)
          .set(
        {
          "fcmToken": token,
          "updatedAt": Timestamp.now(),
        },
        SetOptions(merge: true),
      );

      debugPrint(
        "========================================",
      );

      debugPrint(
        "FCM TOKEN GUARDADO CORRECTAMENTE",
      );

      debugPrint(
        "USUARIO: $userId",
      );

      debugPrint(
        "========================================",
      );
    } catch (e) {
      debugPrint(
        "ERROR GUARDANDO TOKEN FCM: $e",
      );
    }
  }

  // =====================================================
  // ELIMINAR TOKEN AL CERRAR SESIÓN
  // =====================================================

  Future<void> clearToken() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        debugPrint(
          "CLEAR TOKEN: NO HAY USUARIO.",
        );
        return;
      }

      // =================================================
      // 1. ELIMINAR EL TOKEN DE LA CUENTA EN FIRESTORE
      // =================================================

      await _firestore
          .collection("users")
          .doc(user.uid)
          .set(
        {
          "fcmToken": null,
          "updatedAt": Timestamp.now(),
        },
        SetOptions(merge: true),
      );

      debugPrint(
        "FCM TOKEN ELIMINADO DE "
            "users/${user.uid}",
      );

      // =================================================
      // 2. ELIMINAR EL TOKEN FCM DEL DISPOSITIVO
      //
      // Esto evita que el dispositivo siga asociado
      // al token anterior mientras otra cuenta inicia
      // sesión.
      // =================================================

      await _messaging.deleteToken();

      debugPrint(
        "FCM TOKEN ELIMINADO DEL DISPOSITIVO.",
      );
    } catch (e) {
      debugPrint(
        "ERROR ELIMINANDO FCM TOKEN: $e",
      );
    }
  }

  // =====================================================
  // CREAR NOTIFICACIÓN EN FIRESTORE
  // =====================================================

  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? expedienteId,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("notifications")
          .add(
        {
          "title": title,
          "message": message,
          "type": type,
          "expedienteId": expedienteId,
          "data": data ?? {},
          "read": false,
          "createdAt": Timestamp.now(),
        },
      );

      debugPrint(
        "NOTIFICACIÓN CREADA PARA $userId",
      );
    } catch (e) {
      debugPrint(
        "ERROR CREANDO NOTIFICACIÓN: $e",
      );

      rethrow;
    }
  }

  // =====================================================
  // NOTIFICAR A TODOS LOS ADMINISTRADORES
  // =====================================================

  Future<void> notifyAdmins({
    required String title,
    required String message,
    required String type,
    String? expedienteId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final admins =
      await _firestore
          .collection("users")
          .where(
        "role",
        isEqualTo: "admin",
      )
          .get();

      debugPrint(
        "ADMINISTRADORES ENCONTRADOS: "
            "${admins.docs.length}",
      );

      for (final admin in admins.docs) {
        await createNotification(
          userId: admin.id,
          title: title,
          message: message,
          type: type,
          expedienteId: expedienteId,
          data: data,
        );
      }
    } catch (e) {
      debugPrint(
        "ERROR NOTIFICANDO ADMINISTRADORES: $e",
      );
    }
  }

  // =====================================================
  // MARCAR COMO LEÍDA
  // =====================================================

  Future<void> markAsRead({
    required String notificationId,
  }) async {
    final user =
        _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .doc(notificationId)
        .update(
      {
        "read": true,
      },
    );
  }

  // =====================================================
  // MARCAR TODAS COMO LEÍDAS
  // =====================================================

  Future<void> markAllAsRead() async {
    final user =
        _auth.currentUser;

    if (user == null) {
      return;
    }

    final snapshot =
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .where(
      "read",
      isEqualTo: false,
    )
        .get();

    final batch =
    _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          "read": true,
        },
      );
    }

    await batch.commit();
  }

  // =====================================================
  // ESCUCHAR NOTIFICACIONES
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  watchMyNotifications() {
    final user =
        _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .orderBy(
      "createdAt",
      descending: true,
    )
        .snapshots();
  }

  // =====================================================
  // CONTAR NO LEÍDAS
  // =====================================================

  Stream<int> watchUnreadCount() {
    final user =
        _auth.currentUser;

    if (user == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .where(
      "read",
      isEqualTo: false,
    )
        .snapshots()
        .map(
          (snapshot) =>
      snapshot.docs.length,
    );
  }
}