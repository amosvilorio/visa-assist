import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
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
      // CONFIGURAR NOTIFICACIONES LOCALES
      // =================================================

      const androidSettings =
      AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const initializationSettings =
      InitializationSettings(
        android: androidSettings,
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
              payload: message.data.toString(),
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
      final user =
          _auth.currentUser;

      if (user == null) {
        debugPrint(
          "CLEAR TOKEN: NO HAY USUARIO.",
        );
        return;
      }

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