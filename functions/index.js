const {setGlobalOptions} = require("firebase-functions");

const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");

const {
  initializeApp,
} = require("firebase-admin/app");

const {
  getFirestore,
} = require("firebase-admin/firestore");

const {
  getMessaging,
} = require("firebase-admin/messaging");

const logger = require("firebase-functions/logger");

initializeApp();

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

// ============================================================
// ENVIAR PUSH CUANDO SE CREA UNA NOTIFICACIÓN
// ============================================================

exports.sendNotificationPush = onDocumentCreated(
    "users/{userId}/notifications/{notificationId}",
    async (event) => {
      try {
        const notificationSnapshot = event.data;

        if (!notificationSnapshot) {
          logger.warn(
              "No se encontró el documento de notificación.",
          );
          return;
        }

        const notification =
            notificationSnapshot.data() || {};

        const userId =
            event.params.userId;

        const notificationId =
            event.params.notificationId;

        // ======================================================
        // OBTENER USUARIO
        // ======================================================

        const userSnapshot =
            await getFirestore()
                .collection("users")
                .doc(userId)
                .get();

        if (!userSnapshot.exists) {
          logger.warn(
              `No existe el usuario ${userId}.`,
          );
          return;
        }

        const userData =
            userSnapshot.data() || {};

        const fcmToken =
            userData.fcmToken;

        if (!fcmToken) {
          logger.info(
              `El usuario ${userId} no tiene FCM token.`,
          );
          return;
        }

        // ======================================================
        // DATOS PRINCIPALES
        // ======================================================

        const title =
            notification.title ||
            "Visa Assist";

        const body =
            notification.message ||
            "Tienes una nueva notificación.";

        const type =
            notification.type ||
            "general";

        const expedienteId =
            notification.expedienteId ||
            "";

        // ======================================================
        // TRANSMITIR TAMBIÉN TODOS LOS DATOS ADICIONALES
        //
        // FCM exige que los valores dentro de data sean strings.
        // ======================================================

        const notificationData =
            notification.data || {};

        const data = {
          notificationId:
              String(notificationId),

          type:
              String(type),

          expedienteId:
              String(expedienteId),

          click_action:
              "FLUTTER_NOTIFICATION_CLICK",
        };

        for (
          const [key, value]
          of Object.entries(notificationData)
        ) {
          if (
            value !== null &&
            value !== undefined
          ) {
            data[key] =
                typeof value === "string"
                    ? value
                    : JSON.stringify(value);
          }
        }

        // ======================================================
        // MENSAJE FCM
        // ======================================================

        const message = {
          token: fcmToken,

          notification: {
            title: title,
            body: body,
          },

          data: data,

          android: {
            priority: "high",

            notification: {
              channelId:
                  "visa_assist_notifications_v2",

              sound:
                  "default",

              defaultSound:
                  true,

              defaultVibrateTimings:
                  true,

              defaultLightSettings:
                  true,
            },
          },

          apns: {
            headers: {
              "apns-priority": "10",
            },

            payload: {
              aps: {
                alert: {
                  title: title,
                  body: body,
                },

                sound:
                    "default",

                badge:
                    1,

                "content-available":
                    1,
              },
            },
          },
        };

        const response =
            await getMessaging().send(message);

        logger.info(
            "NOTIFICACIÓN PUSH ENVIADA",
            {
              userId: userId,
              notificationId:
                  notificationId,
              messageId:
                  response,
              type:
                  type,
            },
        );
      } catch (error) {
        logger.error(
            "ERROR ENVIANDO NOTIFICACIÓN PUSH",
            error,
        );

        // ======================================================
        // LIMPIAR TOKEN INVÁLIDO
        // ======================================================

        if (
          error.code ===
          "messaging/registration-token-not-registered"
        ) {
          try {
            const userId =
                event.params.userId;

            await getFirestore()
                .collection("users")
                .doc(userId)
                .update({
                  fcmToken: null,
                });

            logger.info(
                `Token FCM eliminado para ${userId}.`,
            );
          } catch (cleanupError) {
            logger.error(
                "ERROR ELIMINANDO TOKEN FCM",
                cleanupError,
            );
          }
        }
      }
    },
);

// ============================================================
// CREAR NOTIFICACIÓN PARA ADMINISTRADORES
// CUANDO LLEGA UN PAGO
// ============================================================

exports.notifyAdminsOnPaymentCreated =
onDocumentCreated(
    "payments/{paymentId}",
    async (event) => {
      try {
        const paymentSnapshot =
            event.data;

        if (!paymentSnapshot) {
          logger.warn(
              "No se encontró el documento del pago.",
          );
          return;
        }

        const payment =
            paymentSnapshot.data() || {};

        const paymentId =
            event.params.paymentId;

        const paymentType =
            payment.paymentType || "";

        const expedienteId =
            payment.expedienteId || "";

        const amount =
            payment.amount || 0;

        const currency =
            payment.currency || "";

        const status =
            payment.status || "";

        // ======================================================
        // SOLO PAGOS PENDIENTES
        // ======================================================

        if (status !== "pending") {
          logger.info(
              `Pago ${paymentId} ignorado porque ` +
              `su estado es ${status}.`,
          );
          return;
        }

        let title = "";
        let message = "";
        let type = "";

        if (paymentType === "evaluation") {
          title =
              "Nuevo pago Premium";

          message =
              "Un cliente ha enviado un comprobante " +
              "para desbloquear la evaluación Premium.";

          type =
              "evaluation_payment_received";
        } else if (paymentType === "service") {
          title =
              "Nuevo pago del servicio";

          message =
              "Un cliente ha enviado un comprobante " +
              "de pago para el servicio Visa Assist.";

          type =
              "service_payment_received";
        } else {
          logger.info(
              `Pago ${paymentId} de tipo ` +
              `${paymentType} ignorado.`,
          );

          return;
        }

        // ======================================================
        // BUSCAR ADMINISTRADORES
        // ======================================================

        const adminsSnapshot =
            await getFirestore()
                .collection("users")
                .where(
                    "role",
                    "==",
                    "admin",
                )
                .get();

        if (adminsSnapshot.empty) {
          logger.warn(
              "No se encontraron administradores.",
          );
          return;
        }

        // ======================================================
        // CREAR NOTIFICACIONES
        // ======================================================

        const batch =
            getFirestore().batch();

        for (
          const adminDoc
          of adminsSnapshot.docs
        ) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(adminDoc.id)
                  .collection("notifications")
                  .doc();

          batch.set(
              notificationRef,
              {
                title:
                    title,

                message:
                    message,

                type:
                    type,

                expedienteId:
                    expedienteId,

                data: {
                  paymentId:
                      paymentId,

                  paymentType:
                      paymentType,

                  amount:
                      amount,

                  currency:
                      currency,
                },

                read:
                    false,

                createdAt:
                    new Date(),
              },
          );
        }

        await batch.commit();

        logger.info(
            "NOTIFICACIONES DE PAGO CREADAS PARA ADMINISTRADORES",
            {
              paymentId:
                  paymentId,

              paymentType:
                  paymentType,

              admins:
                  adminsSnapshot.size,
            },
        );
      } catch (error) {
        logger.error(
            "ERROR CREANDO NOTIFICACIONES PARA ADMINISTRADORES",
            error,
        );
      }
    },
);

// ============================================================
// NOTIFICACIONES DE ACTUALIZACIÓN DEL PROCESO DE VISA
// DS-160 / CAS / ENTREVISTA
// ============================================================

exports.notifyVisaProcessUpdated =
onDocumentUpdated(
    "expedientes/{expedienteId}",
    async (event) => {
      try {
        const beforeSnapshot =
            event.data.before;

        const afterSnapshot =
            event.data.after;

        if (
          !beforeSnapshot.exists ||
          !afterSnapshot.exists
        ) {
          return;
        }

        const before =
            beforeSnapshot.data() || {};

        const after =
            afterSnapshot.data() || {};

        const expedienteId =
            event.params.expedienteId;

        const userId =
            after.userId || "";

        if (!userId) {
          logger.warn(
              `El expediente ${expedienteId} no tiene userId.`,
          );
          return;
        }

        const beforeVisa =
            before.visaProcessInformation || {};

        const afterVisa =
            after.visaProcessInformation || {};

        // ======================================================
        // 1. PERFIL CAS
        // ======================================================

        const beforeCasUsername =
            beforeVisa.casUsername || "";

        const afterCasUsername =
            afterVisa.casUsername || "";

        const beforeCasPassword =
            beforeVisa.casPassword || "";

        const afterCasPassword =
            afterVisa.casPassword || "";

        const casCredentialsChanged =
            beforeCasUsername !== afterCasUsername ||
            beforeCasPassword !== afterCasPassword;

        if (
          casCredentialsChanged &&
          (
            afterCasUsername !== "" ||
            afterCasPassword !== ""
          )
        ) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(userId)
                  .collection("notifications")
                  .doc();

          await notificationRef.set({
            title:
                "Perfil CAS actualizado",

            message:
                "Tu usuario y contraseña del perfil CAS " +
                "han sido registrados por nuestro equipo. " +
                "Ya puedes consultarlos desde tu expediente.",

            type:
                "cas_credentials_updated",

            expedienteId:
                expedienteId,

            data: {
              expedienteId:
                  expedienteId,
            },

            read:
                false,

            createdAt:
                new Date(),
          });
        }

        // ======================================================
        // 2. DS-160
        // ======================================================

        const beforeDs160Url =
            beforeVisa.ds160PdfUrl || "";

        const afterDs160Url =
            afterVisa.ds160PdfUrl || "";

        if (
          beforeDs160Url !== afterDs160Url &&
          afterDs160Url !== ""
        ) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(userId)
                  .collection("notifications")
                  .doc();

          await notificationRef.set({
            title:
                "DS-160 disponible",

            message:
                "Tu formulario DS-160 ha sido cargado por " +
                "nuestro equipo. Ya puedes consultarlo " +
                "desde tu expediente.",

            type:
                "ds160_uploaded",

            expedienteId:
                expedienteId,

            data: {
              expedienteId:
                  expedienteId,

              ds160FileName:
                  afterVisa.ds160FileName || "",

              ds160PdfUrl:
                  afterDs160Url,
            },

            read:
                false,

            createdAt:
                new Date(),
          });
        }

        // ======================================================
        // 3. CITA CAS
        // ======================================================

        const beforeCasDate =
            before.casAppointmentDate || "";

        const afterCasDate =
            after.casAppointmentDate || "";

        const beforeCasTime =
            before.casAppointmentTime || "";

        const afterCasTime =
            after.casAppointmentTime || "";

        const beforeCasLocation =
            before.casLocation || "";

        const afterCasLocation =
            after.casLocation || "";

        const casChanged =
            beforeCasDate !== afterCasDate ||
            beforeCasTime !== afterCasTime ||
            beforeCasLocation !== afterCasLocation;

        if (
          casChanged &&
          (
            afterCasDate !== "" ||
            afterCasTime !== ""
          )
        ) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(userId)
                  .collection("notifications")
                  .doc();

          await notificationRef.set({
            title:
                "Cita de huellas y foto disponible",

            message:
                "Tu cita para huellas y fotografía ha sido " +
                "registrada. Consulta la fecha, hora y " +
                "ubicación en tu expediente.",

            type:
                "cas_appointment_updated",

            expedienteId:
                expedienteId,

            data: {
              expedienteId:
                  expedienteId,

              date:
                  afterCasDate,

              time:
                  afterCasTime,

              location:
                  afterCasLocation,
            },

            read:
                false,

            createdAt:
                new Date(),
          });
        }

        // ======================================================
        // 4. ENTREVISTA CONSULAR
        // ======================================================

        const beforeInterviewDate =
            before.interviewDate || "";

        const afterInterviewDate =
            after.interviewDate || "";

        const beforeInterviewTime =
            before.interviewTime || "";

        const afterInterviewTime =
            after.interviewTime || "";

        const beforeInterviewLocation =
            before.interviewLocation || "";

        const afterInterviewLocation =
            after.interviewLocation || "";

        const interviewChanged =
            beforeInterviewDate !== afterInterviewDate ||
            beforeInterviewTime !== afterInterviewTime ||
            beforeInterviewLocation !==
                afterInterviewLocation;

        if (
          interviewChanged &&
          (
            afterInterviewDate !== "" ||
            afterInterviewTime !== ""
          )
        ) {
          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(userId)
                  .collection("notifications")
                  .doc();

          await notificationRef.set({
            title:
                "Cita consular disponible",

            message:
                "Tu entrevista consular ha sido registrada. " +
                "Consulta la fecha, hora y ubicación " +
                "en tu expediente.",

            type:
                "interview_appointment_updated",

            expedienteId:
                expedienteId,

            data: {
              expedienteId:
                  expedienteId,

              date:
                  afterInterviewDate,

              time:
                  afterInterviewTime,

              location:
                  afterInterviewLocation,
            },

            read:
                false,

            createdAt:
                new Date(),
          });
        }
      } catch (error) {
        logger.error(
            "ERROR EN NOTIFICACIONES DEL PROCESO DE VISA",
            error,
        );
      }
    },
);

// ============================================================
// NOTIFICACIONES DEL CHAT DE SOPORTE
//
// CLIENTE → ADMINISTRADORES
// ADMINISTRADOR → CLIENTE
//
// Funciona independientemente de si el dispositivo es:
// Android o iPhone.
// ============================================================

exports.notifySupportChatMessage =
onDocumentCreated(
    "support_conversations/{clientId}/messages/{messageId}",
    async (event) => {
      try {
        const messageSnapshot =
            event.data;

        if (!messageSnapshot) {
          logger.warn(
              "No se encontró el mensaje de soporte.",
          );
          return;
        }

        const message =
            messageSnapshot.data() || {};

        const clientId =
            event.params.clientId;

        const messageId =
            event.params.messageId;

        const senderRole =
            message.senderRole || "";

        const messageType =
            message.messageType || "text";

        // ======================================================
        // CLIENTE → ADMINISTRADORES
        // ======================================================

        if (senderRole === "client") {
          const adminsSnapshot =
              await getFirestore()
                  .collection("users")
                  .where(
                      "role",
                      "==",
                      "admin",
                  )
                  .get();

          if (adminsSnapshot.empty) {
            logger.warn(
                "No se encontraron administradores " +
                "para notificar.",
            );
            return;
          }

          const batch =
              getFirestore().batch();

          const title =
              "Nuevo mensaje de soporte";

          const body =
              messageType === "image"
                  ? "Un cliente ha enviado una foto."
                  : "Un cliente ha enviado un nuevo mensaje.";

          for (
            const adminDoc
            of adminsSnapshot.docs
          ) {
            const notificationRef =
                getFirestore()
                    .collection("users")
                    .doc(adminDoc.id)
                    .collection("notifications")
                    .doc();

            batch.set(
                notificationRef,
                {
                  title:
                      title,

                  message:
                      body,

                  type:
                      "support_message_received",

                  expedienteId:
                      "",

                  data: {
                    clientId:
                        clientId,

                    messageId:
                        messageId,

                    messageType:
                        messageType,

                    senderRole:
                        "client",
                  },

                  read:
                      false,

                  createdAt:
                      new Date(),
                },
            );
          }

          await batch.commit();

          logger.info(
              "NOTIFICACIONES DE SOPORTE ENVIADAS A ADMINISTRADORES",
              {
                clientId:
                    clientId,

                messageId:
                    messageId,

                admins:
                    adminsSnapshot.size,
              },
          );

          return;
        }

        // ======================================================
        // ADMINISTRADOR → CLIENTE
        // ======================================================

        if (senderRole === "admin") {
          const clientSnapshot =
              await getFirestore()
                  .collection("users")
                  .doc(clientId)
                  .get();

          if (!clientSnapshot.exists) {
            logger.warn(
                `No existe el cliente ${clientId}.`,
            );
            return;
          }

          const notificationRef =
              getFirestore()
                  .collection("users")
                  .doc(clientId)
                  .collection("notifications")
                  .doc();

          const title =
              "Nuevo mensaje de soporte";

          const body =
              messageType === "image"
                  ? "Soporte te ha enviado una foto."
                  : "Soporte te ha enviado un nuevo mensaje.";

          await notificationRef.set({
            title:
                title,

            message:
                body,

            type:
                "support_message_received",

            expedienteId:
                "",

            data: {
              clientId:
                  clientId,

              messageId:
                  messageId,

              messageType:
                  messageType,

              senderRole:
                  "admin",
            },

            read:
                false,

            createdAt:
                new Date(),
          });

          logger.info(
              "NOTIFICACIÓN DE SOPORTE ENVIADA AL CLIENTE",
              {
                clientId:
                    clientId,

                messageId:
                    messageId,
              },
          );

          return;
        }

        logger.info(
            `Mensaje ${messageId} ignorado. ` +
            `senderRole=${senderRole}`,
        );
      } catch (error) {
        logger.error(
            "ERROR EN NOTIFICACIÓN DEL CHAT DE SOPORTE",
            error,
        );
      }
    },
);